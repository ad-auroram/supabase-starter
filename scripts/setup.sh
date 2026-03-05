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

# Check if node_modules exists and dependencies are installed
echo ""
if [ -d "node_modules" ] && npm list > /dev/null 2>&1; then
    echo "✅ Dependencies are already installed"
else
    echo "📦 Installing dependencies..."
    npm install
    echo "✅ Dependencies installed successfully"
fi

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
    echo "📝 Creating .env.local..."
    cat > .env.local << 'EOF'
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
EOF
    echo "✅ .env.local created (credentials will be filled automatically)"
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
    echo "🔑 Extracting credentials..."
    
    # Extract API URL and anon key from supabase status
    STATUS_OUTPUT=$($SUPABASE_CMD status 2>&1)
    
    # Extract Project URL specifically (avoid grabbing Studio/Mailpit URLs)
    API_URL=$(echo "$STATUS_OUTPUT" | grep "Project URL" | grep -o "http://[^[:space:]│]*" | head -1)
    if [ -z "$API_URL" ]; then
        API_URL=$(echo "$STATUS_OUTPUT" | grep -o "http://127\.0\.0\.1:[0-9]*" | head -1)
    fi
    
    # Extract Publishable key (look for sb_publishable_ pattern)
    ANON_KEY=$(echo "$STATUS_OUTPUT" | grep -o "sb_publishable_[-A-Za-z0-9_]*" | head -1)
    
    if [ -z "$API_URL" ] || [ -z "$ANON_KEY" ]; then
        echo "⚠️  Could not automatically extract credentials"
        echo "📋 Please manually copy and update .env.local:"
        echo ""
        echo "Add the following to .env.local:"
        echo "  NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321"
        echo "  NEXT_PUBLIC_SUPABASE_ANON_KEY=<Publishable key from below>"
        echo ""
        $SUPABASE_CMD status
    else
        echo "✅ Credentials extracted successfully"
        echo ""
        echo "📝 Updating .env.local..."
        
        # Update .env.local with credentials
        if grep -q "NEXT_PUBLIC_SUPABASE_URL=" .env.local; then
            sed -i.bak "s|NEXT_PUBLIC_SUPABASE_URL=.*|NEXT_PUBLIC_SUPABASE_URL=$API_URL|" .env.local
            sed -i.bak "s|NEXT_PUBLIC_SUPABASE_ANON_KEY=.*|NEXT_PUBLIC_SUPABASE_ANON_KEY=$ANON_KEY|" .env.local
            rm -f .env.local.bak
        else
            cat >> .env.local << EOF

NEXT_PUBLIC_SUPABASE_URL=$API_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY=$ANON_KEY
EOF
        fi
        
        echo "✅ .env.local updated with Supabase credentials!"
        echo ""
        echo "📋 Credentials:"
        echo "   API URL: $API_URL"
        echo "   Anon Key: ${ANON_KEY:0:20}..."
    fi
    
    # Run database migrations if credentials were found
    if [ -n "$API_URL" ] && [ -n "$ANON_KEY" ]; then
        echo ""
        echo "🗄️  Running database migrations..."
        $SUPABASE_CMD db reset
        echo "✅ Migrations completed!"
    else
        echo ""
        echo "⚠️  Skipping migrations until credentials are set in .env.local"
        echo "   Once you've added them, run: npx supabase db reset"
    fi
fi

echo ""
echo "✨ Setup complete!"
echo "📖 Next steps:"
echo "   1. Run 'npm run dev' to start the development server"
echo "   2. Visit http://localhost:3000"
echo "   3. Sign up for a new account to test authentication"
