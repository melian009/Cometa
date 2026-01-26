```python
import pandas as pd
import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt

# Load the data
df = pd.read_csv('diversity_difference.csv')
x = df['correlated_div'].values
y = df['modular_div'].values

# Perform the two-sample Kolmogorov-Smirnov test
ks_stat, p_value = stats.ks_2samp(x, y)

# Plotting the Empirical Cumulative Distribution Functions (ECDFs)
def ecdf(data):
    """Compute ECDF for a 1D array of measurements."""
    n = len(data)
    x = np.sort(data)
    y = np.arange(1, n + 1) / n
    return x, y

x_corr, y_corr = ecdf(x)
x_mod, y_mod = ecdf(y)

plt.figure(figsize=(10, 6))
plt.step(x_corr, y_corr, label='Correlated Diversity', where='post', color='blue', alpha=0.7)
plt.step(x_mod, y_mod, label='Modular Diversity', where='post', color='orange', alpha=0.7, linestyle='--')

# Find the point of maximum difference for annotation (optional but helpful)
# We can approximate this by interpolating one ECDF onto the other's x-values
all_x = np.sort(np.unique(np.concatenate([x_corr, x_mod])))
y1_interp = np.searchsorted(x_corr, all_x, side='right') / len(x_corr)
y2_interp = np.searchsorted(x_mod, all_x, side='right') / len(x_mod)
diff = np.abs(y1_interp - y2_interp)
max_diff_idx = np.argmax(diff)
plt.vlines(all_x[max_diff_idx], y1_interp[max_diff_idx], y2_interp[max_diff_idx], 
           color='red', linestyle=':', label=f'Max Diff (D={ks_stat:.4f})')

plt.title('Two-Sample Kolmogorov-Smirnov Test (ECDF Comparison)')
plt.xlabel('Diversity Value')
plt.ylabel('Cumulative Probability')
plt.legend()
plt.grid(True, linestyle=':', alpha=0.6)

plt.savefig('ks_test_ecdf.png')

print(f"KS Statistic: {ks_stat:.5f}")
print(f"p-value: {p_value:.5f}")



```

```text
KS Statistic: 0.02299
p-value: 0.94565


```

To check if `correlated_div` and `modular_div` are drawn from the same underlying distribution, I performed a **two-sample Kolmogorov-Smirnov (K-S) test**. This is a non-parametric test that measures the maximum distance (D) between the Empirical Cumulative Distribution Functions (ECDFs) of two samples.

### K-S Test Results

* **K-S Statistic (D):** 0.02299
* **p-value:** 0.94565

### Interpretation

* **Null Hypothesis (H_0):** The two samples come from the same distribution.
* **Result:** Since the p-value (0.946) is significantly greater than the standard alpha level of 0.05, we **fail to reject the null hypothesis**.
* **Conclusion:** There is no statistically significant difference between the distributions of `correlated_div` and `modular_div`. The maximum vertical gap between their cumulative curves is only about 2.3\%, which is very small given the sample size (N=1044).

### Visualization (ECDF Comparison)

The plot **`ks_test_ecdf.png`** (shown at the top) displays the cumulative probability for both groups. You can see that the blue line (Correlated) and the dashed orange line (Modular) overlap almost perfectly throughout the entire range of diversity values. The dotted red line indicates the point of maximum divergence used to calculate the K-S statistic.

This result, combined with the previous Bayesian analysis, strongly suggests that these two structural architectures result in essentially identical diversity profiles for this dataset.
