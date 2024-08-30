#!/bin/bash

paramdir="./parameter_files_modular"
results_dir="./sim_outputs_modular"
nreplicates=2

# Create param files
julia mainmod.jl

# Find all parameter files in the paramdir
files=($(find $paramdir -type f -name "*.jl"))

# Run simulations in batches of 10
for ((i=0; i<${#files[@]}; i+=10)); do
    for ((j=i; j<i+10 && j<${#files[@]}; j++)); do
        f=${files[$j]}
        filename=$(basename "$f")
        output_file="${results_dir}/${filename%.jl}.jld2"
        
        if [ ! -f "$output_file" ]; then
            julia run_sims_bash_mod.jl "$filename" "$paramdir" "$results_dir" "$nreplicates" &
        else
            echo "Output file $output_file already exists. Skipping simulation for $filename."
        fi
    done
    wait # Wait for all background processes to finish before continuing
done
