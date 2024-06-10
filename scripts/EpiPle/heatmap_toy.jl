using Pkg
Pkg.activate(".")
using GLMakie

nrows = 30
data = zeros(nrows, nrows)

maxvalue = 1.0
added_value = maxvalue / nrows
best_cols = collect(1:nrows)
for row in 1:nrows
  for col in 1:nrows
    data[row, col] = maxvalue - (abs(col - best_cols[row]) * added_value)
  end
end

data .= abs.(data .- 1.0)

# Create a new Figure 
fig = Figure()
ax = Axis(fig[1, 1],
  # title="A Makie Axis",
  xlabel="Abiotic variance",
  ylabel="Biotic variance"
)

# Change the ticks to be in a smaller range
ticks = collect(1:5:nrows)
ticklabels = string.(ticks ./ 5)
ax.xticks = (ticks, ticklabels)
ax.yticks = (ticks, ticklabels)


# Add a heatmap 
hm = heatmap!(ax, data, colormap=:grays)

# Add a colorbar
Colorbar(fig[1, 2], hm, label = "Hierarchy")

# Save
save("heatmap.png", fig; px_per_unit=300)