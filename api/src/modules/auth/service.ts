import crypto from "node:crypto";
import jwt from "jsonwebtoken";
import { z } from "zod";
import { otpChallenges, users } from "../../common/store.js";
import { User } from "../../common/types.js";
import { requireEnv } from "../../common/env.js";

const signupSchema = z.object({ email: z.string().email(), password: z.string().min(8) });
const otpSchema = z.object({ email: z.string().email(), code: z.string().length(6) });

export function signup(input: unknown): User {
  const data = signupSchema.parse(input);
  const existing = Array.from(users.values()).find((u) => u.email === data.email);
  if (existing) throw new Error("email_exists");

  const user: User = {
    id: crypto.randomUUID(),
    email: data.email,
    passwordHash: hash(data.password),
    verificationStatus: "unverified",
    createdAt: new Date().toISOString()
  };
  users.set(user.id, user);
  return user;
}

export function createOtp(email: string): void {
  const code = String(Math.floor(100000 + Math.random() * 900000));
  otpChallenges.set(email, { code, expiresAt: Date.now() + 5 * 60_000, attempts: 0 });
}

export function verifyOtp(input: unknown): boolean {
  const data = otpSchema.parse(input);
  const challenge = otpChallenges.get(data.email);
  if (!challenge) return false;
  if (Date.now() > challenge.expiresAt || challenge.attempts >= 5) return false;
  challenge.attempts += 1;
  return challenge.code === data.code;
}

export function login(email: string, password: string): string {
  const user = Array.from(users.values()).find((u) => u.email === email);
  if (!user || user.passwordHash !== hash(password)) throw new Error("invalid_credentials");
  return jwt.sign({ sub: user.id, email: user.email }, requireEnv("JWT_SECRET"), { expiresIn: "1h" });
}

function hash(input: string): string {
  return crypto.createHash("sha256").update(input).digest("hex");
}
