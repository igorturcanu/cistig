# reflect

Adds a system prompt section so that after you correct Claude or state a preference, it proposes one concise rule for CLAUDE.md and adds it only if you agree. It saves instructions; it does not train the model.

## Install

Copy this folder into your mods folder, or load it for a session with `claude --plugin-dir ./mods/reflect`. It hot-reloads when its files change. Check it with `claude plugin validate ./mods/reflect`.

## Remove

Delete the folder, or stop passing `--plugin-dir`. The mod keeps no data of its own.

## License

MIT, see LICENSE.
