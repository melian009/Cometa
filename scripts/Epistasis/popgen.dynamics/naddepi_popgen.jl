using Random

# Define the number of generations and population size
num_generations = 100
population_size = 1000

# Define parameters for the two genetic loci
locus1_effects = [0.0, 1.0, 2.0]  # Effect sizes for alleles at locus 1
locus2_effects = [0.0, 0.5, -0.5]  # Effect sizes for alleles at locus 2

# Initialize the population with random genotypes
population = rand(1:3, population_size, 2)

# Define a function to calculate individual fitness
function calculate_fitness(genotype)
    locus1_effect = locus1_effects[genotype[1]]
    locus2_effect = locus2_effects[genotype[2]]
    
    # Nonlinear epistasis: Fitness depends on the interaction between loci
    fitness = 1.0 + locus1_effect + locus2_effect + locus1_effect * locus2_effect
    
    return fitness
end

# Simulation loop
for generation in 1:num_generations
    # Calculate fitness for each individual
    fitness_values = [calculate_fitness(population[i, :]) for i in 1:population_size]
    
    # Normalize fitness values
    normalized_fitness = fitness_values / sum(fitness_values)
    
    # Select parents for the next generation based on fitness
    parents = sample(1:population_size, population_size, weights=normalized_fitness, replace=true)
    
    # Create the next generation by copying parental genotypes
    new_population = population[parents, :]
    
    # Introduce some mutation (randomly change alleles)
    for i in 1:population_size
        if rand() < 0.01
            new_population[i, 1] = rand(1:3)
        end
        if rand() < 0.01
            new_population[i, 2] = rand(1:3)
        end
    end
    
    # Replace the old population with the new generation
    global population = copy(new_population)
end

# Analyze the final population or perform further simulations/statistics

