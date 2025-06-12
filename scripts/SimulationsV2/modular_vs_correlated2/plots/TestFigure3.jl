#Figure 3A

using StatsPlots
using HypothesisTests

# Plot histogram with KDE
@df DataFrame(x = div_diff) begin
    histogram(:x, normalize=true, bins=20, label="Histogram", alpha=0.5)
    density!(:x, label="KDE", linewidth=2)
    xlabel!("Value")
    ylabel!("Density")
    title!("Distribution with KDE")
end

# Create DataFrame
df = DataFrame(x = div_diff)

# Plot histogram and KDE
@df df begin
    histogram(:x, normalize = true, bins = 20, label = "Histogram", alpha = 0.5)
    density!(:x, label = "KDE", linewidth = 2)
    xlabel!("Value")
    ylabel!("Density")
    title!("Distribution with KDE")
end


# Shapiro-Wilk test for normality
sw = ShapiroWilkTest(div_diff)
println("Shapiro-Wilk Test:")
println(sw)

julia> sw = ShapiroWilkTest(div_diff)
Shapiro-Wilk normality test
---------------------------
Population details:
    parameter of interest:   Squared correlation of data and expected order statistics of N(0,1) (W)
    value under h_0:         1.0
    point estimate:          0.905093

Test summary:
    outcome with 95% confidence: reject h_0
    one-sided p-value:           <1e-24

Details:
    number of observations: 1044
    censored ratio:         0.0
    W-statistic:            0.905093
    
    
    This output is from the `ShapiroWilkTest` in Julia, which tests whether your data (`div_diff`) follows a **normal distribution**.

Here’s how to interpret each part:

---

### 🧪 **Test Purpose**

The **Shapiro-Wilk test** checks the null hypothesis:

> **H₀ (null hypothesis)**: The data is drawn from a normal distribution
> **H₁ (alternative)**: The data is *not* from a normal distribution

---

### 📊 **Results Breakdown**

| Component                        | Meaning                                                                                                           |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| **W-statistic (0.905)**          | A value closer to 1 indicates stronger agreement with normality. Values < 0.95 often suggest deviation.           |
| **p-value (< 1e-24)**            | Extremely small. This means the probability of getting such a sample *if* the data were normal is virtually zero. |
| **Test conclusion**              | `reject h₀`: There's strong evidence your data is **not normally distributed**.                                   |
| **Number of observations: 1044** | The test is based on a large sample, so it's statistically powerful.                                              |

---

### ✅ **Final Interpretation**

Your data **fails the normality test** — it shows significant deviations from a normal distribution. The `W = 0.905` is relatively low, and the p-value `< 1e-24` is far below any standard threshold (e.g. 0.05 or 0.01), so:

> ✅ **Conclusion**: Your data is **not normally distributed** (with very high confidence).



Skewness
# Compute sample skewness
g1 = skewness(data)

# Standard error under null hypothesis (normality)
se = sqrt(6 / n)

# Z-score
z = g1 / se

# Two-sided p-value
p_value = 2 * (1 - cdf(Normal(), abs(z)))

println("Skewness (g₁): ", g1)
println("Z-score: ", z)
println("p-value: ", p_value)

# Interpretation
if p_value < 0.05
    println("Result: Reject H₀ — Skewness is significantly different from 0 (asymmetry present)")
else
    println("Result: Fail to reject H₀ — No significant skewness detected")
end


julia> g1 = skewness(div_diff)
0.5507457204361734

julia> n = length(data)
1000

julia> length(div_diff)
1044

julia> n = length(div_diff)
1044

julia> se = sqrt(6 / n)
0.07580980435789034

julia> z = g1 / se
7.264835005194832

julia> p_value = 2 * (1 - cdf(Normal(), abs(z)))
3.7347902548390266e-13

julia> println("Skewness (g₁): ", g1)
Skewness (g₁): 0.5507457204361734

julia> println("Z-score: ", z)
Z-score: 7.264835005194832

julia> println("p-value: ", p_value)
p-value: 3.7347902548390266e-13


Figure 3B-E
using DataFrames, Statistics

# Compute Pearson correlation
corr_value = cor(df.migration_rate, df.div_diff)

println("Correlation between migration_rate and div_diff: ", corr_value)


Migration-Div diff
Based on the Shapiro-Wilk test for normality, the div_diff distribution for each migration_rate value deviates significantly from normality.

Here are the detailed results:
migration_rate	Shapiro Statistic	p-value	Deviates from Normality (at α=0.05)
0.0	0.9235	1.39e-08	True
0.1	0.8432	2.67e-14	True
1.0	0.8883	2.61e-11	True
2.0	0.9273	1.71e-08	True
5.0	0.9448	3.00e-07	True

Based on our previous analysis of the `output.csv` file, here are the Shapiro-Wilk normality test results for the `div_diff` distribution, grouped by each `migration_rate` value:

| migration_rate | Shapiro Statistic | p-value | Deviates from Normality (at $\alpha = 0.05$) |
|:---------------|:------------------|:--------|:----------------------------------------------|
| 0.0            | 0.9235            | 1.39e-08| True                                          |
| 0.1            | 0.8432            | 2.67e-14| True                                          |
| 1.0            | 0.8883            | 2.61e-11| True                                          |
| 2.0            | 0.9273            | 1.71e-08| True                                          |
| 5.0            | 0.9448            | 3.00e-07| True                                          |

As you can see from the table, for all `migration_rate` values, the `p-value` is considerably less than 0.05. This indicates that the distribution of `div_diff` for each `migration_rate` value **deviates significantly from normality**.



```python?code_reference&code_event_index=2
from scipy.stats import shapiro
import pandas as pd

# Load the CSV file into a DataFrame
df = pd.read_csv('diversity_difference.csv')

# Group by 'biotic_coeff'
grouped_data = df.groupby('biotic_coeff')

# Store results
normality_results = []

# Perform Shapiro-Wilk test for each group
for biotic_coeff, group in grouped_data:
    div_diff_values = group['div_diff'].dropna() # Drop NaN values if any
    
    if len(div_diff_values) >= 5: # Shapiro-Wilk test requires at least 5 observations
        statistic, p_value = shapiro(div_diff_values)
        
        # Determine if it deviates from normality (using alpha = 0.05)
        deviates_from_normality = p_value < 0.05
        
        normality_results.append({
            'biotic_coeff': biotic_coeff,
            'shapiro_statistic': statistic,
            'p_value': p_value,
            'deviates_from_normality': deviates_from_normality
        })
    else:
        normality_results.append({
            'biotic_coeff': biotic_coeff,
            'shapiro_statistic': 'N/A',
            'p_value': 'N/A',
            'deviates_from_normality': f'Not enough data for test (n = {len(div_diff_values)})'
        })

# Create a DataFrame for the results
results_df = pd.DataFrame(normality_results)

# Display the results
print(results_df)
```
```text?code_stdout&code_event_index=2
   biotic_coeff  shapiro_statistic       p_value  deviates_from_normality
0           0.0           0.812968  6.382932e-14                     True
1           0.1           0.895744  3.666247e-10                     True
2           0.5           0.946952  3.600332e-06                     True
3           1.0           0.967601  4.252083e-04                     True
4           2.0           0.974971  9.303265e-03                     True
5           5.0           0.931048  1.488367e-07                     True

```
The Shapiro-Wilk normality test has been performed on the `div_diff` distribution, grouped by each `biotic_coeff` value.
Here are the detailed results:
| biotic_coeff | Shapiro Statistic | p-value | Deviates from Normality (at $\alpha = 0.05$) |
|:-------------|:------------------|:--------|:----------------------------------------------|
| 0.0          | 0.8130            | 6.38e-14| True                                          |
| 0.1          | 0.8957            | 3.67e-10| True                                          |
| 0.5          | 0.9470            | 3.60e-06| True                                          |
| 1.0          | 0.9676            | 4.25e-04| True                                          |
| 2.0          | 0.9750            | 9.30e-03| True                                          |
| 5.0          | 0.9310            | 1.49e-07| True                                          |

**Interpretation:**
For all `biotic_coeff` values, the p-values from the Shapiro-Wilk test are considerably less than 0.05 (our chosen significance level). This indicates that the distribution of `div_diff` for each `biotic_coeff` value **deviates significantly from normality**.


```python?code_reference&code_event_index=2
from scipy.stats import shapiro
import pandas as pd

# Load the CSV file into a DataFrame
df = pd.read_csv('diversity_difference.csv')

# Group by 'abiotic_coeff'
grouped_data = df.groupby('abiotic_coeff')

# Store results
normality_results = []

# Perform Shapiro-Wilk test for each group
for abiotic_coeff, group in grouped_data:
    div_diff_values = group['div_diff'].dropna() # Drop NaN values if any
    
    if len(div_diff_values) >= 5: # Shapiro-Wilk test requires at least 5 observations
        statistic, p_value = shapiro(div_diff_values)
        
        # Determine if it deviates from normality (using alpha = 0.05)
        deviates_from_normality = p_value < 0.05
        
        normality_results.append({
            'abiotic_coeff': abiotic_coeff,
            'shapiro_statistic': statistic,
            'p_value': p_value,
            'deviates_from_normality': deviates_from_normality
        })
    else:
        normality_results.append({
            'abiotic_coeff': abiotic_coeff,
            'shapiro_statistic': 'N/A',
            'p_value': 'N/A',
            'deviates_from_normality': f'Not enough data for test (n = {len(div_diff_values)})'
        })

# Create a DataFrame for the results
results_df = pd.DataFrame(normality_results)

# Display the results
print(results_df)
```
```text?code_stdout&code_event_index=2
   abiotic_coeff  shapiro_statistic       p_value  deviates_from_normality
0            0.0           0.815816  1.233657e-14                     True
1            0.1           0.865034  9.087603e-11                     True
2            0.5           0.966146  5.881732e-04                     True
3            1.0           0.906325  3.301442e-09                     True
4            2.0           0.951529  6.303877e-06                     True
5            5.0           0.967291  6.736429e-04                     True

```
The Shapiro-Wilk normality test has been performed on the `div_diff` distribution, grouped by each `abiotic_coeff` value.

Here are the detailed results:

| abiotic_coeff | Shapiro Statistic | p-value | Deviates from Normality (at $\alpha = 0.05$) |
|:--------------|:------------------|:--------|:----------------------------------------------|
| 0.0           | 0.8158            | 1.23e-14| True                                          |
| 0.1           | 0.8650            | 9.09e-11| True                                          |
| 0.5           | 0.9661            | 5.88e-04| True                                          |
| 1.0           | 0.9063            | 3.30e-09| True                                          |
| 2.0           | 0.9515            | 6.30e-06| True                                          |
| 5.0           | 0.9673            | 6.74e-04| True                                          |

**Interpretation:**

For all `abiotic_coeff` values, the p-values from the Shapiro-Wilk test are considerably less than 0.05 (our chosen significance level). This indicates that the distribution of `div_diff` for each `abiotic_coeff` value **deviates significantly from normality**.


```python?code_reference&code_event_index=2
from scipy.stats import shapiro
import pandas as pd

# Load the CSV file into a DataFrame
df = pd.read_csv('diversity_difference.csv')

# Group by 'selection_coeff'
grouped_data = df.groupby('selection_coeff')

# Store results
normality_results = []

# Perform Shapiro-Wilk test for each group
for selection_coeff, group in grouped_data:
    div_diff_values = group['div_diff'].dropna() # Drop NaN values if any
    
    if len(div_diff_values) >= 5: # Shapiro-Wilk test requires at least 5 observations
        statistic, p_value = shapiro(div_diff_values)
        
        # Determine if it deviates from normality (using alpha = 0.05)
        deviates_from_normality = p_value < 0.05
        
        normality_results.append({
            'selection_coeff': selection_coeff,
            'shapiro_statistic': statistic,
            'p_value': p_value,
            'deviates_from_normality': deviates_from_normality
        })
    else:
        normality_results.append({
            'selection_coeff': selection_coeff,
            'shapiro_statistic': 'N/A',
            'p_value': 'N/A',
            'deviates_from_normality': f'Not enough data for test (n = {len(div_diff_values)})'
        })

# Create a DataFrame for the results
results_df = pd.DataFrame(normality_results)

# Display the results
print(results_df)
```
```text?code_stdout&code_event_index=2
   selection_coeff  shapiro_statistic       p_value  deviates_from_normality
0             0.01           0.972124  6.996569e-06                     True
1             0.12           0.954896  5.070035e-09                     True
2             0.50           0.843193  1.392789e-18                     True

```
The Shapiro-Wilk normality test has been performed on the `div_diff` distribution, grouped by each `selection_coeff` value.

Here are the detailed results:

| selection_coeff | Shapiro Statistic | p-value | Deviates from Normality (at $\alpha = 0.05$) |
|:----------------|:------------------|:--------|:----------------------------------------------|
| 0.01            | 0.9721            | 6.99e-06| True                                          |
| 0.12            | 0.9549            | 5.07e-09| True                                          |
| 0.50            | 0.8432            | 1.39e-18| True                                          |

**Interpretation:**

For all `selection_coeff` values, the p-values from the Shapiro-Wilk test are considerably less than 0.05 (our chosen significance level). This indicates that the distribution of `div_diff` for each `selection_coeff` value **deviates significantly from normality**.





