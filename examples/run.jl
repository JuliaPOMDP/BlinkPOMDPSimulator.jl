using Revise
using POMDPs
using BlinkPOMDPSimulator
using POMDPModels
using POMDPPolicies

bs = BlinkSimulator()

mdp = LegacyGridWorld()
p = FunctionPolicy(s->:up)

simulate(bs, mdp, p)
