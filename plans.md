# Node.js + Next.js 13+ App with Supabase

## Project Overview
A full-stack web application built with:
- **Next.js 13+** (App Router)
- **TypeScript**
- **Supabase** (Auth & Database)
- **@supabase/ssr** (Server-side rendering)

## Tech Stack
- Next.js 13+ with App Router
- TypeScript
- Supabase (PostgreSQL, Auth, Storage)
- Jest/Vitest for testing
- TailwindCSS (optional, for styling)

## Key Features
- ✅ User authentication (signup/login)
- ✅ Protected routes with auth guards
- ✅ User profile management
- ✅ Avatar upload to Supabase Storage
- ✅ Database migrations via migration files
- ✅ Reusable auth hooks and utilities
- ✅ Comprehensive unit tests
- ✅ Proper error handling

## Project Structure
```
src/
├── app/                    # Next.js App Router pages
│   ├── (auth)/            # Auth-related pages
│   ├── (protected)/       # Protected pages (dashboard, profile)
│   └── layout.tsx         # Root layout
├── components/
│   ├── ui/                # Reusable UI components
│   └── auth/              # Auth-specific components
├── hooks/                 # Custom React hooks (useAuth, etc.)
├── lib/                   # Utility functions & helpers
├── utils/                 # General utilities
├── types/                 # TypeScript types & interfaces
├── __tests__/             # Unit tests
└── middleware.ts          # Next.js middleware

supabase/
├── migrations/            # SQL migration files
└── schemas/              # Declarative schema definitions
```

## Setup Instructions
1. Initialize Next.js project with TypeScript
2. Install Supabase dependencies
3. Configure environment variables
4. Set up database migrations
5. Implement auth hooks and utilities
6. Create pages and components
7. Configure testing framework

## Next Steps
- [ ] Initialize project structure
- [ ] Set up Supabase client with @supabase/ssr
- [ ] Create database migrations
- [ ] Implement authentication utilities
- [ ] Build pages (home, login, signup, dashboard, profile)
- [ ] Add component library
- [ ] Set up testing framework
- [ ] Write documentation
## Detailed Implementation Guide

### 1. Next.js Application Setup
- Create Next.js project with `create-next-app@latest`
- Enable TypeScript during initialization
- Organize folders: `src/app`, `src/components`, `src/lib`, `src/hooks`, `src/types`
- Install TailwindCSS for styling: `npm install -D tailwindcss postcss autoprefixer`
- Configure `tailwind.config.ts` and `globals.css`

### 2. Supabase Integration
- Install Supabase CLI: `npm install -D supabase`
- Install client library: `npm install @supabase/supabase-js @supabase/ssr`
- Create `src/lib/supabase/client.ts` for client-side operations
- Create `src/lib/supabase/server.ts` for server-side operations
- Set up `src/middleware.ts` for token refresh using `@supabase/ssr`
- Configure `.env.local` with `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`

### 3. User Authentication
- Implement `src/app/(auth)/signup/page.tsx` with form handling
- Implement `src/app/(auth)/signin/page.tsx` with login logic
- Create `src/hooks/useAuth.ts` for authentication state management
- Build sign-out functionality in user menu component
- Implement route guards in `src/middleware.ts` for protected routes
- Display user info via custom hook accessing Supabase session

### 4. Profile Model & Declarative Schema
- Create `supabase/schemas/profiles.sql` with table definition
- Include columns: `id (UUID)`, `email`, `created_at`, `updated_at`
- Set `id` as foreign key to `auth.users(id)`
- Generate migration: `npx supabase db diff --schema public > supabase/migrations/[timestamp]_create_profiles.sql`

### 5. Automatic Profile Creation
- Create trigger function in migration: `handle_new_user()`
- Function extracts `email` from `new.email` in `auth.users`
- Inserts record into `profiles` with `id` and `email`
- Add trigger: `AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION handle_new_user()`

### 6. Row Level Security
- Enable RLS: `ALTER TABLE profiles ENABLE ROW LEVEL SECURITY`
- Policy for SELECT: `auth.uid() = id`
- Policy for UPDATE: `auth.uid() = id`
- Policy for INSERT: `auth.uid() = id`

### 7. Setup Script
- Create `scripts/setup.sh` or `setup.js`
- Run: `npm install`, `npx supabase start`, `npx supabase db reset`
- Extract credentials from Supabase output
- Generate `.env.local` with credentials
- Make idempotent with existence checks
- Include error handling and success messages

### Deployment & CI/CD

**Deployment Documentation**
- Document steps for production Supabase project setup
- Environment variable configuration for Vercel/Netlify
- Database linking to production instance
- Platform-specific considerations (custom domains, SSL)

**GitHub Actions Workflow**
- Create `.github/workflows/db-migrations.yml`
- Trigger on push to `main` branch
- Use Supabase CLI to run migrations: `supabase migration up --db-url ${{ secrets.PROD_DB_URL }}`
- Store sensitive credentials in GitHub Secrets
- Include error notifications and migration status reporting
- Document setup instructions in README