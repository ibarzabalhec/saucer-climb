# Saucer Climb

A tower-climbing game in 320×240 pixel art. Run to build speed, jump to climb, chain multi-floor jumps into combos. Plays in any desktop browser with a keyboard.

Two modes, chosen on the menu (or press C):

- **Saucer mode**: 14 alien species, random field events, crop circles, flybys, and an abduction when you fall.
- **Classic mode**: Little Green only, no events or effects. Just the climb. Classic keeps its own high scores.

## Controls

| Key | Action |
| --- | --- |
| ← → or A D | Run |
| Space, ↑ or W | Jump (hold to keep jumping) |
| P or Esc | Pause |
| R | Restart |
| M | Sound on or off |
| N | Next track |
| V | Presenter voice on or off |
| H | High scores |
| C | Switch between Saucer and Classic mode (menu) |
| B | Background: tiles, lines, or plain (Saucer mode) |
| R | Random species (menu) |
| F | Full screen |

## Put it on GitHub Pages

```sh
cd ~/projects/saucer-climb
git init
git add .
git commit -m "Saucer Climb"
git branch -M main
git remote add origin https://github.com/ibarzabalhec/saucer-climb.git
git push -u origin main
```

Create the empty `saucer-climb` repository on GitHub first. Then open the repository's Settings > Pages, set Source to "Deploy from a branch", pick `main` and `/ (root)`, and save. The game will be at `https://ibarzabalhec.github.io/saucer-climb/` after a minute or two.

## Turn on the online high scores

Without this step, scores are kept in each player's browser only. The game hides the online tabs.

1. Create a free project at [supabase.com](https://supabase.com).
2. Open SQL Editor, paste the contents of `supabase.sql`, and run it.
3. Open Project Settings > API. Copy the Project URL and the `anon` `public` key into `config.js`.
4. Commit and push `config.js`.

The high scores screen then shows three lists: All time, This week, and This Mac. Records rank by floor reached; points break ties. Players type their name after a qualifying run, and the game-over screen shows their online rank.

### About cheating

The anon key is public by design, so anyone determined can post a score without playing. The table rules block the obvious cases: names must be 1 to 24 characters of letters, numbers, spaces, and . ' -, and a score can't exceed what's possible for the floor reached. Scores can't be edited or deleted with the public key. To remove a bad entry, delete the row in the Supabase table editor.

## Files

- `index.html`: the whole game
- `config.js`: online high score settings
- `supabase.sql`: the database table and its rules
- `CREDITS.md`: sources for the recorded character voices (all CC0)
