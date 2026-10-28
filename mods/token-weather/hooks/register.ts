import type { Register } from 'claude-code'

const forecast = (p: number) =>
  p < 25 ? '☀️ clear' : p < 50 ? '🌤️ fair' : p < 70 ? '⛅ cloudy' : p < 85 ? '🌧️ rain' : '⛈️ storm'

export const register: Register = on => {
  on('turn.complete', async ($, e, next) => {
    const { context } = await $.session.usage()
    const pct = context.percent ?? (context.tokens ? (context.tokens / context.window) * 100 : 0)
    $.ui.status(`${forecast(pct)} ${Math.round(pct)}% context`)
    return next(e)
  })
}
