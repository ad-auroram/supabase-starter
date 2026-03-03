# Supabase Starter - Project Specifications

## Project Overview
A full-stack Next.js application with complete authentication, database management, and automatic profile creation using Supabase. This starter includes all necessary features for building secure, production-ready applications.

## Overview of Implementation Status

| Area | Status | Notes |
|------|--------|-------|
| Next.js Setup | ✅ Complete | Latest version with TypeScript |
| Supabase Integration | ✅ Complete | CLI, client libs, middleware configured |
| Authentication | ✅ Complete | Sign up, sign in, sign out all working |
| Profile Model & Schema | ✅ Complete | Table created with all required fields |
| Auto Profile Creation | ✅ Complete | Trigger function working |
| Row Level Security | ✅ Complete | All policies configured |
| Setup Script | ✅ Complete | Automated setup working |
| **Home Page** | ⚠️ Partial | Needs auth status & conditional dashboard link |
| **Login Page** | ✅ Complete | Form, validation, redirect all working |
| **Signup Page** | ✅ Complete | Form, validation, redirect all working |
| **Dashboard** | ⚠️ Partial | Needs profile table integration |
| **Profile Page** | ⚠️ Partial | Needs form, avatar upload, Supabase Storage |
| **Components** | ✅ Complete | Button, Input, SignOutButton all ready |
| **Hooks** | ✅ Complete | useAuth, useRequireAuth fully implemented |

## Completed Requirements ✅

### 1. Next.js Application Setup ✅

- [x] Create a new Next.js application (using the latest version - 16.1.6)
- [x] Configure TypeScript for type safety
- [x] Set up proper project structure with organized folders:
  - [x] `app/` - Next.js App Router with (auth) and (protected) route groups
  - [x] `components/` - Organized into `auth/` and `ui/` subdirectories
  - [x] `lib/` - Library utilities with `supabase/` subdirectory
  - [x] `hooks/` - Custom React hooks
  - [x] `types/` - TypeScript type definitions and interfaces
  - [x] `utils/` - Utility functions for formatting and validation
  - [x] `__tests__/` - Unit and integration tests
- [x] Include basic styling with TailwindCSS

### 2. Supabase Integration ✅

- [x] Install and configure Supabase CLI (`supabase` v2.76.12)
- [x] Install client libraries:
  - [x] `@supabase/supabase-js` (v2.97.0)
  - [x] `@supabase/ssr` (v0.8.0) - For proper server/client component support
- [x] Configure Supabase for local development with Docker
- [x] Create Supabase client utilities:
  - [x] `lib/supabase/client.ts` - Client-side operations
  - [x] `lib/supabase/server.ts` - Server-side operations
- [x] Configure Next.js middleware for token refresh (`proxy.ts`)
- [x] Set up environment variables for Supabase credentials:
  - [x] `NEXT_PUBLIC_SUPABASE_URL`
  - [x] `NEXT_PUBLIC_SUPABASE_ANON_KEY`

### 3. User Authentication ✅

- [x] Implement user sign up functionality (`app/(auth)/signup/page.tsx`)
- [x] Implement user sign in functionality (`app/(auth)/signin/page.tsx`)
- [x] Implement user sign out functionality (`components/auth/SignOutButton.tsx`)
- [x] Create protected routes that require authentication:
  - [x] Dashboard page (`app/(protected)/dashboard/page.tsx`)
  - [x] Profile page (`app/(protected)/profile/page.tsx`)
  - [x] Route protection via middleware and custom hooks
- [x] Display user information when logged in
- [x] Handle authentication state properly in both server and client components
- [x] Custom hook for auth state: `hooks/useAuth.ts`
- [x] Custom hook for route protection: `hooks/useRequireAuth.ts`

### 4. Profile Model with Declarative Schema ✅

- [x] Design and create a profiles table (`supabase/schemas/profiles.sql`)
- [x] Table structure:
  - [x] Primary key (`id` UUID) that references `auth.users(id)`
  - [x] `email` field (TEXT NOT NULL)
  - [x] `full_name` field (TEXT)
  - [x] `avatar_url` field (TEXT)
  - [x] `created_at` field (TIMESTAMPTZ with DEFAULT NOW())
  - [x] `updated_at` field (TIMESTAMPTZ with DEFAULT NOW())
  - [x] Automatic update of `updated_at` using trigger
- [x] Define the profile table using declarative schema
- [x] Generate migration from declarative schema:
  - Migration file: `supabase/migrations/20260224000000_create_profiles.sql`

### 5. Automatic Profile Creation ✅

- [x] Create PostgreSQL trigger function `handle_new_user()`
- [x] Trigger requirements:
  - [x] Fires AFTER a new user is inserted into `auth.users`
  - [x] Extracts the user's email from the `auth.users` record
  - [x] Automatically inserts a new row into the `profiles` table with:
    - [x] User's ID (from `new.id`)
    - [x] User's email (from `new.email`)
- [x] Included in migration file: `supabase/migrations/20260224000000_create_profiles.sql`

### 6. Row Level Security (RLS) Policies ✅

- [x] Enable RLS on the profiles table
- [x] Create RLS policies that allow:
  - [x] Users to SELECT their own profile (using `auth.uid()`)
    - Policy: "Users can view own profile"
  - [x] Users to UPDATE their own profile
    - Policy: "Users can update own profile"
  - [x] Users to INSERT their own profile (safety measure)
    - Policy: "Users can insert own profile"
- [x] Policies ensure users cannot access or modify other users' profiles

### 7. Setup Script ✅

- [x] Create setup script: `scripts/setup.sh`
- [x] Script functionality:
  - [x] Checks for Node.js and npm installation
  - [x] Installs all npm dependencies (`npm install`)
  - [x] Starts the local Supabase instance (`npx supabase start`)
  - [x] Extracts Supabase credentials (URL and anon key)
  - [x] Creates or updates `.env.local` file with:
    - [x] `NEXT_PUBLIC_SUPABASE_URL`
    - [x] `NEXT_PUBLIC_SUPABASE_ANON_KEY`
  - [x] Provides clear output showing what was done and next steps
- [x] Script properties:
  - [x] Assumes Supabase is already initialized
  - [x] Idempotent (safe to run multiple times)
  - [x] Handles cases where Supabase is already running
  - [x] Checks if `.env.local` already exists and updates if needed
  - [x] Provides helpful error messages for failures
  - [x] Includes usage instructions in README

## Project Structure

```
├── app/
│   ├── (auth)/
│   │   ├── layout.tsx
│   │   ├── signin/
│   │   │   └── page.tsx
│   │   └── signup/
│   │       └── page.tsx
│   ├── (protected)/
│   │   ├── layout.tsx
│   │   ├── dashboard/
│   │   │   └── page.tsx
│   │   └── profile/
│   │       └── page.tsx
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
├── components/
│   ├── auth/
│   │   ├── index.ts
│   │   └── SignOutButton.tsx
│   └── ui/
│       ├── index.ts
│       ├── Button.tsx
│       └── Input.tsx
├── hooks/
│   ├── index.ts
│   ├── useAuth.ts
│   └── useRequireAuth.ts
├── lib/
│   └── supabase/
│       ├── client.ts
│       └── server.ts
├── types/
│   ├── auth.ts
│   ├── database.ts
│   └── index.ts
├── utils/
│   ├── format.ts
│   ├── validation.ts
│   └── index.ts
├── __tests__/
│   ├── utils/
│   │   ├── format.test.ts
│   │   └── validation.test.ts
│   └── README.md
├── supabase/
│   ├── config.toml
│   ├── migrations/
│   │   ├── 20260224000000_create_profiles.sql
│   │   └── README.md
│   └── schemas/
│       └── profiles.sql
├── scripts/
│   └── setup.sh
├── proxy.ts                 # Next.js middleware for Supabase token refresh
├── next.config.ts
├── tsconfig.json
├── tailwind.config.ts
├── postcss.config.mjs
├── vitest.config.ts
├── vitest.setup.ts
├── eslint.config.mjs
├── package.json
└── README.md
```

## Technology Stack

- **Framework**: Next.js 16.1.6 (Latest with App Router)
- **Language**: TypeScript 5
- **Database**: PostgreSQL (via Supabase)
- **Authentication**: Supabase Auth with @supabase/ssr
- **Styling**: TailwindCSS 4
- **Testing**: Vitest 4 with React Testing Library
- **Code Quality**: ESLint 9
- **Package Manager**: npm

## Key Implementation Details

### Authentication Flow
- Uses `@supabase/ssr` for proper server/client component support
- Token refresh handled via `proxy.ts` middleware
- Custom hooks (`useAuth`, `useRequireAuth`) for state management
- Protected routes using layout guards and middleware
- Session persistence across page reloads

### Database
- PostgreSQL via Supabase
- Declarative schema definitions in `supabase/schemas/`
- Version-controlled migrations in `supabase/migrations/`
- Row Level Security enabled on all user-specific tables
- Automatic profile creation via database triggers

### Development Workflow
- Local Supabase instance with Docker
- Database migrations managed via Supabase CLI
- Type-safe Supabase client configuration
- Automated setup script for quick onboarding

## Route & Page Specifications

### Home Page - `/` (Public Route)

**Purpose**: Landing page for unauthenticated and authenticated users

**Features**:
- [x] Display a welcome message
- [ ] Show current authentication status
- [x] Conditional links based on auth status:
  - [ ] If authenticated: Link to dashboard
  - [x] If not authenticated: Link to login/signup pages
- [x] Clean, inviting design with call-to-action
- [x] Optional: Feature highlights or information about the application

**File**: `app/page.tsx`

**Status**: Partially Implemented
- Welcome message and feature highlights are displayed
- Links to signup/signin are present
- **TODO**: Add authentication status display and conditional "Go to Dashboard" link for authenticated users
- **TODO**: Use server component to fetch session and show different content based on auth state

**Implementation Notes**:
- Currently uses static content
- Needs to fetch auth session on server-side
- Use conditional rendering based on session data
- Link to `/login` and `/signup` for unauthenticated users
- Link to `/dashboard` for authenticated users

---

### Login Page - `/login` (Public Route)

**Purpose**: User authentication via email and password

**Features**:
- [x] Email input field with validation
- [x] Password input field
- [x] Login form submission
- [x] Error handling for failed login attempts:
  - [x] Invalid credentials error message
  - [x] Network/server error messages
  - [x] User-friendly error display
- [x] Loading state during login attempt
- [x] Link to signup page for new users
- [x] Redirect to dashboard on successful login
- [x] Prevent access if already authenticated

**File**: `app/(auth)/signin/page.tsx`

**Status**: ✅ FULLY IMPLEMENTED
- Email/password form with validation
- Error handling with user-friendly messages
- Loading state with disabled button
- Link to signup page
- Redirects to dashboard on success
- Middleware prevents authenticated users from accessing

**Implementation Details**:
- Uses Supabase `signInWithPassword()` method
- Email and password validation
- Clear error messages displayed
- Session stored in Supabase session storage
- Uses Next.js `useRouter` for redirect

---

### Signup Page - `/signup` (Public Route)

**Purpose**: New user registration with email and password

**Features**:
- [x] Email input field with validation
- [ ] Password input field with strength indicator (optional)
- [ ] Confirm password field
- [x] Signup form submission
- [x] Error handling for failed signup attempts:
  - [x] Email already exists error
  - [x] Password validation errors
  - [x] Network/server error messages
  - [x] User-friendly error display
- [x] Loading state during signup attempt
- [x] Link to login page for existing users
- [ ] Terms of service/privacy policy acknowledgment (optional)
- [x] Redirect to dashboard on successful signup
- [x] Prevent access if already authenticated

**File**: `app/(auth)/signup/page.tsx`

**Status**: ✅ MOSTLY IMPLEMENTED (Optional Features Remaining)
- Email/password form with validation
- Error handling with user-friendly messages
- Loading state with disabled button
- Link to login page
- Redirects to dashboard on success
- Password minimum length validation (6 characters)
- Automatic profile creation handled by database trigger
- Middleware prevents authenticated users from accessing

**TODO** (Optional Enhancements):
- [ ] Add password strength indicator
- [ ] Add confirm password field for verification
- [ ] Add terms of service checkbox

**Implementation Details**:
- Uses Supabase `signUp()` method from `@supabase/supabase-js`
- Validates email format
- Checks password minimum length
- Automatic profile creation via database trigger
- Session stored immediately after signup

---

### Dashboard Page - `/dashboard` (Protected Route)

**Purpose**: Main authenticated user workspace

**Features**:
- [x] Require authentication (redirect to login if not authenticated)
- [x] Display user profile information:
  - [x] User email
  - [ ] Full name (from profiles table)
  - [ ] Avatar (if available)
- [x] Navigation links:
  - [x] Link to profile edit page
  - [x] Sign out button
- [ ] Welcome message with user's name (if available)
- [x] Optional: Quick stats or useful information
- [ ] Loading state while fetching user data
- [ ] Error handling for failed data fetching

**File**: `app/(protected)/dashboard/page.tsx`

**Status**: ✅ MOSTLY IMPLEMENTED (Enhanced User Info Needed)
- Authentication check via server-side rendering
- Displays user email
- Navigation to dashboard and profile pages
- Sign out button in layout
- Quick stats cards with account status info
- Proper route protection via middleware

**TODO**:
- [ ] Fetch and display full_name from profiles table
- [ ] Display avatar if available
- [ ] Add welcome message with user's name
- [ ] Add loading/error states for profile data

**Implementation Details**:
- Fetches user session on server-side with `createClient()`
- Middleware (`proxy.ts`) checks authentication
- Protected layout in `app/(protected)/layout.tsx` handles auth redirect
- Currently displays email from auth.users
- Needs to fetch profile data from profiles table

---

### Profile Page - `/profile` (Protected Route)

**Purpose**: User profile management and avatar upload

**Features**:
- [x] Require authentication (redirect to login if not authenticated)
- [x] Display current profile information:
  - [x] Email (from auth.users)
  - [ ] Full name (from profiles table)
  - [ ] Avatar image (from profiles table)
  - [x] Other profile fields (ID, email_confirmed_at, created_at, last_sign_in_at)
- [ ] Profile update form:
  - [ ] Full name input field with validation
  - [ ] Any other editable profile fields
  - [ ] Save/Update button
  - [ ] Cancel button (optional)
  - [ ] Success message on save
  - [ ] Error handling for update failures

**Avatar Upload Functionality**:
- [ ] File input for image selection
  - [ ] Accept image file types only (jpg, png, gif, webp, etc.)
  - [ ] Display file size limits
- [ ] Image preview before upload:
  - [ ] Show selected image preview
  - [ ] Allow user to confirm or select different image
- [ ] Upload implementation:
  - [ ] Upload to Supabase Storage
  - [ ] Store file in a dedicated bucket (e.g., `avatars`)
  - [ ] Use user ID in file path for organization
  - [ ] Update `avatar_url` in `profiles` table with public URL
  - [ ] Handle upload progress/loading state
- [ ] Display current avatar:
  - [ ] Show uploaded avatar image
  - [ ] Fallback to default avatar if not set
- [ ] Error handling:
  - [ ] File size validation errors
  - [ ] File type validation errors
  - [ ] Upload failure messages
  - [ ] Display user-friendly error messages
- [ ] Security considerations:
  - [ ] Validate file types on client and server
  - [ ] Set appropriate file size limits
  - [ ] Use Supabase Storage RLS policies

**File**: `app/(protected)/profile/page.tsx`

**Status**: ⚠️ PARTIALLY IMPLEMENTED (Form & Avatar Upload Needed)
- Authentication check via `useAuth()` hook
- Displays user auth information (ID, email, confirmed status, dates)
- Loading and error states implemented
- Placeholder for profile settings section

**TODO** (Critical):
- [ ] Fetch profile data from `profiles` table (full_name, avatar_url)
- [ ] Create profile update form with email, full_name fields
- [ ] Implement Save/Update button with database update
- [ ] Add success/error messages for updates
- [ ] Create avatar upload functionality
- [ ] Implement Supabase Storage bucket for avatars
- [ ] Display current avatar with fallback
- [ ] Add file type and size validation

**Supabase Storage Setup** (Not Yet Done):
- [ ] Create `avatars` bucket in Supabase Storage
- [ ] Set bucket to private by default
- [ ] Implement RLS policies for authenticated user uploads
- [ ] Allow users to access only their own avatars
- [ ] File naming convention: `{user_id}/{filename}`

**Implementation Notes**:
- Currently using `useAuth()` hook (client-side)
- Needs to fetch profile data from `profiles` table
- Form state management required for profile updates
- Implement file upload handler for avatar
- Call Supabase Storage API for file uploads
- Update `profiles` table with new `avatar_url` after upload
- Show loading/error states during upload
- Validate all form fields

---

## Component & Hook Requirements

### Existing Components to Enhance

#### `components/auth/SignOutButton.tsx`
**Status**: ✅ FULLY IMPLEMENTED

Features:
- [x] Render sign out button
- [x] Handle logout on click
- [x] Clear session and redirect to home
- [x] Customizable button variant (primary, secondary, danger)

Implementation:
- Uses Supabase `auth.signOut()` method
- Redirects to `/signin` after logout
- Integrates with Button component for styling
- Accepts variant prop (defaults to 'danger')

---

#### `components/ui/Button.tsx`
**Status**: ✅ FULLY IMPLEMENTED

Features:
- [x] Support for different button variants (primary, secondary, danger)
- [x] Loading state support
- [x] Disabled state support
- [x] Icon support (via className extension)

Implementation:
- Extends standard HTML button element
- Three variants: primary (blue), secondary (gray), danger (red)
- Three sizes: sm, md, lg
- Loading state shows "Loading..." text
- Proper accessibility with disabled state

---

#### `components/ui/Input.tsx`
**Status**: ✅ FULLY IMPLEMENTED

Features:
- [x] Text input with label
- [x] Error message display
- [x] Help text support (via className)
- [x] Type variations (text, email, password)
- [x] Validation state styling

Implementation:
- Extends standard HTML input element
- Optional label with auto-generated ID
- Error message display with red styling
- Error state changes border and ring color
- Dark mode support via Tailwind classes

---

### Required Custom Hooks

#### `hooks/useAuth.ts`
**Status**: ✅ FULLY IMPLEMENTED

Features:
- [x] Return current user session
- [x] Return loading state
- [x] Return user profile data (via user object)
- [x] Handle session changes with real-time listener

Implementation:
- Initializes session on component mount
- Listens to auth state changes via `onAuthStateChange()`
- Returns user, session, loading state, and isAuthenticated flag
- Properly unsubscribes from listener on unmount
- All values properly typed with Supabase types

---

#### `hooks/useRequireAuth.ts`
**Status**: ✅ FULLY IMPLEMENTED

Features:
- [x] Redirect to login if not authenticated
- [x] Return auth status
- [x] Return current user

Implementation:
- Uses `useAuth()` hook internally
- Automatically redirects to `/signin` if user is not authenticated
- Only redirects after loading completes to avoid flashing
- Returns user and loading state for component use
- Proper cleanup on unmount

---

## How to Run the Setup

```bash
# Make the setup script executable
chmod +x scripts/setup.sh

# Run the setup script
./scripts/setup.sh

# The script will:
# 1. Check for Node.js and npm
# 2. Install dependencies
# 3. Start Supabase (if selected)
# 4. Display credentials to add to .env.local
# 5. Provide next steps
```

## Manual Setup (If Preferred)

```bash
# Install dependencies
npm install

# Start local Supabase
npx supabase start

# Extract and save credentials
# Copy to .env.local:
# NEXT_PUBLIC_SUPABASE_URL=<your-url>
# NEXT_PUBLIC_SUPABASE_ANON_KEY=<your-key>

# Reset database with migrations
npx supabase db reset

# Start development server
npm run dev
```

## Deployment Considerations

- Environment variables must be set in production platform (Vercel, Netlify, etc.)
- Link production Supabase project via CLI
- Run migrations before deployment
- Configure custom domain if needed
- Enable additional security policies for production

## Testing

```bash
# Run tests
npm test

# Run tests in watch mode
npm run test:watch

# Generate coverage report
npm run test:coverage
```

## Development Commands

```bash
# Start development server
npm run dev

# Build for production
npm build

# Start production server
npm start

# Run linter
npm run lint

# Run tests
npm test
```

---

## Remaining Implementation Tasks

### Priority 1: Profile Management (Critical for Full Feature Set)

#### 1. **Profile Data in Dashboard** 
- [ ] Fetch profile data from `profiles` table in dashboard page
- [ ] Display full_name field if available
- [ ] Display avatar if available
- [ ] Add loading/error states

**Why**: Dashboard should show complete user profile, not just auth user email

**Location**: `app/(protected)/dashboard/page.tsx`

---

#### 2. **Profile Update Form**
- [ ] Create form to edit full_name
- [ ] Implement form submission to update `profiles` table
- [ ] Add success/error messages
- [ ] Add cancel button
- [ ] Validate input fields

**Why**: Users need ability to update their profile information

**Location**: `app/(protected)/profile/page.tsx`

**Implementation**:
```typescript
// Need to add:
- Form state (fullName)
- Update handler calling Supabase
- Form submit button
- Success/error notifications
```

---

#### 3. **Avatar Upload to Supabase Storage**
- [ ] Create `avatars` bucket in Supabase Storage (via dashboard or migration)
- [ ] Add file input for avatar selection
- [ ] Add image preview before upload
- [ ] Implement upload handler using Supabase Storage API
- [ ] Store file with naming convention: `{user_id}/{filename}`
- [ ] Update `avatar_url` in profiles table after upload
- [ ] Display current avatar with fallback to default
- [ ] Add file type validation (jpg, png, gif, webp)
- [ ] Add file size validation (max 2MB recommended)
- [ ] Show upload progress/loading state
- [ ] Handle upload errors

**Why**: Avatar upload is core feature for user profile customization

**Location**: `app/(protected)/profile/page.tsx`

**Supabase Storage Setup**:
```bash
# Create bucket programmatically or via Supabase dashboard:
1. Go to Storage in Supabase dashboard
2. Create new bucket: "avatars"
3. Set to private
4. Create RLS policy for authenticated user uploads
```

---

### Priority 2: Home Page Enhancement (Improves UX)

#### 1. **Auth Status Display on Home Page**
- [ ] Convert home page to use server component
- [ ] Fetch user session on server-side
- [ ] Show auth status message (authenticated/not authenticated)
- [ ] Show "Go to Dashboard" link if authenticated
- [ ] Show "Sign In/Sign Up" buttons if not authenticated

**Why**: Home page should adapt to user's auth state

**Location**: `app/page.tsx`

---

### Priority 3: Optional Enhancements

#### 1. **Password Strength Indicator** (Signup)
- [ ] Add visual password strength meter
- [ ] Show strength requirements
- [ ] Only enable submit button for strong passwords

**Location**: `app/(auth)/signup/page.tsx`

---

#### 2. **Confirm Password Field** (Signup)
- [ ] Add confirm password input
- [ ] Validate passwords match
- [ ] Show mismatch error

**Location**: `app/(auth)/signup/page.tsx`

---

#### 3. **Terms of Service Checkbox** (Signup)
- [ ] Add checkbox for terms acceptance
- [ ] Link to terms/privacy policy pages
- [ ] Require checked before signup

**Location**: `app/(auth)/signup/page.tsx`

---

## Quick Reference: What's Already Done

✅ **Core Features**:
- Complete authentication system (sign up, sign in, sign out)
- Protected routes with middleware
- Database schema with triggers and RLS
- Custom React hooks for auth state
- Reusable UI components
- Automatic profile creation on signup
- TailwindCSS styling with dark mode

✅ **Pages**:
- `/` - Home page with feature highlights
- `/signin` - Email/password login
- `/signup` - Email/password registration
- `/dashboard` - Protected user dashboard
- `/profile` - Protected profile page (auth info only)

✅ **Infrastructure**:
- Next.js 16.1.6 App Router
- TypeScript for type safety
- Supabase with @supabase/ssr
- PostgreSQL with migrations and RLS
- Tailwind CSS v4
- Vitest for testing
- ESLint for code quality

---

## Next Steps to Reach MVP

1. **Update Dashboard** - Fetch and display profile data
2. **Create Profile Form** - Allow users to update their information
3. **Implement Avatar Upload** - Add file upload to Supabase Storage
4. **Enhance Home Page** - Show auth status and conditional navigation

After these tasks, the application will have a complete user profile management system!
