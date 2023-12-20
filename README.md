# Blink POMDP Simulator

[![CI](https://github.com/JuliaPOMDP/BlinkPOMDPSimulator.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/JuliaPOMDP/BlinkPOMDPSimulator.jl/actions/workflows/ci.yml)
[![codecov.io](http://codecov.io/github/JuliaPOMDP/BlinkPOMDPSimulator.jl/coverage.svg?branch=master)](http://codecov.io/github/JuliaPOMDP/BlinkPOMDPSimulator.jl?branch=master)

A simulator for visualizing [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) problems in real time.

The display simulator from [POMDPTools](https://juliapomdp.github.io/POMDPs.jl/stable/POMDPTools/simulators/) is an alternative.

# Installation

```julia
using Pkg
Pkg.add("BlinkPOMDPSimulator")
```

# Usage

```julia
using POMDPs
using BlinkPOMDPSimulator
using POMDPModels # for SimpleGridWorld
using Compose

bs = BlinkSimulator()

mdp = SimpleGridWorld()
p = FunctionPolicy(s->:up)

simulate(bs, mdp, p)
```
