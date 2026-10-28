import type { Register } from 'claude-code'

export const register: Register = on => {
  on('prompt.compose', async ($, e, next) => {
    const r = await next(e)
    return { ...r, sections: [...r.sections, { id: 'next-steps', scope: 'session', text: "End each substantial answer with a short Next steps list of 2-3 concrete follow-up tasks the user could hand you." }] }
  })
}
