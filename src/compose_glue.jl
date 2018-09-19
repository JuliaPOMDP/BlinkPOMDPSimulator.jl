using Compose

function blink!(win::W, rendering::Compose.Context) where W <: WindowLike
    x, y = size(win)
    sz = min(x,y)
    s = SVG(0.98*sz*px, 0.98*sz*px)
    draw(s, rendering)
    blink!(win, s)
end
