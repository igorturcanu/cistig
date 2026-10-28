import type { Register } from 'claude-code'

const SECRETS: [string, RegExp][] = [
  ['AWS access key', /\bAKIA[0-9A-Z]{16}\b/],
  ['GitHub token', /\bgh[pousr]_[A-Za-z0-9]{36,}\b/],
  ['Anthropic/OpenAI key', /\bsk-[A-Za-z0-9_-]{20,}\b/],
  ['Slack token', /\bxox[abprs]-[A-Za-z0-9-]{10,}\b/],
  ['Google API key', /\bAIza[0-9A-Za-z_-]{35}\b/],
  ['private key', /-----BEGIN [A-Z ]*PRIVATE KEY-----/],
  ['hard-coded password', /\b(password|passwd|secret|api[_-]?key|token)\b\s*[:=]\s*["'][^"'\s]{8,}["']/i],
]

const find = (text: string) => SECRETS.find(([, re]) => re.test(text))?.[0]

const deny = ($: { plugin: { name: string } }, hit: string) => ({
  deny: `${$.plugin.name}: this looks like a ${hit}. Read it from an environment variable instead.`,
})

export const register: Register = on => {
  on('tool.call', { tool: 'Bash' }, ($, e, next) => {
    const hit = find(e.command)
    return hit ? deny($, hit) : next(e)
  })

  on('tool.call', { tool: 'Write' }, ($, e, next) => {
    const hit = find(e.content)
    return hit ? deny($, hit) : next(e)
  })

  on('tool.call', { tool: 'Edit' }, ($, e, next) => {
    const hit = find(e.new_string)
    return hit ? deny($, hit) : next(e)
  })
}
