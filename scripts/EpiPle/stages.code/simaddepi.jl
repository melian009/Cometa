# Define a function to simulate an additive polygenic epistasis model
function additive_polygenic_epistasis_model(genes)
    # Calculate the trait value as the sum of gene contributions
    trait = sum(genes)
    
    return trait
end

# Test the model with different combinations of gene alleles
genes = [0, 0, 0]
trait_value = additive_polygenic_epistasis_model(genes)
println("Trait value for genes=$genes: $trait_value")

genes = [1, 0, 0]
trait_value = additive_polygenic_epistasis_model(genes)
println("Trait value for genes=$genes: $trait_value")

genes = [0, 1, 1]
trait_value = additive_polygenic_epistasis_model(genes)
println("Trait value for genes=$genes: $trait_value")

genes = [1, 1, 1]
trait_value = additive_polygenic_epistasis_model(genes)
println("Trait value for genes=$genes: $trait_value")

