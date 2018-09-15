module BlinkPOMDPSimulator

using POMDPs
using POMDPModelTools
using POMDPSimulators
using Parameters
using Compose     # only for special blink!
using Blink
using Parameters
using Random

render = POMDPModels.render

export BlinkSimulator

@with_kw mutable struct BlinkSimulator <: Simulator
    max_steps::Int       = typemax(Int)
    max_fps::Float64     = 2.0
    extra_initial::Bool  = false
    extra_final::Bool    = false
    window::Window       = Window()
    render_kwargs        = NamedTuple()
    rng::AbstractRNG     = Random.GLOBAL_RNG
end

function POMDPs.simulate(sim::BlinkSimulator,
                         m::MDP,
                         p::Policy=RandomPolicy(m, sim.rng),
                         is=initialstate(m, sim.rng)
                        )

    dt = 1/sim.max_fps
    tm = time()

    if sim.extra_initial
        step = (t=0, sp=is)
        gfx = render(m, step; sim.render_kwargs...)
        blink!(sim.window, gfx)
        sleep_until(tm += dt)
    end

    nsteps = 0
    last_sp = missing
    for step in stepthrough(m, p, is; max_steps=sim.max_steps)
        gfx = render(m, step; sim.render_kwargs...)
        blink!(sim.window, gfx)
        sleep_until(tm + dt)
        tm = max(time(), tm + dt)
        nsteps += 1
        last_sp = get(step, :sp, missing)
    end

    if sim.extra_final
        step = (t=nsteps+1, s=last_sp, done=true)
        gfx = render(m, step; sim.render_kwargs...)
        blink!(win, gfx)
    end
end

sleep_until(t) = sleep(max(t-time(), 0.0))

# hack to av
blink!(win::Window, rendering) = body!(win, rendering, fade=false)
function blink!(win::Window, rendering::Compose.Context)
    x, y = size(win)
    sz = min(x,y)
    s = SVG(0.98*sz*px, 0.98*sz*px)
    draw(s, rendering)
    body!(win, s, fade=false)
end

end # module
