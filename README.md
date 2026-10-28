# cistig

Small Claude Code mods, one folder each under `mods/`:

- `done-ding`: toast when Claude finishes a turn
- `blast-radius`: confirmation before destructive Bash commands
- `token-weather`: context-window fill as a weather forecast in the status line
- `next-steps`: Claude ends answers with suggested next steps
- `reflect`: Claude proposes CLAUDE.md rules when you correct it
- `secret-guard`: blocks API keys, tokens and passwords in commands and files

Install from the marketplace: `/plugin marketplace add igorturcanu/cistig`, then `/plugin install <name>@cistig`. Or load one directly with `claude --plugin-dir ./mods/<name>`. Each folder has its own README. MIT licensed.
