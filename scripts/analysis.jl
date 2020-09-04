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

### 2. Shannon index of all files within each simulation regime at generation 100.
####################################################################

magicStrongGen101 = shannonIndexDir(magicStrong, 101; nsites=10, nspecies=10)
magicWeakGen101 = shannonIndexDir(magicWeak, 101; nsites=10, nspecies=10)
modularStrongGen101 = shannonIndexDir(modularStrong, 101; nsites=10, nspecies=10)
modularWeakGen101 = shannonIndexDir(modularWeak, 101; nsites=10, nspecies=10)

# Put all in a dataframe
dfall = DataFrame(
  hcat(
    vcat(
      vec(magicStrongGen101),
      vec(magicWeakGen101),
      vec(modularStrongGen101),
      vec(modularWeakGen101),
    ),
    repeat(1:10, 400),
    repeat(["magicStrongGen101","magicWeakGen101", "modularStrongGen101", "modularWeakGen101"], inner=1000)
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
      domain = [3.29, 3.33]
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
VegaLite.save(plotsdir("shannonIndex_regime_gen101.pdf"), p)
### End 2 ###
#############

### 3. Species freq. of all files within each simulation regime at generation 100.
####################################################################

magicStrongGen101 = totalSpeciesNumDir(magicStrong; generation=101, nsites=10, nspecies=10)
magicWeakGen101 =  totalSpeciesNumDir(magicWeak; generation=101, nsites=10, nspecies=10)
modularStrongGen101 = totalSpeciesNumDir(modularStrong; generation=101, nsites=10, nspecies=10)
modularWeakGen101 = totalSpeciesNumDir(modularWeak; generation=101, nsites=10, nspecies=10)

# Put all in a dataframe
dfall = DataFrame(
  hcat(
    vcat(
      vec(magicStrongGen101),
      vec(magicWeakGen101),
      vec(modularStrongGen101),
      vec(modularWeakGen101),
    ),
    repeat(["Magic Strong","Magic Weak", "Modular Strong", "Modular Weak"], inner=100)
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