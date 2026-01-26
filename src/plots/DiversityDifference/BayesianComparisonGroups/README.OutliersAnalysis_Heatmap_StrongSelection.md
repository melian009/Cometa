```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load data
df = pd.read_csv('diversity_difference.csv')

# Filter for strong selection
strong_sel = df[df['selection_coeff'] == 0.5].copy()

# Create pivot table for mean div_diff
pivot_strong = strong_sel.groupby(['abiotic_coeff', 'biotic_coeff'])['div_diff'].mean().unstack()

# Sort columns (Biotic) from 0 to 5 (Left to Right)
pivot_strong = pivot_strong.sort_index(axis=1, ascending=True)

# Sort index (Abiotic) from 5 to 0 (Top to Bottom) 
# This makes 0.0 appear at the bottom and 5.0 at the top of the plot
pivot_strong = pivot_strong.sort_index(axis=0, ascending=False)

# Plotting the heatmap
plt.figure(figsize=(12, 9))
sns.heatmap(pivot_strong, 
            annot=True, 
            fmt=".3f", 
            cmap='RdBu_r', 
            center=0, 
            square=True,
            cbar_kws={'label': 'Mean Diversity Difference (Correlated - Modular)'},
            annot_kws={"size": 11})

plt.title('Mean Diversity Difference: Strong Selection ($s=0.5$)\nOriented from 0 to 5 on Both Axes', fontsize=16)
plt.ylabel('Abiotic Coefficient (0 $\\rightarrow$ 5)', fontsize=14)
plt.xlabel('Biotic Coefficient (0 $\\rightarrow$ 5)', fontsize=14)

# Set the aspect of the plot to be equal so it's a perfect square if possible, 
# though 'square=True' in heatmap already handles this.

plt.tight_layout()
plt.savefig('heatmap_strong_selection_v3.png', dpi=300)

# Re-confirming values for the response
print("Pivot Table (Abiotic as Index, Biotic as Columns):")
print(pivot_strong)



```

```text
Traceback (most recent call last):
  File "<string>", line 17, in <module>
  File "relational.py", line 742, in scatterplot
    p = _ScatterPlotter(data=data, variables=variables, legend=legend)
  File "relational.py", line 538, in __init__
    super().__init__(data=data, variables=variables)
  File "_oldcore.py", line 640, in __init__
    self.assign_variables(data, variables)
  File "_oldcore.py", line 701, in assign_variables
    plot_data, variables = self._assign_variables_longform(
  File "_oldcore.py", line 938, in _assign_variables_longform
    raise ValueError(err)
ValueError: Could not interpret value `abs_div_diff` for parameter `size`


```

```text
migration_rate: 5 unique values: [0.0, 0.1, 1.0, 2.0, 5.0]
biotic_coeff: 6 unique values: [0.0, 0.1, 0.5, 1.0, 2.0, 5.0]
abiotic_coeff: 6 unique values: [0.0, 0.1, 0.5, 1.0, 2.0, 5.0]
fixed_interaction_mat: 10 unique values: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
selection_coeff: 3 unique values: [0.01, 0.12, 0.5]


```

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load data
df = pd.read_csv('diversity_difference.csv')

# Filter for strong selection
strong_sel = df[df['selection_coeff'] == 0.5].copy()

# Create pivot table
# Abiotic on index (y-axis), Biotic on columns (x-axis)
pivot_strong = strong_sel.groupby(['abiotic_coeff', 'biotic_coeff'])['div_diff'].mean().unstack()

# Adjusting orientation as requested:
# X-axis (columns): 0 to 5 (Left to Right)
pivot_strong = pivot_strong.sort_index(axis=1, ascending=True)
# Y-axis (index): 5 to 0 (Top to Bottom) so that 0 appears at the bottom of the heatmap
pivot_strong = pivot_strong.sort_index(axis=0, ascending=False)

# Plotting the heatmap
plt.figure(figsize=(10, 8))
sns.heatmap(pivot_strong, 
            annot=True, 
            fmt=".3f", 
            cmap='RdBu_r', 
            center=0, 
            square=True,
            cbar_kws={'label': 'Mean Diversity Difference (Correlated - Modular)'},
            annot_kws={"size": 10})

plt.title('Mean Diversity Difference: Strong Selection ($s=0.5$)\n(0.0 at origin; Biotic: Left to Right | Abiotic: Bottom to Top)', fontsize=14)
plt.ylabel('Abiotic Coefficient (0.0 to 5.0)', fontsize=12)
plt.xlabel('Biotic Coefficient (0.0 to 5.0)', fontsize=12)

# Save the plot
plt.savefig('heatmap_strong_selection_v3.png', dpi=300, bbox_inches='tight')

# Verification of values
print("Pivot Table (Rows=Abiotic, Cols=Biotic):")
print(pivot_strong)



```

```text
Pivot Table (Rows=Abiotic, Cols=Biotic):
biotic_coeff        0.0       0.1       0.5       1.0       2.0       5.0
abiotic_coeff                                                            
5.0           -0.000098 -0.001783  0.003431  0.032830  0.044311 -0.032163
2.0            0.000168  0.086221  0.126534  0.182715 -0.234210  0.079090
1.0           -0.009618  0.033255 -0.059979  0.170280 -0.326873  0.001672
0.5            0.000828 -0.049877  0.050980 -0.043923  0.108426  0.100556
0.1           -0.003718 -0.004174  0.001297  0.000306  0.002992  0.000163
0.0            0.004231  0.003348 -0.001270  0.001028 -0.002469  0.001012


```

The heatmap for strong selection (s = 0.5) has been updated with the requested orientation. In this version (`heatmap_strong_selection_v3.png`):

* **Biotic Coefficient (X-axis):** Ranges from **0.0 (left) to 5.0 (right)**.
* **Abiotic Coefficient (Y-axis):** Ranges from **0.0 (bottom) to 5.0 (top)**, placing the origin (0,0) at the bottom-left.

### Key Observations from the Adjusted Heatmap:

* **Neutral Baseline:** The bottom row (Abiotic = 0) and leftmost column (Biotic = 0) consist mostly of values near zero (white/light colors). This confirms that neither architecture provides an advantage when one of the stressors is absent.
* **Modular Hotspot (Blue):** There is a distinct "blue" region around **Biotic = 2.0** and **Abiotic = 1.0 to 2.0**. In these moderately complex environments, the Modular architecture consistently outperforms the Correlated one.
* **Correlated Advantage (Red):** The Correlated architecture shows its strongest performance in two areas:
1. **Low Abiotic / High Biotic:** Around Abiotic = 0.5 and Biotic = 2.0 to 5.0.
2. **High Abiotic / Moderate Biotic:** Around Abiotic = 2.0 and Biotic = 1.0.



This mapping clarifies that the Modular architecture is specifically beneficial in high-interaction/moderate-environment scenarios, likely by preventing competitive cascades, while Correlated architectures are more effective in high-environment-stress scenarios.
