#ChatGPT question
#julia code for the Fisher’s Geometric model



using Random

# Initial allele frequencies
p = 0.5  # Initial frequency of allele A
q = 1.0 - p  # Initial frequency of allele B

# Selection coefficient (how advantageous allele A is compared to allele B)
s = 0.01

# Number of generations and population size
num_generations = 100
population_size = 1000

# Arrays to store allele frequencies over time
allele_A_freq = Float64[]
allele_B_freq = Float64[]

# Simulation loop
for generation in 1:num_generations
    # Calculate the fitness of each genotype
    w_AA = 1.0  # Fitness of genotype AA
    w_Aa = 1.0 - s  # Fitness of genotype Aa
    w_aa = 1.0 - 2s  # Fitness of genotype aa
    
    # Calculate the genotype frequencies after selection
    p_new = (p^2 * w_AA + 2p*q * w_Aa) / (p^2 * w_AA + 2p*q * w_Aa + q^2 * w_aa)
    q_new = 1.0 - p_new
    
    # Store allele frequencies for this generation
    push!(allele_A_freq, p_new)
    push!(allele_B_freq, q_new)
    
    # Update allele frequencies for the next generation
    p = p_new
    q = q_new
end

# Plot the results
using Plots
plot(allele_A_freq, label="Allele A Frequency", xlabel="Generations", ylabel="Frequency", legend=:topright)
plot!(allele_B_freq, label="Allele B Frequency")


using Random

# Initial allele frequencies
p = 0.5  # Initial frequency of allele A
q = 1.0 - p  # Initial frequency of allele B

# Selection coefficient (how advantageous allele A is compared to allele B)
s = 0.01

# Number of generations and population size
num_generations = 100
population_size = 1000

# Arrays to store allele frequencies over time
allele_A_freq = Float64[]
allele_B_freq = Float64[]

# Simulation loop
for generation in 1:num_generations
    # Calculate the fitness of each genotype
    w_AA = 1.0  # Fitness of genotype AA
    w_Aa = 1.0 - s  # Fitness of genotype Aa
    w_aa = 1.0 - 2s  # Fitness of genotype aa
    
    # Calculate the genotype frequencies after selection
    p_new = (p^2 * w_AA + 2p*q * w_Aa) / (p^2 * w_AA + 2p*q * w_Aa + q^2 * w_aa)
    q_new = 1.0 - p_new
    
    # Store allele frequencies for this generation
    push!(allele_A_freq, p_new)
    push!(allele_B_freq, q_new)
    
    # Update allele frequencies for the next generation
    p = p_new
    q = q_new
end

# Plot the results
using Plots
plot(allele_A_freq, label="Allele A Frequency", xlabel="Generations", ylabel="Frequency", legend=:topright)
plot!(allele_B_freq, label="Allele B Frequency")


using Random

# Initial allele frequencies
p = 0.5  # Initial frequency of allele A
q = 1.0 - p  # Initial frequency of allele B

# Selection coefficient (how advantageous allele A is compared to allele B)
s = 0.01

# Number of generations and population size
num_generations = 100
population_size = 1000

# Arrays to store allele frequencies over time
allele_A_freq = Float64[]
allele_B_freq = Float64[]

# Simulation loop
for generation in 1:num_generations
    # Calculate the fitness of each genotype
    w_AA = 1.0  # Fitness of genotype AA
    w_Aa = 1.0 - s  # Fitness of genotype Aa
    w_aa = 1.0 - 2s  # Fitness of genotype aa
    
    # Calculate the genotype frequencies after selection
    p_new = (p^2 * w_AA + 2p*q * w_Aa) / (p^2 * w_AA + 2p*q * w_Aa + q^2 * w_aa)
    q_new = 1.0 - p_new
    
    # Store allele frequencies for this generation
    push!(allele_A_freq, p_new)
    push!(allele_B_freq, q_new)
    
    # Update allele frequencies for the next generation
    p = p_new
    q = q_new
end

# Plot the results
using Plots
plot(allele_A_freq, label="Allele A Frequency", xlabel="Generations", ylabel="Frequency", legend=:topright)
plot!(allele_B_freq, label="Allele B Frequency")

