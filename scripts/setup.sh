#!/bin/bash

# Supabase Starter - Setup Script
# This script sets up your local development environment

set -e  # Exit on error

echo "🚀 Setting up Supabase Starter..."
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

echo "✅ Node.js is installed: $(node --version)"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

echo "✅ npm is installed: $(npm --version)"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install

# Check if Supabase CLI is available
if ! command -v supabase &> /dev/null; then
    echo ""
    echo "⚠️  Supabase CLI not found globally."
    echo "   Using npx supabase for local operations..."
    SUPABASE_CMD="npx supabase"
else
    echo "✅ Supabase CLI is installed"
    SUPABASE_CMD="supabase"
fi

# Check if .env.local exists
if [ ! -f .env.local ]; then
    echo ""
    echo "📝 Creating .env.local from template..."
    cp .env.local.example .env.local
    echo "⚠️  Please update .env.local with your Supabase credentials"
    echo ""
    echo "To start Supabase locally, run:"
    echo "  npx supabase start"
    echo ""
    echo "Then copy the credentials to .env.local"
else
    echo "✅ .env.local already exists"
fi

# Ask if user wants to start Supabase locally
echo ""
read -p "Do you want to start Supabase locally? (y/N) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "🐳 Starting Supabase locally..."
    $SUPABASE_CMD start
    
    echo ""
    echo "✅ Supabase is running!"
    echo ""
    echo "📋 Copy the following credentials to your .env.local file:"
    echo ""
    $SUPABASE_CMD status | grep -E "API URL|anon key"
    echo ""
    echo "Then update .env.local:"
    echo "  NEXT_PUBLIC_SUPABASE_URL=<API URL>"
    echo "  NEXT_PUBLIC_SUPABASE_ANON_KEY=<anon key>"
fi

echo ""
echo "✨ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Update .env.local with your credentials (if not done)"
echo "  2. Run 'npm run dev' to start the development server"
echo "  3. Visit http://localhost:3000"
echo ""
echo "For database migrations:"
echo "  npx supabase db reset    # Reset and apply migrations"
echo "  npx supabase db push     # Push new migrations"
echo ""
echo "Happy coding! 🎉"
