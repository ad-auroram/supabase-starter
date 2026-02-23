import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'
import { cookies } from 'next/headers'

export async function proxy(request: NextRequest) {
  const response = NextResponse.next()
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll: async () => {
          return (await cookies()).getAll()
        },
        setAll: async (cookiesToSet) => {
          const cookiesInstance = await cookies()
          cookiesToSet.forEach(({ name, value, options }) => {
            cookiesInstance.set(name, value, options)
          })
        },
      },
    }
  )

  // Refresh session if expired - 30 seconds before expiration
  await supabase.auth.getUser()

  return response
}

export const config = {
  matcher: [
    '/',
    '/(about|blog|contact)(?!/_next/.*)?$',
  ],
  ignoredRoutes: ['/_next/static', '/_external', '/api/auth/callback'],
}