using Pkg
Pkg.activate(".")
using DataFrames
using JLD2
using GLMakie  #CairoMakie
using Statistics

f = "output.jld2"
df = load(f, "results")
dfn = combine(df, :step, :species_N => [Symbol("s$i") for i in 1:10], :ensemble)
gdf = groupby(dfn, :step)
fdf = combine(gdf, [Symbol("s$i") for i in 1:10] .=> mean)

f = Figure(resolution=(800, 500))
ax = Axis(f[1, 1],
  xlabel="Time",
  ylabel="Species frequency",
  yscale = Makie.pseudolog10
)
for sp in 1:10
  lines!(ax, fdf.step, fdf[:, sp+1], label="S$sp", strokewidth=2)
end
axislegend()
save("population_sizes.png", f)