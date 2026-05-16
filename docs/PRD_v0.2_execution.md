# Cove PRD v0.2 — Execution Document

## Sprint Plan (1–6)

### Sprint 1 — Foundation
- Monorepo/bootstrap
- Auth skeleton (email + OTP)
- Core schema (`users`, `profiles`, `verification_requests`, `matches`, `messages`, `reports`)
- Secrets/encryption baseline

### Sprint 2 — Onboarding & Verification
- Signup/login complete
- Anonymous profile CRUD
- Verification intake + manual review queue

### Sprint 3 — Discovery & Matching
- Discovery feed
- Matching actions (like/pass)
- Filter pipeline (age/radius/interests/verified)

### Sprint 4 — Secure Messaging
- E2EE envelope model
- Disappearing messages
- Expiring private media
- Screenshot deterrence capabilities by platform

### Sprint 5 — Safety Engine
- Reporting & block
- Moderation queue + SLA routing
- Trust score v1 with threshold actions

### Sprint 6 — Beta Hardening
- Observability + audit logs
- Performance tuning
- Invite-only beta rollout

## MVP Epics and DoD

### Epic A: Authentication
**Stories**
1. User can sign up with email/password.
2. User can verify phone/email OTP.
3. User can reset password.

**Definition of Done**
- Session tokens rotated and expiring.
- OTP attempts rate-limited.
- Audit event emitted for auth state changes.

### Epic B: Verification
**Stories**
1. User submits selfie + liveness check.
2. Reviewer approves/rejects submission.

**DoD**
- Status transitions: `pending -> approved/rejected` validated.
- Rejected requests include reason codes.

### Epic C: Matching
**Stories**
1. User sees discoverable profiles.
2. User likes/passes profile.
3. Mutual like creates match.

**DoD**
- Duplicate likes prevented.
- Match event emitted exactly once.

### Epic D: Messaging
**Stories**
1. Matched users can exchange encrypted payloads.
2. Media can expire automatically.

**DoD**
- Message envelope schema validated.
- Expired content hidden by default.

### Epic E: Safety & Moderation
**Stories**
1. User can report and block another user.
2. Moderator triages cases by severity.

**DoD**
- Sev-1 alert generated immediately.
- Case timeline persisted and queryable.

## KPI Instrumentation (Minimum)
- `signup_completed`
- `verification_submitted`
- `verification_resolved`
- `match_created`
- `first_message_sent`
- `report_submitted`
- `report_resolved`
- `trust_score_changed`
