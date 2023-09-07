# Define a function to simulate a simple epistasis model
function simple_epistasis_model(gene1, gene2)
    # Assume each gene has two alleles, represented as 0 and 1
    # Calculate the trait value based on the interaction between the genes
    trait = gene1 * gene2
    
    return trait
end

# Test the model with different combinations of gene1 and gene2
gene1 = 0
gene2 = 0
trait_value = simple_epistasis_model(gene1, gene2)
println("Trait value for gene1=$gene1 and gene2=$gene2: $trait_value")

gene1 = 1
gene2 = 0
trait_value = simple_epistasis_model(gene1, gene2)
println("Trait value for gene1=$gene1 and gene2=$gene2: $trait_value")

gene1 = 0
gene2 = 1
trait_value = simple_epistasis_model(gene1, gene2)
println("Trait value for gene1=$gene1 and gene2=$gene2: $trait_value")

gene1 = 1
gene2 = 1
trait_value = simple_epistasis_model(gene1, gene2)
println("Trait value for gene1=$gene1 and gene2=$gene2: $trait_value")

