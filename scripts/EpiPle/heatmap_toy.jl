using GLMakie
using LinearAlgebra

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
# Add a heatmap 
hm = heatmap!(ax, data, colormap=:grays)

# Add a colorbar
Colorbar(fig[1, 2], hm, label = "Distance")

# Save
save("heatmap.png", fig; px_per_unit=150)