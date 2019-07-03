using POMDPModels
using BlinkPOMDPSimulator
using POMDPs

TestWindow = BlinkPOMDPSimulator.TestWindow

m = BabyPOMDP()
bs = BlinkSimulator(window=TestWindow(),
                    extra_initial=true,
                    extra_final=true,
                    max_steps=10,
                    max_fps=100
                   )
simulate(bs, m)

m = LegacyGridWorld()
bs = BlinkSimulator(window=TestWindow(),
                    extra_initial=true,
                    extra_final=true,
                    max_steps=10,
                    max_fps=100
                   )
simulate(bs, m)

m = SimpleGridWorld()
bs = BlinkSimulator(window=TestWindow(),
                    extra_initial=true,
                    extra_final=true,
                    max_steps=10,
                    max_fps=100
                   )
simulate(bs, m)
