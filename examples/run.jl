using Revise
using POMDPs
using BlinkPOMDPSimulator
using POMDPModels # requires POMDPModels with SimpleGridWorld (v0.3.3 or higher?)
using POMDPPolicies

bs = BlinkSimulator()

mdp = SimpleGridWorld()
p = FunctionPolicy(s->:up)

simulate(bs, mdp, p)
