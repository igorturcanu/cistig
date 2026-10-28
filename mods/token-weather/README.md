# token-weather

Shows how full the context window is as a weather forecast in the status line, from clear (under 25 percent) to storm (85 percent and above), updated after every turn.

## Install

`/plugin install token-weather --marketplace igorturcanu/cistig`, or Copy this folder into your mods folder, or load it for a session with `claude --plugin-dir ./mods/token-weather`. It hot-reloads when its files change. Check it with `claude plugin validate ./mods/token-weather`.

## Remove

Delete the folder, or stop passing `--plugin-dir`. The mod keeps no data of its own.

## License

MIT, see LICENSE.
