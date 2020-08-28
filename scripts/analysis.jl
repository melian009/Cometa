using DrWatson
@quickactivate
using CSV
using DataFrames
using Makie
include(srcdir("julia", "functions.jl"))

magicStrong = datadir("sims","MagicStrong")
magicWeak = datadir("sims","MagicWeak")
modularStrong = datadir("sims","ModularStrong")
modularWeak = datadir("sims","ModularWeak")

## Shannon diversity index
shannondiv = shannonIndex(joinpath(magicStrong, "data_10.csv"))
p = heatmap(1:10, 1:101, shannondiv')
axes = p[Axis];
axes.names.axisnames = ("Site", "Generation")