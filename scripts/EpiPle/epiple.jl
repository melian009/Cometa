# using BioJulia (How to install it in Julia?)
# https://biojulia.dev/getting-started/

# Trait hierarchy heatmap 
# Modulating variance of biotic and abiotic optimal value
#---------------------------------------------------------

using Random
using StatsBase
using PlotlyJS, CSV, DataFrames
using StatsPlots
using Images
using FileIO
using Plots, PyPlot, GR


# Define a function for a nonlinear pleiotropic gene -------
function nonlinear_pleiotropy(gene_value)
    trait1 = gene_value^2
    trait2 = sqrt(abs(gene_value))
    return (trait1, trait2)
end

# Simulate a population of individuals with random gene values
num_individuals = 100
gene_values = rand(-10:10, num_individuals)

# Calculate traits for each individual
traits = [nonlinear_pleiotropy(gene) for gene in gene_values]

# Study the distribution of traits
using Plots
density([t[1] for t in traits], label="Trait 1", alpha=0.5)
density!([t[2] for t in traits], label="Trait 2", alpha=0.5)
#-----------------------------------------------------------


# Define two genes with epistatic interaction --------------
function gene1(x)
    return x^2
end

function gene2(y)
    return sqrt(abs(y))
end

# Simulate a population of individuals with random gene values
num_individuals = 100
gene1_values = rand(-10:10, num_individuals)
gene2_values = rand(-10:10, num_individuals)

# Calculate the combined trait influenced by both genes
traits = [gene1(g1) + gene2(g2) for (g1, g2) in zip(gene1_values, gene2_values)]

# Study the distribution of the combined trait
density!(traits, label="Combined Trait", alpha=0.5)
#----------------------------------------------------------


# Combine pleiotropy and epistasis for gene-trait gradients (Eq. 3 Cometa)


# Fitness function abiotic including mean and variance of the optimal value (Eq. 4)


# Fitness function biotic including mean and variance of the optimal value (Eqs. 5 and 6)


# Fitness partition biotic-abiotic (Eq. 7)


# Print heatmap along variance gradient






 




