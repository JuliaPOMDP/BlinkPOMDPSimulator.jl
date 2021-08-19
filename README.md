# Blink POMDP Simulator

[![Build Status](https://travis-ci.org/JuliaPOMDP/BlinkPOMDPSimulator.jl.svg?branch=master)](https://travis-ci.org/JuliaPOMDP/BlinkPOMDPSimulator.jl)

A simulator for visualizing [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) problems in real time.

The display simulator from [POMDPSimulators.jl](https://github.com/JuliaPOMDP/POMDPSimulators.jl) is a more modern alternative.

# Installation

Use the JuliaPOMDP registry:

```julia
import Pkg
Pkg.add("POMDPs")
import POMDPs
POMDPs.add_registry()
Pkg.add("BlinkPOMDPSimulator")
```

# Usage

```julia
using POMDPs
using BlinkPOMDPSimulator
using POMDPModels
using POMDPPolicies
using Compose

bs = BlinkSimulator()

mdp = SimpleGridWorld()
p = FunctionPolicy(s->:up)

simulate(bs, mdp, p)
```
