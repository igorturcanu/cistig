import type { Register } from 'claude-code'

export const register: Register = on => {
  on('prompt.compose', async ($, e, next) => {
    const r = await next(e)
    return { ...r, sections: [...r.sections, { id: 'reflect', scope: 'session', text: 'When the user corrects you or states a preference, finish by proposing one concise rule to add to CLAUDE.md, and add it only if they agree.' }] }
  })
}
