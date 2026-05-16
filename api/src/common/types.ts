export type VerificationStatus = "unverified" | "pending_review" | "verified" | "rejected";

export interface User {
  id: string;
  email: string;
  passwordHash: string;
  verificationStatus: VerificationStatus;
  createdAt: string;
}

export interface Profile {
  userId: string;
  nickname: string;
  bio?: string;
  visibility: {
    hideDistance: boolean;
    discoverable: boolean;
  };
}
