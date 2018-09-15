# Blink POMDP Simulator

A simulator for visualizing problems in real time.

```julia
using POMDPs
using BlinkPOMDPSimulator
using POMDPModels
using POMDPPolicies

bs = BlinkSimulator()

mdp = SimpleGridWorld()
p = FunctionPolicy(s->:up)

simulate(bs, mdp, p)
```
