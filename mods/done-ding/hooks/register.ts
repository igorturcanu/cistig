import type { Register } from 'claude-code'

export const register: Register = on => {
  on('turn.complete', ($, e, next) => {
    if (!e.answer) return next(e)
    $.ui.toast(`Done in ${Math.round(e.durationMs / 1000)}s`)
    return next(e)
  })
}
