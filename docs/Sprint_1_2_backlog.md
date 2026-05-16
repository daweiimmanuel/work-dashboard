# Cove Sprint 1–2 Backlog (Jira-ready)

## Sprint 1 (P0)

### COV-101: Setup API service skeleton
- **Type**: Story
- **Acceptance Criteria**:
  - Node + TypeScript project boots with `npm run dev`.
  - Health endpoint returns 200.

### COV-102: Auth domain model
- **Type**: Story
- **Acceptance Criteria**:
  - `User` entity has email, password hash, verification status.
  - Validation rejects invalid email/password policy violations.

### COV-103: OTP service interface
- **Type**: Story
- **Acceptance Criteria**:
  - Create OTP challenge.
  - Verify OTP with expiry and attempt cap.

### COV-104: Security baseline
- **Type**: Task
- **Acceptance Criteria**:
  - Environment-based secrets config.
  - Centralized error model without leaking sensitive internals.

## Sprint 2 (P0)

### COV-201: Signup + login endpoints
- **Type**: Story
- **Acceptance Criteria**:
  - Signup returns user id + pending verification state.
  - Login returns signed access token.

### COV-202: Anonymous profile CRUD
- **Type**: Story
- **Acceptance Criteria**:
  - Nickname required.
  - Visibility settings stored and retrievable.

### COV-203: Verification request endpoint
- **Type**: Story
- **Acceptance Criteria**:
  - User can submit verification request.
  - Request enters `pending_review` queue.

### COV-204: Review moderation endpoint
- **Type**: Story
- **Acceptance Criteria**:
  - Reviewer can approve/reject with reason.
  - User verification status updates atomically.
