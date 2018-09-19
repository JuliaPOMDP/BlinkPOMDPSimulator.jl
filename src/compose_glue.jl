using Compose

# this is just a workaround for https://github.com/GiovineItalia/Compose.jl/issues/304
# it should be removed when that is fixed
function blink!(win::Window, rendering::C) where C <: Compose.Container
    x, y = size(win)
    sz = min(x,y)
    s = SVG(0.98*sz*px, 0.98*sz*px)
    draw(s, rendering)
    blink!(win, s)
end

function blink!(win::TestWindow, rendering::C) where C <: Compose.Container
    s = SVG(400px, 400px)
    draw(s, rendering)
    blink!(win, s)
end
