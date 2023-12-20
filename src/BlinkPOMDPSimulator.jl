module BlinkPOMDPSimulator

using POMDPs
using POMDPTools
using Parameters
using Blink
using Random

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
                         s0=rand(sim.rng, initialstate(m))
                        )

    dt = 1/sim.max_fps
    tm = time()

    if sim.extra_initial
        step = (t=0, sp=s0)
        gfx = render(m, step; sim.render_kwargs...)
        blink!(sim.window, gfx)
        sleep_until(tm += dt)
    end

    nsteps = 0
    last_sp = missing
    for step in stepthrough(m, p, s0, "s, sp, a, r"; max_steps=sim.max_steps, rng=sim.rng)
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
                         b0=initialstate(m),
                         s0=rand(sim.rng, b0)
)

    dt = 1/sim.max_fps
    tm = time()

    if sim.extra_initial
        step = (t=0, sp=s0, bp=b0)
        gfx = render(m, step; sim.render_kwargs...)
        blink!(sim.window, gfx)
        sleep_until(tm += dt)
    end

    nsteps = 0
    last = (s=missing, b=missing)
    for step in stepthrough(m, p, u, b0, s0; max_steps=sim.max_steps, rng=sim.rng)
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

blink!(win::Window, rendering) = body!(win, rendering, fade=false)

end # module
