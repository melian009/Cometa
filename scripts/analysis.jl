using DrWatson
@quickactivate
using CSV
using DataFrames
using VegaLite
include(srcdir("julia", "functions.jl"))

# Outouts for each simulation regime

magicStrong = datadir("sims","MagicStrong")
magicWeak = datadir("sims","MagicWeak")
modularStrong = datadir("sims","ModularStrong")
modularWeak = datadir("sims","ModularWeak")

### 1. Shannon diversity index for each simulation output
####################################################################

shannondiv = shannonIndex(joinpath(magicStrong, "data_10.csv"))

using Makie
p = heatmap(1:10, 1:101, shannondiv')
axes = p[Axis];
axes.names.axisnames = ("Site", "Generation")

### End 1 ###
#############

### 2. Shannon index of all files within each simulation regime at generation 1000.
####################################################################

magicStrongGen101 = shannonIndexDir(magicStrong, 1001; nsites=10, nspecies=10)
magicWeakGen101 = shannonIndexDir(magicWeak, 1001; nsites=10, nspecies=10)
modularStrongGen101 = shannonIndexDir(modularStrong, 1001; nsites=10, nspecies=10)
modularWeakGen101 = shannonIndexDir(modularWeak, 1001; nsites=10, nspecies=10)

# Put all in a dataframe
dfall = DataFrame(
  hcat(
    vcat(
      vec(magicStrongGen101[:, 1:174]),
      vec(magicWeakGen101[:, 1:174]),
      vec(modularStrongGen101),
      vec(modularWeakGen101),
    ),
    repeat(1:10, 174*4),
    repeat(["magicStrongGen101","magicWeakGen101", "modularStrongGen101", "modularWeakGen101"], inner=6960/4)
  ),
  [:shannonIndex, :site, :regime]
)

## 2.2 Boxplots

p = @vlplot(
  data = dfall,
  mark = {type=:boxplot},
  y = {
    field = "shannonIndex",
    type = "quantitative",
    scale = {
      domain = [2.9, 3.33]
    },
    axis = {
      title = "Shannon index",
      titleFont=11
    }
  },
  x = {
    "regime:n",
    axis = {
      title = nothing
    }
  }
)
VegaLite.save(plotsdir("shannonIndex_regime_gen1001.pdf"), p)
### End 2 ###
#############

### 3. Species freq. of all files within each simulation regime at generation 1000.
####################################################################

magicStrongGen101 = totalSpeciesNumDir(magicStrong; generation=1001, nsites=10, nspecies=10)
magicWeakGen101 =  totalSpeciesNumDir(magicWeak; generation=1001, nsites=10, nspecies=10)
modularStrongGen101 = totalSpeciesNumDir(modularStrong; generation=1001, nsites=10, nspecies=10)
modularWeakGen101 = totalSpeciesNumDir(modularWeak; generation=1001, nsites=10, nspecies=10)

# Put all in a dataframe
dfall = DataFrame(
  hcat(
    vcat(
      vec(magicStrongGen101[1:174]),
      vec(magicWeakGen101[1:174]),
      vec(modularStrongGen101),
      vec(modularWeakGen101),
    ),
    repeat(["Magic Strong","Magic Weak", "Modular Strong", "Modular Weak"], inner=174)
  ),
  [:speciesCount, :regime]
)

## 3.2 Boxplots

p = @vlplot(
  data = dfall,
  mark = {type=:boxplot},
  y = {
    field = "speciesCount",
    type = "quantitative",
    axis = {
      title = "Total number of species"
    }
  },
  x = {
    "regime:n",
    axis = {
      title = nothing
    }
  }
)
VegaLite.save(plotsdir("global_species_count.pdf"), p)
### End 3 ###
#############