import { Profile, User } from "./types.js";

export const users = new Map<string, User>();
export const profiles = new Map<string, Profile>();
export const otpChallenges = new Map<string, { code: string; expiresAt: number; attempts: number }>();
