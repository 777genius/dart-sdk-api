#!/usr/bin/env bash
set -e

# Deploy Dart SDK API docs to GitHub Pages
# Usage: ./deploy.sh [--generate] [--build] [--deploy]
# Without flags: runs all steps

DARTDOC_VITEPRESS="${DARTDOC_VITEPRESS_PATH:-$HOME/dev/projects/dartdoc-vitepress}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

do_generate=false
do_build=false
do_deploy=false

if [ $# -eq 0 ]; then
  do_generate=true
  do_build=true
  do_deploy=true
else
  for arg in "$@"; do
    case $arg in
      --generate) do_generate=true ;;
      --build) do_build=true ;;
      --deploy) do_deploy=true ;;
      *) echo "Unknown option: $arg"; exit 1 ;;
    esac
  done
fi

cd "$SCRIPT_DIR"

# Step 1: Generate API markdown from Dart SDK
if [ "$do_generate" = true ]; then
  echo "==> Generating Dart SDK API docs..."
  dart run "$DARTDOC_VITEPRESS/bin/dartdoc_vitepress.dart" \
    --sdk-docs --format vitepress --output .
  echo "==> Done. $(find api -name '*.md' | wc -l | tr -d ' ') pages generated."
fi

# Step 2: Build VitePress
if [ "$do_build" = true ]; then
  echo "==> Installing dependencies..."
  npm install

  echo "==> Building VitePress (max heap 24GB)..."
  NODE_OPTIONS="--max-old-space-size=24576" npx vitepress build
  echo "==> Build complete. Size: $(du -sh .vitepress/dist | cut -f1)"
fi

# Step 3: Deploy to GitHub Pages
if [ "$do_deploy" = true ]; then
  echo "==> Deploying to GitHub Pages..."
  cd .vitepress/dist

  # Disable Jekyll processing on GitHub Pages
  touch .nojekyll

  git init
  git checkout -b gh-pages
  git add -A
  git commit -m "deploy $(date '+%Y-%m-%d %H:%M')"
  git push -f https://github.com/777genius/dart-sdk-api.git gh-pages

  cd "$SCRIPT_DIR"
  echo "==> Deployed! Site: https://777genius.github.io/dart-sdk-api/"
fi
