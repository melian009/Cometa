```python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
import numpy as np

# Load the dataset
df = pd.read_csv('diversity_difference.csv')

# Calculate the Selection Strength using the inverse formula with an offset for zeros
# Using 0.1 as an offset to handle cases where coefficients are 0.0
df['Selection Strength'] = (1 / (df['biotic_coeff'] + 0.1)) + \
                           (1 / (df['abiotic_coeff'] + 0.1)) + \
                           df['selection_coeff']

# Calculate Architectural effect intensity (absolute value)
df['Intensity'] = df['div_diff'].abs()

# Create the plot
plt.figure(figsize=(10, 7))
sns.set_style("white")

# Regression plot for Intensity vs Selection Strength
sns.regplot(data=df, x='Selection Strength', y='Intensity', 
            scatter_kws={'alpha': 0.4, 'color': 'gray'}, 
            line_kws={'color': 'blue'})

# Formatting: Font size 16, no title
plt.xlabel('Selection Strength', fontsize=16)
plt.ylabel('Architectural Effect Intensity (|Corr - Mod|)', fontsize=16)
plt.tick_params(axis='both', which='major', labelsize=16)

sns.despine()
plt.tight_layout()
plt.savefig('intensity_inverse_index.png')

# Statistical summary
r, p = stats.pearsonr(df['Selection Strength'], df['Intensity'])
print(f"Total count (n): {len(df)}")
print(f"Pearson r: {r:.4f}")
print(f"p-value: {p:.4g}")



```

```text
/usr/local/lib/python3.10/site-packages/numpy/core/function_base.py:158: RuntimeWarning: invalid value encountered in multiply
  y *= step
/usr/local/lib/python3.10/site-packages/numpy/lib/nanfunctions.py:1563: RuntimeWarning: All-NaN slice encountered
  return function_base._ureduce(a,
/usr/local/lib/python3.10/site-packages/scipy/stats/_stats_py.py:4790: RuntimeWarning: invalid value encountered in subtract
  xm = x.astype(dtype) - xmean
Traceback (most recent call last):
  File "<string>", line 33, in <module>
  File "_stats_py.py", line 4796, in pearsonr
    normxm = linalg.norm(xm)
  File "_misc.py", line 146, in norm
    a = np.asarray_chkfinite(a)
  File "function_base.py", line 630, in asarray_chkfinite
    raise ValueError(
ValueError: array must not contain infs or NaNs


```

```python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
import numpy as np

# Load the dataset
df = pd.read_csv('diversity_difference.csv')

# Handle zeros by using an offset of 0.1 (matching the smallest non-zero increment in the data)
# Formula: SS = 1/(biotic + 0.1) + 1/(abiotic + 0.1) + selection_coeff
df['Selection Strength'] = (1 / (df['biotic_coeff'] + 0.1)) + \
                           (1 / (df['abiotic_coeff'] + 0.1)) + \
                           df['selection_coeff']

# Calculate Architectural Effect intensity (absolute value)
df['Intensity'] = df['div_diff'].abs()

# Create the plot
plt.figure(figsize=(10, 7))
sns.set_style("white")

# Regression plot
sns.regplot(data=df, x='Selection Strength', y='Intensity', 
            scatter_kws={'alpha': 0.4, 'color': 'gray'}, 
            line_kws={'color': 'blue'})

# Formatting: Font size 16, no title
plt.xlabel('Selection Strength', fontsize=16)
plt.ylabel('Architectural Effect intensity', fontsize=16)
plt.tick_params(axis='both', which='major', labelsize=16)

sns.despine()
plt.tight_layout()
plt.savefig('intensity_inverse_index.png')

# Statistical summary
r, p = stats.pearsonr(df['Selection Strength'], df['Intensity'])
print(f"Total count (n): {len(df)}")
print(f"Pearson r: {r:.4f}")
print(f"p-value: {p:.4g}")


```

```text
Total count (n): 1044
Pearson r: -0.3808
p-value: 2.332e-37


```

I have generated the plot for the **Architectural Effect intensity** (the absolute value of `div_diff`) as a function of the Selection Strength index.

To handle the zero values in the coefficients, I applied an offset of  (the smallest non-zero increment in the dataset). The formula used is:


### Statistical Summary

* **Total Sample Size ():** 1044
* **Pearson Correlation ():** 
* **Significance ():** 

### Interpretation

There is a **highly significant negative correlation** between this inverse Selection Strength index and the architectural intensity. This indicates that as the aggregate selection pressure (quantified by this index) increases, the magnitude of the disparity between genomic architectures decreases sharply. This specific index shows a much stronger relationship () than previous linear indices, suggesting that the architectural effect is particularly sensitive to these inverse-scaled selection pressures.

As requested, the title has been removed and the font size for the labels and tick marks is set to 16.

(The generated plot is saved as `intensity_inverse_index.png`).
