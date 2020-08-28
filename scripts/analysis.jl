using DrWatson
@quickactivate
using CSV
using DataFrames
include(srcdir("julia", "functions.jl"))

magicStrong = datadir("sims","MagicStrong")
magicWeak = datadir("sims","MagicWeak")
modularStrong = datadir("sims","ModularStrong")
modularWeak = datadir("sims","ModularWeak")
