#!/bin/bash
# Puts this folder on GitHub as "saucer-climb" and turns on GitHub Pages.
# Run it with:  bash ~/projects/saucer-climb/push-to-github.sh
# Running it again later pushes any changes as an update.
set -euo pipefail
REPO="saucer-climb"
cd "$(dirname "$0")"
say(){ printf '\n\033[1m%s\033[0m\n' "$1"; }

say "1/4  Checking tools"
command -v git >/dev/null || { echo "git is missing. Install it with: xcode-select --install"; exit 1; }
if ! command -v gh >/dev/null; then
  if command -v brew >/dev/null; then brew install gh; else echo "Install Homebrew from https://brew.sh, then run this again."; exit 1; fi
fi
gh auth status >/dev/null 2>&1 || gh auth login --hostname github.com --git-protocol https --web
USER_NAME=$(gh api user --jq .login)
echo "Signed in to GitHub as $USER_NAME"

say "2/4  Committing"
[ -d .git ] || git init -q -b main
git config user.name >/dev/null || git config user.name "$USER_NAME"
git config user.email >/dev/null || git config user.email "$USER_NAME@users.noreply.github.com"
printf '.DS_Store\n' > .gitignore
git add .
git commit -q -m "Saucer Climb" 2>/dev/null || echo "Nothing new to commit"

say "3/4  Pushing to GitHub"
if gh repo view "$USER_NAME/$REPO" >/dev/null 2>&1; then
  git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$USER_NAME/$REPO.git"
  git push -u origin main
else
  gh repo create "$REPO" --public --source=. --remote=origin --push
fi

say "4/4  Turning on GitHub Pages"
gh api "repos/$USER_NAME/$REPO/pages" -X POST -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
  && echo "Pages is on." || echo "Pages was already on."

say "Done"
echo "Repo:  https://github.com/$USER_NAME/$REPO"
echo "Game:  https://$USER_NAME.github.io/$REPO/   (live in a minute or two)"
