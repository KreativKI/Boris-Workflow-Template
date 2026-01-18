# GSD + Boris Example: Building an E-Commerce Platform

**Scenario:** You need to build a complete e-commerce platform with user authentication, product catalog, shopping cart, and checkout. This will take 2-3 weeks of development time.

**Decision:** Use GSD orchestration + Boris quality gates

**Estimated Timeline:** 11 days across 5 phases

---

## Project Overview

**What we're building:**
- User authentication (register, login, logout, password reset)
- Product catalog (browse, search, filter, details)
- Shopping cart (add/remove items, update quantities)
- Checkout flow (shipping info, payment, order confirmation)
- Order history (view past orders)

**Why GSD + Boris:**
- **GSD:** Breaks this into manageable phases, prevents context rot
- **Boris:** Ensures code quality at every phase boundary

---

## Phase 0: Initialize Project

### Commands

```
/gsd:new-project
```

### GSD prompts for:

**Project Name:** E-Commerce Platform

**Project Description:**
```
A full-featured e-commerce web application with:
- User authentication and account management
- Product catalog with search and filtering
- Shopping cart with persistent storage
- Secure checkout with payment processing
- Order history and tracking
- Admin panel for product management
```

**Target Users:** Online shoppers, merchants

**Success Criteria:**
```
- Users can create accounts and login securely
- Users can browse 100+ products with search/filter
- Users can add items to cart and checkout
- Payment processing integration works end-to-end
- Admin can manage products via admin panel
- All features have 90%+ test coverage
- App passes security audit
```

### GSD creates:

- `PROJECT.md` — Project overview and success criteria
- `REQUIREMENTS.md` — Detailed feature requirements
- `ROADMAP.md` — Milestone breakdown (5 phases)

### Output:

```
✅ Project initialized: E-Commerce Platform

Phases identified:
1. User Authentication (2 days)
2. Product Catalog (3 days)
3. Shopping Cart (2 days)
4. Checkout Flow (3 days)
5. Order History & Admin Panel (1 day)

Total estimated: 11 days

Ready to discuss Phase 1?
```

**No Boris integration** — pure project setup.

---

## Phase 1: User Authentication (2 days)

### Step 1: Discuss Architecture

```
/gsd:discuss-phase 1
```

### GSD captures decisions:

**Architecture:**
- Backend: Node.js + Express
- Database: PostgreSQL with Sequelize ORM
- Auth: JWT tokens (httpOnly cookies)
- Password hashing: bcrypt (cost factor 12)
- Session management: Redis for refresh tokens

**API Endpoints:**
- `POST /api/auth/register` — Create new account
- `POST /api/auth/login` — Login and get JWT
- `POST /api/auth/logout` — Invalidate tokens
- `POST /api/auth/reset-password` — Request reset email
- `POST /api/auth/confirm-reset` — Complete password reset
- `GET /api/auth/me` — Get current user

**Data Models:**
```typescript
User {
  id: UUID
  email: string (unique, indexed)
  passwordHash: string
  firstName: string
  lastName: string
  createdAt: Date
  updatedAt: Date
}

RefreshToken {
  id: UUID
  userId: UUID (FK)
  token: string
  expiresAt: Date
}
```

**Security:**
- Input validation with Joi
- Rate limiting (5 attempts per 15 min for login)
- Email verification required for registration
- Password requirements: 8+ chars, uppercase, lowercase, number

### Boris Quality Gate: Validate Architecture

```
User: "Use code-architect to validate the authentication architecture for phase 1"

Claude: [Runs Task(subagent_type="code-architect")]
```

### code-architect findings:

```
✅ Architecture review for Phase 1: User Authentication

Strengths:
• JWT with httpOnly cookies prevents XSS attacks
• bcrypt with cost 12 is appropriate for 2026
• Redis for refresh tokens enables token revocation
• Rate limiting prevents brute force attacks
• Email verification adds security layer

Recommendations:
1. Add CSRF protection (use csurf middleware)
2. Consider adding 2FA support in roadmap
3. Use helmet.js for security headers
4. Add account lockout after failed attempts
5. Log authentication events for audit trail

Concerns:
None critical. Architecture is solid for MVP.

Suggested improvements:
• Add "remember me" functionality
• Support OAuth (Google, GitHub) in Phase 1.5
• Add device fingerprinting for security

Overall: ✅ APPROVED - Proceed to planning
```

### Checkpoint: Architecture Approved ✓

User confirms architecture is good, proceed to planning.

---

### Step 2: Plan Tasks

```
/gsd:plan-phase 1
```

### GSD creates atomic tasks:

**File:** `phase-1-PLAN.md`

```markdown
# Phase 1: User Authentication - Task Breakdown

## Tasks (9 total)

### T1.1: Database Schema Setup
- Create User and RefreshToken models with Sequelize
- Add migrations for tables
- Set up indexes (email unique, userId FK)
**Estimate:** 30 min

### T1.2: Password Hashing Utility
- Implement bcrypt wrapper functions
- Add password validation rules
- Write unit tests
**Estimate:** 30 min

### T1.3: JWT Token Service
- Implement JWT generation and verification
- Handle access and refresh tokens
- Add expiration logic
**Estimate:** 1 hour

### T1.4: User Registration API
- POST /api/auth/register endpoint
- Input validation with Joi
- Send verification email
- Return JWT on success
**Estimate:** 1 hour

### T1.5: User Login API
- POST /api/auth/login endpoint
- Password verification
- Generate JWT tokens
- Set httpOnly cookies
**Estimate:** 1 hour

### T1.6: Logout API
- POST /api/auth/logout endpoint
- Invalidate refresh tokens
- Clear cookies
**Estimate:** 30 min

### T1.7: Password Reset Flow
- POST /api/auth/reset-password (send email)
- POST /api/auth/confirm-reset (verify token, update password)
- Generate secure reset tokens
**Estimate:** 1.5 hours

### T1.8: Get Current User API
- GET /api/auth/me endpoint
- JWT middleware for authentication
- Return user data
**Estimate:** 30 min

### T1.9: Integration Tests
- Test registration → login → logout flow
- Test password reset flow
- Test invalid credentials
- Test rate limiting
**Estimate:** 2 hours

## Dependencies
- T1.1 → T1.4, T1.5 (database must exist first)
- T1.2 → T1.4, T1.7 (password hashing needed)
- T1.3 → T1.4, T1.5, T1.8 (JWT service needed)
- T1.9 depends on all other tasks

## Total: ~9 hours (2 days with testing)
```

**No Boris integration** — planning is task breakdown, not code validation.

---

### Step 3: Execute Tasks

```
/gsd:execute-phase 1
```

### GSD executes:

```
🔄 Spawning parallel executors for Phase 1...

✓ [T1.1] Database Schema Setup (gsd-executor-1)
✓ [T1.2] Password Hashing Utility (gsd-executor-2)
✓ [T1.3] JWT Token Service (gsd-executor-3)

... (executors work in parallel with fresh contexts)

✓ [T1.4] User Registration API (gsd-executor-4)
✓ [T1.5] User Login API (gsd-executor-5)
✓ [T1.6] Logout API (gsd-executor-6)
✓ [T1.7] Password Reset Flow (gsd-executor-7)
✓ [T1.8] Get Current User API (gsd-executor-8)
✓ [T1.9] Integration Tests (gsd-executor-9)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase 1 Execution Summary:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Tasks completed: 9/9
Commits created: 9 (one per task)
Files changed: 23 files
Lines added: 1,847 lines
Lines removed: 0 lines

Commits:
• a1b2c3d [T1.1] Database Schema Setup
• d4e5f6g [T1.2] Password Hashing Utility
• h7i8j9k [T1.3] JWT Token Service
• l0m1n2o [T1.4] User Registration API
• p3q4r5s [T1.5] User Login API
• t6u7v8w [T1.6] Logout API
• x9y0z1a [T1.7] Password Reset Flow
• b2c3d4e [T1.8] Get Current User API
• f5g6h7i [T1.9] Integration Tests

✅ Phase 1 execution complete
```

### Boris Quality Gates: Review + Simplify + Validate

```
User: "Run code-reviewer on all phase 1 changes"

Claude: [Runs Task(subagent_type="code-reviewer")]
```

### code-reviewer findings:

```
🔍 Code Review: Phase 1 (9 tasks, 23 files, 1,847 lines)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Issues Found (confidence ≥80%):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

HIGH (3 issues):

1. [SECURITY] SQL Injection Risk (T1.4)
   File: src/api/auth/register.ts:42
   Issue: Raw SQL in password reset token lookup
   Fix: Use Sequelize parameterized queries

2. [BUG] Race Condition (T1.3)
   File: src/services/jwt.ts:67
   Issue: Token refresh can create duplicate tokens
   Fix: Add database transaction with row lock

3. [SECURITY] Missing Input Sanitization (T1.7)
   File: src/api/auth/reset-password.ts:28
   Issue: Email not sanitized before querying
   Fix: Use validator.normalizeEmail()

MEDIUM (5 issues):

4. [QUALITY] Missing Error Handling (T1.5)
   File: src/api/auth/login.ts:54
   Issue: Redis connection failure not handled
   Fix: Add try-catch with fallback behavior

5. [PERFORMANCE] N+1 Query (T1.8)
   File: src/api/auth/me.ts:18
   Issue: User + Profile loaded separately
   Fix: Use .include() in Sequelize query

... (3 more medium issues)

LOW (2 issues - not shown)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Summary: 8 issues (3 high, 5 medium, 2 low)
Action Required: Fix 8 issues before proceeding
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Fix issues:

```
User: "Fix all 8 issues found by code-reviewer"

Claude: [Fixes issues, creates new commits]

✓ Fixed SQL injection in register.ts
✓ Fixed race condition in jwt.ts
✓ Added input sanitization in reset-password.ts
✓ Added error handling in login.ts
✓ Optimized N+1 query in me.ts
... (fixes 3 more)

8 commits created (one per fix)
```

### Run code-simplifier:

```
User: "Now run code-simplifier on phase 1"

Claude: [Runs Task(subagent_type="code-simplifier")]
```

### code-simplifier improvements:

```
✨ Code Simplification: Phase 1

Changes Applied:
• Extracted repeated validation logic → authValidation.ts
• Simplified password hashing with async/await
• Reduced JWT service from 150 lines → 98 lines
• Unified error response format across all endpoints
• Removed duplicate type definitions

Metrics:
• Cyclomatic complexity: 12 → 8 (33% improvement)
• Code duplication: 18% → 4% (78% reduction)
• Average function length: 42 lines → 28 lines (33% shorter)
• Readability score: 72 → 89 (+17 points)

Files modified: 12
Commits created: 1 (grouped simplifications)

✅ Code simplified successfully
```

### Run build-validator:

```
User: "Run build-validator before moving to verify"

Claude: [Runs Task(subagent_type="build-validator")]
```

### build-validator results:

```
🔨 Build Validation: Phase 1

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Clean Build
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$ npm run build
✓ TypeScript compilation: SUCCESS (0 errors)
✓ Build output: dist/ (2.4 MB)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Type Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$ npm run typecheck
✓ No type errors found

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Lint
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$ npm run lint
✓ No linting errors
⚠ 2 warnings (unused imports - auto-fixed)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Tests
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$ npm run test
✓ 47 tests passing (T1.1-T1.9)
✓ Coverage: 94% (target: 90%)

Test Suites: 9 passed, 9 total
Tests:       47 passed, 47 total
Time:        8.234s

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Overall Status: ✅ PASS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Recommendations:
• Build is ready for deployment
• All quality gates passed
• Safe to proceed to VERIFY phase

✅ Build validation complete
```

### Checkpoint: Quality Gates Passed ✓

User confirms all quality gates passed, proceed to verification.

---

### Step 4: Verify Phase

```
/gsd:verify-work 1
```

### GSD creates UAT checklist:

```
📋 User Acceptance Testing: Phase 1

Please manually test the following scenarios:

Authentication Flow:
- [ ] User can register with valid email/password
- [ ] Registration fails with weak password
- [ ] Registration fails with duplicate email
- [ ] User receives verification email
- [ ] User can login with correct credentials
- [ ] Login fails with incorrect password
- [ ] Login fails with unverified email
- [ ] JWT token is set in httpOnly cookie
- [ ] User can access /api/auth/me with valid token
- [ ] User can logout successfully
- [ ] Token is invalidated after logout

Password Reset Flow:
- [ ] User can request password reset email
- [ ] Reset link is valid for 1 hour
- [ ] User can reset password with valid token
- [ ] Old password no longer works
- [ ] New password works for login
- [ ] Reset token expires after use

Security:
- [ ] Rate limiting blocks brute force (6th attempt fails)
- [ ] XSS protection (try <script> in inputs)
- [ ] SQL injection blocked (try ' OR '1'='1)

Edge Cases:
- [ ] Concurrent login requests handled correctly
- [ ] Token refresh works near expiration
- [ ] Database connection loss handled gracefully
```

### User performs manual testing:

```
[User tests all scenarios]

Results:
✅ All authentication flows work
✅ All security checks pass
✅ All edge cases handled
❌ Found 1 minor UI issue: Error message too technical

User: "Fix the error message in login to be user-friendly"
Claude: [Fixes error message]
✅ Fixed
```

### Boris Quality Gates: Automated Testing

```
User: "Use verify-app to run automated tests for phase 1"

Claude: [Runs Task(subagent_type="verify-app")]
```

### verify-app results:

```
🔍 Application Verification: Phase 1

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Static Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Security audit: 0 vulnerabilities
✓ Dependency audit: All packages up to date
✓ Code quality: A grade (SonarQube)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Automated Tests
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Unit Tests: 39/39 passing
Integration Tests: 8/8 passing
E2E Tests: 5/5 passing (Playwright)

Total: 52/52 tests passing ✓
Coverage: 96% (exceeds 90% target)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Manual Verification Checks
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ All API endpoints return 200 for valid input
✓ All API endpoints return 400/401 for invalid input
✓ Rate limiting triggers after 5 failed logins
✓ JWT tokens expire after 15 minutes
✓ Refresh tokens expire after 30 days

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Edge Case Testing
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Concurrent login requests → No duplicates
✓ Database disconnect → Graceful error
✓ Redis disconnect → Fallback to memory
✓ Invalid JWT → 401 Unauthorized
✓ Expired JWT → Refresh flow works

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Overall Status: ✅ PASS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Phase 1 functionality verified and ready for production.
```

### Final code review:

```
User: "Run code-reviewer one final time on phase 1"

Claude: [Runs Task(subagent_type="code-reviewer")]

Result: ✅ No issues found (all previous issues fixed)
```

### Checkpoint: Verification Complete ✓

User confirms UAT + automated tests + final review all passed.

---

## Phase 1 Complete! 🎉

**Summary:**
- **Time:** 2 days (as estimated)
- **Tasks:** 9 executed + 8 fixes + 1 simplification = 18 commits
- **Quality:**
  - Code review: 0 issues remaining
  - Tests: 52/52 passing (96% coverage)
  - Build: Clean (0 errors, 0 warnings)
  - Security: 0 vulnerabilities
- **Boris value:** Caught 8 issues (3 critical security bugs)

---

## Phases 2-5: Repeat Pattern

The remaining phases follow the same pattern:

### Phase 2: Product Catalog (3 days)
- **DISCUSS:** Design product schema, search/filter architecture
- **Boris:** code-architect validates
- **PLAN:** 12 tasks (models, API, UI components, search)
- **EXECUTE:** GSD runs tasks in parallel
- **Boris:** code-reviewer (found 5 issues) → code-simplifier → build-validator
- **VERIFY:** UAT + verify-app
- **Boris:** Final code-reviewer
- **Result:** ✅ Complete

### Phase 3: Shopping Cart (2 days)
- Similar pattern, 8 tasks
- **Boris caught:** 3 issues (race condition, state management bug)
- **Result:** ✅ Complete

### Phase 4: Checkout Flow (3 days)
- Similar pattern, 10 tasks
- **Boris caught:** 6 issues (payment security, validation bugs)
- **Result:** ✅ Complete

### Phase 5: Order History & Admin (1 day)
- Similar pattern, 6 tasks
- **Boris caught:** 2 issues (permission bugs)
- **Result:** ✅ Complete

---

## Final Milestone

```
/gsd:complete-milestone
```

### GSD archives:

```
✅ Milestone Complete: E-Commerce Platform v1.0

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Duration: 11 days (as estimated)
Phases: 5/5 completed
Tasks: 45 total (all completed)
Commits: 94 (atomic task commits + fixes)

Quality Metrics:
• Tests: 287/287 passing
• Coverage: 94% overall
• Security vulnerabilities: 0
• Code quality: A grade
• Issues caught by Boris: 24 (19 critical)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Git Tag Created
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Tag: v1.0.0-ecommerce-platform
Message: "Complete e-commerce platform with auth, catalog, cart, checkout"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Documentation Archived
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Files archived to .gsd/milestones/2026-01-28/:
• PROJECT.md
• REQUIREMENTS.md
• ROADMAP.md
• All phase plans (phase-1-PLAN.md through phase-5-PLAN.md)
• CONTEXT.md (all architectural decisions)

✅ Milestone archived successfully
```

---

## Key Takeaways

### What GSD Provided:
✅ **Atomic tasks:** 45 tasks, each with fresh 200k context
✅ **Parallel execution:** Tasks ran concurrently, faster completion
✅ **No context rot:** Each task started with full project context
✅ **Systematic phases:** Clear boundaries, easy to track progress
✅ **Atomic commits:** 94 commits, full traceability

### What Boris Provided:
✅ **Architecture validation:** code-architect caught design flaws early
✅ **Bug detection:** code-reviewer found 24 issues (19 critical)
✅ **Code quality:** code-simplifier improved readability 33%
✅ **Build verification:** build-validator ensured clean builds
✅ **Functionality testing:** verify-app caught edge cases

### The Result:
🚀 **Production-ready e-commerce platform in 11 days**
- 0 security vulnerabilities
- 94% test coverage
- 287 passing tests
- Clean codebase (A grade)
- No technical debt
- Full documentation

**Without GSD:** Would have taken 15-20 days with context switching overhead
**Without Boris:** Would have shipped with 24 bugs (19 critical)

**Together:** Fast delivery + High quality = Success ✨

---

## Try It Yourself

```bash
# 1. Install GSD
./claude/setup-gsd.sh

# 2. Start your project
/gsd:new-project

# 3. Follow this pattern for each phase:
/gsd:discuss-phase N
→ "Use code-architect to validate"
/gsd:plan-phase N
/gsd:execute-phase N
→ "Run code-reviewer and code-simplifier"
/gsd:verify-work N
→ "Use verify-app to run tests"

# 4. Complete milestone
/gsd:complete-milestone
```

Happy building! 🎉
