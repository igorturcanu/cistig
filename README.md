# cistig

Small Claude Code mods, one folder each under `mods/`:

- `done-ding`: toast when Claude finishes a turn
- `blast-radius`: confirmation before destructive Bash commands
- `token-weather`: context-window fill as a weather forecast in the status line
- `next-steps`: Claude ends answers with suggested next steps
- `reflect`: Claude proposes CLAUDE.md rules when you correct it

Load one with `claude --plugin-dir ./mods/<name>`. Each folder has its own README. MIT licensed.
