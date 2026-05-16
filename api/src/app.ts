import express, { Request, Response } from "express";
import { z } from "zod";
import { login, signup, createOtp, verifyOtp } from "./modules/auth/service.js";

export const app = express();
app.use(express.json());

app.get("/health", (_req: Request, res: Response) => res.status(200).json({ status: "ok" }));

app.post("/auth/signup", (req: Request, res: Response) => {
  try {
    const user = signup(req.body);
    createOtp(user.email);
    res.status(201).json({ id: user.id, verificationStatus: user.verificationStatus });
  } catch (error) {
    res.status(400).json({ error: serializeError(error) });
  }
});

app.post("/auth/login", (req: Request, res: Response) => {
  try {
    const body = z.object({ email: z.string().email(), password: z.string().min(8) }).parse(req.body);
    const accessToken = login(body.email, body.password);
    res.status(200).json({ accessToken });
  } catch (error) {
    res.status(401).json({ error: serializeError(error) });
  }
});

app.post("/auth/otp/verify", (req: Request, res: Response) => {
  try {
    const ok = verifyOtp(req.body);
    res.status(ok ? 200 : 400).json({ verified: ok });
  } catch (error) {
    res.status(400).json({ error: serializeError(error) });
  }
});

function serializeError(error: unknown): string {
  if (error instanceof Error) return error.message;
  return "unknown_error";
}
