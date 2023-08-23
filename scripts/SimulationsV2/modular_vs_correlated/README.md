* Data Vogager data exploration 

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

## Blake feedback
* Trait architecture modular vs correlated
* Biotic niche specialization: All consumers one resource 
* No trait variation: all individuals same pleiotropy, epistasis and regulation 

## Changes to be made to run modular vs correlated when running a larger number of species
         ### Current code:
         :resources => [[984 1064 964 1084 1022 998 945 951 1069 1002;
                  1034 919 940 1006 964 959 967 986 974 913;
                  1076 1087 925 1017 916 989 1070 1093 945 1026;
                  1029 1085 917 964 1059 933 924 999 1057 1078;
                  1058 1034 1094 1071 959 902 1090 1001 928 1005] for i in 1:(generations+1)],

         :interactions => [0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
                    1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
                    0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0;
                    0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
                    0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0;
                    0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0;
                    0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 1.0 0.0;
                    0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0;
                    0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0;
                    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0],

          :food_sources => [0.0 3.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
                    0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
                    0.0 0.0 0.0 3.0 0.0 0.0 0.0 0.0 0.0 0.0;
                    0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0;
                    0.0 0.0 0.0 0.0 0.0 3.0 0.0 0.0 0.0 0.0;
                    0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0;
                    0.0 0.0 0.0 0.0 0.0 0.0 0.0 2.0 2.0 0.0;
                    0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0;
                    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0;
                    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0],
          :seed => nothing

          food_sources: determines which species is a prey and which is predator. For example, Predators have a value of 3, while preys have a value of 1: species 1 (=row 1) is a predator of species 2
          interactions: is a symmetric matrix that has a 1 wherever there is a 3 in food_sources
          resources: can be left as it is
          
          food_sources 20rows x 10columns with 20 preys and 10 predators?
          interactions 20rows x 10columns with 20 preys and 10 predators?
          resources 20rows x 10columns assuming the number of preys is 20 and the number of sites is 10? 





