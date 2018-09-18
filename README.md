# Blink POMDP Simulator

[![Build Status](https://travis-ci.org/JuliaPOMDP/BlinkPOMDPSimulator.jl.svg?branch=master)](https://travis-ci.org/JuliaPOMDP/BlinkPOMDPSimulator.jl)

A simulator for visualizing problems in real time.

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

bs = BlinkSimulator()

mdp = LegacyGridWorld()
p = FunctionPolicy(s->:up)

simulate(bs, mdp, p)
```
