# blast-radius

Asks for your confirmation before Claude runs destructive Bash commands such as rm -rf, git reset --hard, git push --force, git clean -f, drop table/database, mkfs or dd. Declining returns a denial to Claude.

## Install

Copy this folder into your mods folder, or load it for a session with `claude --plugin-dir ./mods/blast-radius`. It hot-reloads when its files change. Check it with `claude plugin validate ./mods/blast-radius`.

## Remove

Delete the folder, or stop passing `--plugin-dir`. The mod keeps no data of its own.

## License

MIT, see LICENSE.
