save(joinpath(results_dir, "$(f[1:end-3]).jld2"), "results", mdata)
end

# Define the maximum number of concurrent jobs
const MAX_CONCURRENT_JOBS = nreplicates * max_parallel

# Create a channel with a capacity equal to the max number of concurrent jobs
token_channel = Channel{Bool}(MAX_CONCURRENT_JOBS)

# Fill the channel with tokens
for _ in 1:MAX_CONCURRENT_JOBS
  put!(token_channel, true)
end

# Create a channel to communicate task completion
completion_channel = Channel{String}(length(all_parameter_files))

# Start simulations with a limit on concurrency
for f in all_parameter_files
  Threads.@spawn begin
    # Take a token to start execution
    take!(token_channel)

    try
      run_simulation(f, paramdir, results_dir, nreplicates)
      put!(completion_channel, "done")
    finally
      # Release the token after completion or in case of an error
      put!(token_channel, true)
    end
  end
end

# Wait for all simulations to complete
for _ in 1:length(all_parameter_files)
  take!(completion_channel)
end

# Clean up: Close the channels
close(token_channel)
close(completion_channel)

