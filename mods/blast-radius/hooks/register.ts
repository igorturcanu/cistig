import type { Register } from 'claude-code'

const DANGEROUS = /\b(rm\s+-[a-z]*r[a-z]*f?|rm\s+-[a-z]*f[a-z]*r|git\s+reset\s+--hard|git\s+push\s+.*--force|git\s+clean\s+-[a-z]*f|drop\s+(table|database)|mkfs|dd\s+if=)/i

export const register: Register = on => {
  on('tool.call', { tool: 'Bash' }, async ($, e, next) => {
    if (!DANGEROUS.test(e.command)) return next(e)
    const answer = await $.ui.ask(`Blast Radius: run "${e.command.slice(0, 120)}"?`, ['Allow', 'Deny'])
    return answer === 'Allow' ? next(e) : { deny: `${$.plugin.name}: you declined this command.` }
  })
}
