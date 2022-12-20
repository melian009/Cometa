* We want to explore a range of simulations, each one having a different `migration_threshold` and biotic selection coefficient (`biotic_variance`).
* 10 Replicates per combination.
* There is no mutation or evolving trait architecture.
* There are two set of simulations: one is **modular** and the other is **correlated**. 
* This is a fully modular pleiotropy matrix:

 1  1  1  1  1  1  1  1  1  1  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  1  1  1  1  1  1  1  1  1  1  0
 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  1  # this is migration

* This is a fully correlated pleiotropy matrix:

 1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
 1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
 1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1

## Food resources matrix

* We keep a fixed food_resources matrix and run the simulations. In another set, we randomize the `food_resources` matrix. To randomize, we can keep the number of non-zeros and predator, preys, but random combination. The `interactions` matrix will always follow the `food_resources` matrix, having a 1 where ever there is a non-zero value in the `food_resources`.