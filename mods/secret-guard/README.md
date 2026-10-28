# secret-guard

Blocks Claude from writing files or running Bash commands that contain API keys, tokens, private keys or hard-coded passwords. Claude is told to read the value from an environment variable instead.

It checks Bash commands, Write content and Edit replacements against patterns for AWS, GitHub, Anthropic/OpenAI, Slack and Google keys, PEM private keys and `password = "..."` style assignments.

This is a safeguard, not a guarantee: it matches known patterns and can miss unusual secrets or flag harmless strings.

## Install

`/plugin install secret-guard --marketplace igorturcanu/cistig`, or `claude --plugin-dir ./mods/secret-guard`, or `/plugin install secret-guard --marketplace <owner>/<repo>`. Check it with `claude plugin validate ./mods/secret-guard`. Remove it by deleting the folder.

## License

MIT, see LICENSE.
