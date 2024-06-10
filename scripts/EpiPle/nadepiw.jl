#Check README.EPISTASIS.md for code generation
#Simulation non-additive epistasis nadepi.jl
#Adding fitness to nadepi.jl == nadepiw.jl

using Random
using StatsBase
using PlotlyJS, CSV, DataFrames
using StatsPlots
using Images
using FileIO
using Plots, PyPlot, GR


# Define the number of genes and alleles
num_genes = 10
num_alleles = 2

# Create a matrix to represent the genotype of individuals
# Each row represents an individual, and each column represents a gene allele (0 or 1)
genotypes = rand(0:num_alleles, 1000, num_genes)

# Define a function to calculate the trait value based on non-additive epistasis
function non_additive_polygenic_epistasis_model(genotypes)
    num_individuals = size(genotypes, 1)
    trait_values = zeros(Float64, num_individuals)
    
    for i in 1:num_individuals
        # Initialize trait value for the individual
        trait_value = 0.0
        
        # Define epistasis coefficients (random for simplicity)
        epistasis_coeffs = rand(-5.0:0.1:5.0, num_genes, num_genes)
        
        # Calculate trait value with non-additive epistasis
        for j in 1:num_genes
            for k in (j+1):num_genes
                trait_value += epistasis_coeffs[j, k] * genotypes[i, j] * genotypes[i, k]
            end
        end
        
        trait_values[i] = trait_value
    end
    
    return trait_values
end

# Calculate trait values for the individuals
trait_values = non_additive_polygenic_epistasis_model(genotypes)

# Display the genotypes and trait values
println("Genotypes (0/1 alleles):")
println(genotypes)

println("\nTrait Values:")
println(trait_values)
pyplot()
#https://stackoverflow.com/questions/70165162/undefvarerror-histogram-not-defined-in-julia
density!(trait_values)#Hold on density plot along num genes 10 y1=blue, 50 y2=green, 100 y3=red and 1000 y4=purple
#https://docs.juliaplots.org/latest/generated/statsplots/

