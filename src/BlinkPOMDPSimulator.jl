module BlinkPOMDPSimulator

using POMDPs
using POMDPSimulators
using Parameters
using Compose     # only for 
using POMDPModels # XXX should be removed when render is in POMDPModelTools
using Blink
using Parameters
using Random

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
                         p::Policy,
                         is=initialstate(m, sim.rng)
                        )

    dt = 1/sim.max_fps
    tm = time()

    if sim.extra_initial
        step = (t=0, sp=is)
        blink!(sim.window, render(mdp, step; render_kwargs...))
        sleep_until(tm += dt)
    end

    nsteps = 0
    last_sp = nothing
    for step in stepthrough(m, p, is; max_steps=sim.max_steps)
        blink!(sim.window, render(mdp, step; render_kwargs...))
        sleep_until(tm += dt)
        nsteps += 1
        last_sp = get(step, :sp, nothing)
    end

    if sim.extra_final
        step = (t=nsteps+1, s=last_sp, done=true)
        blink!(sim.window, render(mdp, step; render_kwargs...))
        sleep_until(tm += dt)
    end
end

blink!(win::Window, rendering) = body!(win, rendering)
blink!(win::Window, rendering) = body!(win, rendering)

sleep_until(t) = sleep(max(t-time(), 0.0))

end # module
