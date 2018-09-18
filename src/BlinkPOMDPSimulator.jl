module BlinkPOMDPSimulator

using POMDPs
using POMDPModelTools
using POMDPSimulators
using POMDPPolicies
using Parameters
using Blink
using Random
using Base64: stringmime

using Compose     # only for special blink!

export BlinkSimulator

struct TestWindow end

include("testing.jl")

const WindowLike = Union{Window, TestWindow}

@with_kw mutable struct BlinkSimulator <: Simulator
    max_steps::Int         = typemax(Int)
    max_fps::Float64       = 2.0
    extra_initial::Bool    = false
    extra_final::Bool      = false
    window::WindowLike     = Window()
    render_kwargs          = NamedTuple()
    rng::AbstractRNG       = Random.GLOBAL_RNG
end

function POMDPs.simulate(sim::BlinkSimulator,
                         m::MDP,
                         p::Policy=RandomPolicy(m, rng=sim.rng),
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
    for step in stepthrough(m, p, is; max_steps=sim.max_steps, rng=sim.rng)
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
        blink!(sim.window, gfx)
    end
end

function POMDPs.simulate(sim::BlinkSimulator,
                         m::POMDP,
                         p::Policy=RandomPolicy(m, rng=sim.rng),
                         u::Updater=updater(p),
                         isd=initialstate_distribution(m),
                         is=initialstate(m, sim.rng)
                        )

    b0 = initialize_belief(u, isd)

    dt = 1/sim.max_fps
    tm = time()

    if sim.extra_initial
        step = (t=0, sp=is, bp=b0)
        gfx = render(m, step; sim.render_kwargs...)
        blink!(sim.window, gfx)
        sleep_until(tm += dt)
    end

    nsteps = 0
    last = (s=missing, b=missing)
    for step in stepthrough(m, p, u, b0, is; max_steps=sim.max_steps, rng=sim.rng)
        gfx = render(m, step; sim.render_kwargs...)
        blink!(sim.window, gfx)
        sleep_until(tm + dt)
        tm = max(time(), tm + dt)
        nsteps += 1
        last = (s=get(step, :sp, missing), b=get(step, :bp, missing))
    end

    if sim.extra_final
        step = merge((t=nsteps+1, done=true), last)
        gfx = render(m, step; sim.render_kwargs...)
        blink!(sim.window, gfx)
    end
end


sleep_until(t) = sleep(max(t-time(), 0.0))

# hack to av
blink!(win::Window, rendering) = body!(win, rendering, fade=false)
function blink!(win::W, rendering::Compose.Context) where W <: WindowLike
    x, y = size(win)
    sz = min(x,y)
    s = SVG(0.98*sz*px, 0.98*sz*px)
    draw(s, rendering)
    blink!(win, s)
end

end # module
