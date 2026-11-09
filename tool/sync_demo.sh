#!/usr/bin/env bash
set -e

# Directories
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXAMPLE_DIR="$PROJECT_ROOT/example"
SITE_DIR="$PROJECT_ROOT/../../web/abdulrasol.github.io"
TARGET_DEMO_DIR="$SITE_DIR/packages/frostuikit/demo"

echo "=========================================="
echo "🚀 Building Flutter Web Demo for Documentation"
echo "=========================================="

cd "$EXAMPLE_DIR"
flutter pub get
flutter build web --release --base-href "/packages/frostuikit/demo/"

echo ""
echo "📦 Copying build to documentation site..."
mkdir -p "$TARGET_DEMO_DIR"
rm -rf "$TARGET_DEMO_DIR"/*
cp -R "$EXAMPLE_DIR/build/web/"* "$TARGET_DEMO_DIR/"

echo "🔨 Rebuilding documentation site..."
if [ -d "$SITE_DIR" ]; then
  cd "$SITE_DIR"
  python3 build-packages.py
fi

echo ""
echo "✅ Demo built and synced successfully to: $TARGET_DEMO_DIR"

