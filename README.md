# Supabase Starter

A full-stack Next.js 13+ application with Supabase authentication, protected routes, and a complete development setup.

## Features

- ✅ **Authentication** - Sign up, sign in, and session management
- ✅ **Protected Routes** - Middleware-based route protection
- ✅ **User Profiles** - Automatic profile creation with database triggers
- ✅ **Row Level Security** - Secure database access with Supabase RLS
- ✅ **TypeScript** - Fully typed with custom hooks and utilities
- ✅ **TailwindCSS** - Modern styling with dark mode support
- ✅ **Database Migrations** - Version-controlled database schema
- ✅ **Testing Setup** - Ready for unit and integration tests

## Tech Stack

- **Framework**: Next.js 13+ (App Router)
- **Language**: TypeScript
- **Database**: PostgreSQL (via Supabase)
- **Auth**: Supabase Auth
- **Styling**: TailwindCSS
- **ORM**: Supabase Client (@supabase/ssr)

## Project Structure

```
├── app/
│   ├── (auth)/              # Authentication pages (signin, signup)
│   ├── (protected)/         # Protected pages (dashboard, profile)
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
├── components/
│   ├── auth/                # Auth-specific components
│   └── ui/                  # Reusable UI components
├── hooks/                   # Custom React hooks (useAuth, etc.)
├── lib/
│   └── supabase/            # Supabase client utilities
├── types/                   # TypeScript type definitions
├── utils/                   # Utility functions
├── __tests__/               # Unit tests
├── supabase/
│   ├── migrations/          # SQL migration files
│   └── schemas/             # Declarative schema definitions
├── middleware.ts            # Next.js middleware for auth
└── scripts/
    └── setup.sh             # Setup script
```

## Getting Started

### Prerequisites

- Node.js 18+ and npm
- Docker (for local Supabase)

### Quick Setup

1. **Clone and install dependencies**
   ```bash
   npm install
   ```

2. **Run the setup script**
   ```bash
   chmod +x scripts/setup.sh
   ./scripts/setup.sh
   ```

3. **Start Supabase locally**
   ```bash
   npx supabase start
   ```

4. **Copy credentials to `.env.local`**
   ```bash
   cp .env.local.example .env.local
   # Update with your Supabase URL and anon key
   ```

5. **Apply database migrations**
   ```bash
   npx supabase db reset
   ```

6. **Start the development server**
   ```bash
   npm run dev
   ```

7. **Open your browser**
   Navigate to [http://localhost:3000](http://localhost:3000)

### Manual Setup

If you prefer manual setup or are using a remote Supabase project:

1. **Install dependencies**
   ```bash
   npm install
   ```

2. **Set up environment variables**
   Create a `.env.local` file with:
   ```env
   NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

3. **Link to your Supabase project** (for remote projects)
   ```bash
   npx supabase link --project-ref your-project-ref
   npx supabase db push
   ```

4. **Start development**
   ```bash
   npm run dev
   ```

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint
- `npm test` - Run tests (after setting up Jest/Vitest)

## Supabase Commands

- `npx supabase start` - Start local Supabase
- `npx supabase stop` - Stop local Supabase
- `npx supabase status` - Check Supabase status
- `npx supabase db reset` - Reset database and apply migrations
- `npx supabase db push` - Push migrations to remote
- `npx supabase db diff` - Generate migration from schema changes
- `npx supabase migration new <name>` - Create new migration

## Database Schema

The application includes a `profiles` table that is automatically populated when users sign up:

```sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

Row Level Security (RLS) policies ensure users can only access their own data.

## Authentication Flow

1. **Sign Up**: Creates user in `auth.users` and triggers profile creation
2. **Sign In**: Establishes session with secure cookies
3. **Protected Routes**: Middleware checks authentication before allowing access
4. **Sign Out**: Clears session and redirects to signin

## Custom Hooks

- `useAuth()` - Access current user and session state
- `useRequireAuth()` - Protect client-side routes

## Testing

Unit tests are located in the `__tests__` directory. To set up testing:

```bash
# Install Vitest (recommended)
npm install -D vitest @testing-library/react @testing-library/jest-dom

# Run tests
npm test
```

## Deployment

### Vercel (Recommended)

1. Push your code to GitHub
2. Import project in Vercel
3. Add environment variables:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
4. Deploy

### Database Migrations in Production

```bash
npx supabase link --project-ref your-production-ref
npx supabase db push
```

Or use GitHub Actions for automated deployments (see `.github/workflows/` for examples).

## Environment Variables

Required environment variables:

- `NEXT_PUBLIC_SUPABASE_URL` - Your Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Your Supabase anonymous key

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

MIT

## Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [TailwindCSS Documentation](https://tailwindcss.com/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/docs)

## Support

For issues and questions, please open an issue on GitHub.
