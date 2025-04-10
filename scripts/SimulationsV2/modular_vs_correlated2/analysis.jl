using Pkg; Pkg.activate(".")
using FileIO
using ImageIO
using ImageMagick
using OpenCV
using DataFrames
using Statistics
using StatsBase
using JLD2
using VegaLite
using MultivariateStats
using DecisionTree

correlated_sim_outputs_dir = "sim_outputs_correlated/"
modular_sim_outputs_dir = "sim_outputs_modular/"

# load the simulation outputs
# 1. load all the files in the correlated_sim_outputs_dir
correlated_sim_outputs = Dict()
for file in readdir(correlated_sim_outputs_dir)
  if endswith(file, ".jld2")
    sim_name = splitext(file)[1]
    correlated_sim_outputs[sim_name] = load(joinpath(correlated_sim_outputs_dir, file), "results")
  end
end

# 2. load all the files in the modular_sim_outputs_dir
modular_sim_outputs = Dict()
for file in readdir(modular_sim_outputs_dir)
  if endswith(file, ".jld2")
    sim_name = splitext(file)[1]
    modular_sim_outputs[sim_name] = load(joinpath(modular_sim_outputs_dir, file), "results")
  end
end

# extract "biotic_coeff", "migration_rate"and "fixed_interaction_mat" values from the simulation names (keys in the dictionaries). Here is how the keys look like: "params_migration_rate=5.0_biotic_coeff=2.0_fixed_interaction_mat_4".

function extract_values(sim_name::String)
  # Define the regular expression pattern
  pattern = r"params_migration_rate=(\d+\.?\d*)_biotic_coeff=(\d+\.?\d*)_fixed_interaction_mat_(\d+)_abiotic_coeff=(\d+\.?\d*)_selection_coeff=(\d+\.?\d*)"

  # Match the pattern against the simulation name
  matched = Base.match(pattern, sim_name)

  # Extract the values from the match
  if matched !== nothing
    migration_rate = parse(Float64, matched.captures[1])
    biotic_coeff = parse(Float64, matched.captures[2])
    fixed_interaction_mat = parse(Int, matched.captures[3])
    abiotic_coeff = parse(Float64, matched.captures[4])
    selection_coeff = parse(Float64, matched.captures[5])
    return migration_rate, biotic_coeff, fixed_interaction_mat, abiotic_coeff, selection_coeff
  else
    error("The simulation name does not match the expected pattern.")
  end
end

# extract the values from the simulation names
correlated_sim_values = Dict()
for (sim_name, sim_output) in correlated_sim_outputs
  migration_rate, biotic_coeff, fixed_interaction_mat, abiotic_coeff, selection_coeff = extract_values(sim_name)
  correlated_sim_values[(migration_rate, biotic_coeff, fixed_interaction_mat, abiotic_coeff, selection_coeff)] = sim_output
end

modular_sim_values = Dict()
for (sim_name, sim_output) in modular_sim_outputs
  migration_rate, biotic_coeff, fixed_interaction_mat, abiotic_coeff, selection_coeff = extract_values(sim_name)
  modular_sim_values[(migration_rate, biotic_coeff, fixed_interaction_mat, abiotic_coeff, selection_coeff)] = sim_output
end

function calculate_shannon_diversity_index(df::DataFrame; species_col::Symbol=:species_N)
  grouped = groupby(df, :ensemble)
  g1 = first(grouped)
  nrows, ncols = size(g1)
  nspecies = length(g1[1, species_col])
  shannon_div_all = zeros(nrows, length(grouped))
  for (replicate, gg) in enumerate(grouped)
    shannon_div = zeros(nrows)
    for generation in 1:nrows
      m = Array(gg[generation, species_col])
      totalsum = sum(m)
      species_freq = m ./ totalsum
      # Calculate Shannon index only for non-zero frequencies
      shannon = -sum(species_freq[species_freq.>0] .* log2.(species_freq[species_freq.>0]))

      shannon_div[generation] = shannon
    end
    shannon_div_all[:, replicate] = shannon_div
  end
  return vec(mean(shannon_div_all, dims=2))
end

div_per_sim = Dict()
for (params, df) in correlated_sim_values
  div_per_sim[params] = calculate_shannon_diversity_index(df)
end

div_per_sim_modular = Dict()
for (params, df) in modular_sim_values
  div_per_sim_modular[params] = calculate_shannon_diversity_index(df)
end


# sims sorted by one of the parameters

migration_rate, biotic_coeff, fixed_interaction_mat, abiotic_coeff, selection_coeff = 1:5

sorted_sims = sortperm(collect(keys(div_per_sim)), by=x->x[migration_rate])  # change the parameter to sort by as desired
sorted_keys = collect(keys(div_per_sim))[sorted_sims]

sorted_sims_modular = sortperm(collect(keys(div_per_sim_modular)), by=x -> x[migration_rate])
sorted_keys_modular = collect(keys(div_per_sim_modular))[sorted_sims_modular]

## Plot correlated
df1 = DataFrame()
df1.migration_rate = [k[migration_rate] for k in sorted_keys]
df1.biotic_coeff = [k[biotic_coeff] for k in sorted_keys]
df1.fixed_interaction_mat = [k[fixed_interaction_mat] for k in sorted_keys]
df1.abiotic_coeff = [k[abiotic_coeff] for k in sorted_keys]
df1.selection_coeff = [k[selection_coeff] for k in sorted_keys]
df1.diversity_index = [mean(div_per_sim[k]) for k in sorted_keys]

groups = groupby(df1, [:migration_rate, :selection_coeff])

# plot: heatmap where x axis is biotic coeff, y axis is abiotic coeff, color is diversity index
for group in groups
  p = group |> @vlplot(
  :rect,
  x = {:biotic_coeff, type = :quantitative, title = "Biotic coefficient"},
  y = {:abiotic_coeff, type = :quantitative, title = "Abiotic coefficient"},
  color={:diversity_index, scale={scheme="viridis"}},
  width=500,
  height=500
  )

  VegaLite.save(joinpath("plots", "correlated_heatmap_biotic_abiotic_diversity_$(group[1,:migration_rate])_$(group[1,:selection_coeff]).png"), p)
end

## Plot modular
df2 = DataFrame()
df2.migration_rate = [k[migration_rate] for k in sorted_keys_modular]
df2.biotic_coeff = [k[biotic_coeff] for k in sorted_keys_modular]
df2.fixed_interaction_mat = [k[fixed_interaction_mat] for k in sorted_keys_modular]
df2.abiotic_coeff = [k[abiotic_coeff] for k in sorted_keys_modular]
df2.selection_coeff = [k[selection_coeff] for k in sorted_keys_modular]
df2.diversity_index = [mean(div_per_sim_modular[k]) for k in sorted_keys_modular]

groups = groupby(df2, [:migration_rate, :selection_coeff])

# plot: heatmap where x axis is biotic coeff, y axis is abiotic coeff, color is diversity index
for group in groups
  p = group |> @vlplot(
  :rect,
  x = {:biotic_coeff, type = :quantitative, title = "Biotic coefficient"},
  y = {:abiotic_coeff, type = :quantitative, title = "Abiotic coefficient"},
  color={:diversity_index, scale={scheme="viridis"}},
  width=500,
  height=500
  )

  VegaLite.save(joinpath("plots", "modular_heatmap_biotic_abiotic_diversity_$(group[1,:migration_rate])_$(group[1,:selection_coeff]).png"), p)
end

######################################################
## plots div difference between modular and correlated
######################################################

correlated_div = Float64[] # df1
modular_div = Float64[] # df2
params = NamedTuple[]
for row in eachrow(df1)
  df2_equivalent = df2[(df2.migration_rate.==row.migration_rate).&&(df2.selection_coeff.==row.selection_coeff).&&(df2.biotic_coeff.==row.biotic_coeff).&&(df2.abiotic_coeff.==row.abiotic_coeff).&&(df2.fixed_interaction_mat.==row.fixed_interaction_mat), :]
  if size(df2_equivalent, 1) > 0
    push!(correlated_div, row.diversity_index)
    push!(modular_div, df2_equivalent.diversity_index[1])
    push!(params, (migration_rate=row.migration_rate, biotic_coeff=row.biotic_coeff, abiotic_coeff=row.abiotic_coeff, fixed_interaction_mat=row.fixed_interaction_mat, selection_coeff=row.selection_coeff))
  end
end
div_diff = correlated_div .- modular_div
df_div = DataFrame(params)
df_div.correlated_div = correlated_div
df_div.modular_div=modular_div
df_div.div_diff=div_diff

# plot 1: PC1 and PC2 of migration_rate  biotic_coeff  abiotic_coeff  fixed_interaction_mat  selection_coeff and the color is the diversity difference

# Prepare data for PCA
X = Matrix(df_div[:, [:migration_rate, :biotic_coeff, :abiotic_coeff, :fixed_interaction_mat, :selection_coeff]])
# Standardize the data
X_standardized = (X .- mean(X, dims=1)) ./ std(X, dims=1)

# Perform PCA
M = fit(PCA, X_standardized', maxoutdim=2)
transformed_data = predict(M, X_standardized')'

# Create DataFrame for plotting
pca_df = DataFrame(
    PC1 = transformed_data[:, 1],
    PC2 = transformed_data[:, 2],
    div_diff = df_div.div_diff
)

# Create PCA plot
p = pca_df |> @vlplot(
    mark={:point, filled=true},
    title= "Diversity Difference (Correlated - Modular)",
    x={:PC1, title="PC1"},
    y={:PC2, title="PC2"},
    color={
        :div_diff,
        title="Diversity Difference",
        scale={
            scheme="redblue",
            domain=[-maximum(abs.(pca_df.div_diff)), maximum(abs.(pca_df.div_diff))],
            domainMid=0
        }
    },
    size={value=100},
    width=500,
    height=500
)

VegaLite.save(joinpath("plots", "pca_diversity_difference.png"), p)

# plot 2: div_diff as points on a horizontal line. There is no y axis. The top three most negative and most positive div_diff values are labeled with the parameter values.

# Sort by diversity difference
sorted_indices = sortperm(df_div.div_diff)
top_negative = sorted_indices[1:3]
top_positive = sorted_indices[end-2:end]

# Create DataFrame for plotting
plot_df = DataFrame(
    div_diff = df_div.div_diff,
    highlight = [i in [top_negative; top_positive] for i in 1:length(df_div.div_diff)],
    label = ["" for _ in 1:length(df_div.div_diff)]
)

# Add labels for highlighted points
for i in [top_negative; top_positive]
    plot_df.label[i] = "m=$(df_div.migration_rate[i]), b=$(df_div.biotic_coeff[i]), a=$(df_div.abiotic_coeff[i]), s=$(df_div.selection_coeff[i])"
end

# Create horizontal line plot
p = plot_df |> @vlplot(
    width=800,
    height=200,
    layer=[
        {
            mark={:point},
            x={:div_diff, title="Diversity Difference (Correlated - Modular)"},
            y={value=0},
            color={
                condition={
                    test="datum.highlight == true",
                    value="red"
                },
                value="gray"
            },
            size={
                condition={
                    test="datum.highlight == true",
                    value=100
                },
                value=50
            }
        },
        {
            mark={:text, angle=270, align="right", dx=-5}, # Changed: align="right" and dx=-5 instead of dy
            x=:div_diff,
            y={value=0},
            text=:label,
            color={value="black"},
            selection={
                grid={type=:single, on="mouseover"}
            }
        }
    ]
)

VegaLite.save(joinpath("plots", "diversity_difference_horizontal.png"), p)

##########################################################
## END plots div difference between modular and correlated
##########################################################

## 3d plot


## correlated
# Define a weighted ratio function that considers magnitude
function weighted_ratio(a, b)
  if a == 0 && b == 0
    return missing
  end

  # Calculate the magnitude weight
  magnitude = log10(abs(a) + abs(b) + 1)

  # Calculate the basic ratio
  ratio = a / b

  # Calculate deviation from 1 (perfect equality)
  deviation = abs(ratio - 1)

  # Combine ratio and magnitude in a way that preserves ratio differences
  weighted = sign(ratio - 1) * deviation * magnitude

  return isfinite(weighted) ? weighted : missing
end

df1.biotic_abiotic_ratio = weighted_ratio.(df1.biotic_coeff, df1.abiotic_coeff)

# replace NaN and Inf with missing
# df1.biotic_abiotic_ratio = [isinf(x) || isnan(x) ? missing : x for x in df1.biotic_abiotic_ratio]

# Now create the plot
p = df1 |>
@vlplot(
width = 600, height = 400,
mark = :point,
x = {:biotic_abiotic_ratio, title = "Weighted Biotic /  Abiotic Coefficient"},
y = {:diversity_index, title = "Diversity Index"},
color = {:selection_coeff, title = "Selection Coefficient"},
shape = {:migration_rate, title = "Migration Rate"},
size = {:selection_coeff, scale = {range = [20, 200]}}
)

save("plots/correlated_3d_plot.png", p)

## Modular
df2.biotic_abiotic_ratio = weighted_ratio.(df2.biotic_coeff, df2.abiotic_coeff)

# replace NaN and Inf with missing
# df2.biotic_abiotic_ratio = [isinf(x) || isnan(x) ? missing : x for x in df2.biotic_abiotic_ratio]

# Now create the plot
p = df2 |>
@vlplot(
width = 600, height = 400,
mark = :point,
x = {:biotic_abiotic_ratio, title = "Weighted Biotic /  Abiotic Coefficient"},
y = {:diversity_index, title = "Diversity Index"},
color = {:selection_coeff, title = "Selection Coefficient"},
shape = {:migration_rate, title = "Migration Rate"},
size = {:selection_coeff, scale = {range = [20, 200]}}
)

VegaLite.save("plots/modular_3d_plot.png", p)


### decision trees
features = [:biotic_coeff, :abiotic_coeff, :migration_rate, :selection_coeff]

X = Matrix(df_div[:, features])
y = df_div.div_diff

model = DecisionTreeRegressor(max_depth=4)
DecisionTree.fit!(model, X, y)
print_tree(model, 5)

# save to print tree to a file
open("plots/decision_tree.txt", "w") do io
  print_tree(io, model)
end
# replace feature1, feature2, etc with the actual feature names manually.

## Write all dataframes to CSV files
CSV.write("plots/correlated_diversity.csv", df1)
CSV.write("plots/modular_diversity.csv", df2)
CSV.write("plots/diversity_difference.csv", df_div)
