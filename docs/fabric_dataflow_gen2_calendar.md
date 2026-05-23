# Fabric Dataflow Gen2 — Unified Calendar Normalization

This specification standardizes date fields from `Projection`, `BPCData`, `Order Pipeline`, and `RefSR` into a single ISO calendar convention and joins each curated table to a shared calendar dimension.

## 1) Canonical date convention

- Output calendar date column: `calendar_date` (`date`, ISO `yyyy-MM-dd`).
- Derived attributes:
  - `year` (ISO year)
  - `month` (1–12)
  - `week` (ISO week number)
  - `rdd_month` (`yyyy-MM`, zero-padded month)

## 2) Reusable Dataflow M helper

Create a reusable function query in Dataflow Gen2 named `fnNormalizeDate`:

```powerquery
(dateValue as any) as nullable date =>
let
    fromDate = try Date.From(dateValue) otherwise null,
    fromDateTime = if fromDate = null then (try Date.From(DateTime.From(dateValue)) otherwise null) else fromDate,
    fromTextISO =
        if fromDateTime = null then
            (try Date.FromText(Text.From(dateValue), [Format = "yyyy-MM-dd"]) otherwise null)
        else
            fromDateTime,
    fromTextUS =
        if fromTextISO = null then
            (try Date.FromText(Text.From(dateValue), [Format = "M/d/yyyy"]) otherwise null)
        else
            fromTextISO,
    normalized = fromTextUS
in
    normalized
```

> If source systems include additional formats (for example `dd/MM/yyyy`), extend the fallback parsing chain in this function.

## 3) Normalize each curated table

For each query (`Projection`, `BPCData`, `Order Pipeline`, `RefSR`):

1. Identify source date-like columns (for example: `Date`, `RDD`, `ShipDate`, `CreatedOn`, `ForecastDate`).
2. Add a standardized date key column using `fnNormalizeDate`:

```powerquery
= Table.AddColumn(#"Previous Step", "calendar_date", each fnNormalizeDate([<date_like_column>]), type date)
```

3. Add calendar derivations:

```powerquery
= Table.AddColumn(#"Added calendar_date", "year", each Date.Year([calendar_date]), Int64.Type)
= Table.AddColumn(#"Added year", "month", each Date.Month([calendar_date]), Int64.Type)
= Table.AddColumn(#"Added month", "week", each Date.WeekOfYear([calendar_date], Day.Monday), Int64.Type)
= Table.AddColumn(#"Added week", "rdd_month", each Date.ToText([calendar_date], "yyyy-MM"), type text)
```

4. Remove rows where `calendar_date` is null **only if** invalid dates should be excluded from reporting; otherwise retain for data quality tracking.

## 4) Create calendar dimension table

Create a new query named `dim_calendar`:

```powerquery
let
    SourceDates = List.Combine({
        List.RemoveNulls(Projection[calendar_date]),
        List.RemoveNulls(BPCData[calendar_date]),
        List.RemoveNulls(#"Order Pipeline"[calendar_date]),
        List.RemoveNulls(RefSR[calendar_date])
    }),
    MinDate = List.Min(SourceDates),
    MaxDate = List.Max(SourceDates),
    DateList = List.Dates(MinDate, Duration.Days(MaxDate - MinDate) + 1, #duration(1,0,0,0)),
    CalendarTable = Table.FromList(DateList, Splitter.SplitByNothing(), {"calendar_date"}, null, ExtraValues.Error),
    Typed = Table.TransformColumnTypes(CalendarTable, {{"calendar_date", type date}}),
    AddYear = Table.AddColumn(Typed, "year", each Date.Year([calendar_date]), Int64.Type),
    AddMonth = Table.AddColumn(AddYear, "month", each Date.Month([calendar_date]), Int64.Type),
    AddWeek = Table.AddColumn(AddMonth, "week", each Date.WeekOfYear([calendar_date], Day.Monday), Int64.Type),
    AddRDDMonth = Table.AddColumn(AddWeek, "rdd_month", each Date.ToText([calendar_date], "yyyy-MM"), type text),
    AddDateKey = Table.AddColumn(AddRDDMonth, "date_key", each Date.ToText([calendar_date], "yyyyMMdd"), type text)
in
    AddDateKey
```

## 5) Join curated tables to the calendar dimension

For each curated table, merge to `dim_calendar` by `calendar_date` (left outer):

```powerquery
= Table.NestedJoin(
    #"Your Curated Table",
    {"calendar_date"},
    dim_calendar,
    {"calendar_date"},
    "dim_calendar",
    JoinKind.LeftOuter
)
```

Expand `dim_calendar` columns as needed (`date_key`, `year`, `month`, `week`, `rdd_month`).

## 6) Output contract

All curated output tables should expose:

- `calendar_date` (ISO date)
- `date_key`
- `year`
- `month`
- `week`
- `rdd_month`

This enforces one calendar convention across `Projection`, `BPCData`, `Order Pipeline`, and `RefSR`.
