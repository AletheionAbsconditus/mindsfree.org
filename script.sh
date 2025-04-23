#!/bin/bash

# ─── CONFIG ──────────────────────────────────────────────────────────────
BUILD_DIR="public"
DEPLOY_BRANCH="gh-pages"
REPO_SSH="git@github.com:AletheionAbsconditus/mindsfree.org.git"

echo "🌱 [Aeternum Deploy] Rebuilding and syncing..."

# ─── BUILD THE SITE ──────────────────────────────────────────────────────
hugo --cleanDestinationDir
if [ $? -ne 0 ]; then
  echo "❌ Hugo build failed."
  exit 1
fi

# ─── COPY CNAME ──────────────────────────────────────────────────────────
cp static/CNAME $BUILD_DIR/CNAME

# ─── INIT OR UPDATE GIT IN PUBLIC FOLDER ─────────────────────────────────
cd $BUILD_DIR || exit

if [ ! -d ".git" ]; then
  git init
  git remote add origin "$REPO_SSH"
fi

git checkout -B $DEPLOY_BRANCH

git add .
if git diff --cached --quiet; then
  echo "⚠️  No changes to commit."
else
  git commit -m "🚀 Aeternum deploy: $(date +'%Y-%m-%d %H:%M:%S')"
fi

git push -f origin $DEPLOY_BRANCH

echo "✅ Site deployed successfully to GitHub Pages!"

