can you tell if the different in diversity , div_diff, significantly differ from a normal distribution


```python
import pandas as pd
import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt

# Load the data
df = pd.read_csv('diversity_difference.csv')
div_diff = df['div_diff'].dropna()

# 1. Descriptive statistics
mean = div_diff.mean()
std = div_diff.std()
skew = div_diff.skew()
kurtosis = div_diff.kurtosis()

# 2. Normality Tests
# D'Agostino's K^2 test
k2, p_dagostino = stats.normaltest(div_diff)

# Shapiro-Wilk test (N=1044 is fine)
shapiro_stat, p_shapiro = stats.shapiro(div_diff)

# 3. Visualization
plt.figure(figsize=(12, 5))

# Histogram with Normal Overlay
plt.subplot(1, 2, 1)
n, bins, patches = plt.hist(div_diff, bins=50, density=True, alpha=0.6, color='skyblue', label='Observed')
# Normal curve for comparison
xmin, xmax = plt.xlim()
x = np.linspace(xmin, xmax, 100)
p = stats.norm.pdf(x, mean, std)
plt.plot(x, p, 'r', linewidth=2, label='Normal Distribution')
plt.title(f'Histogram of div_diff\n(Skew: {skew:.2f}, Kurtosis: {kurtosis:.2f})')
plt.xlabel('div_diff')
plt.ylabel('Density')
plt.legend()

# Q-Q Plot
plt.subplot(1, 2, 2)
stats.probplot(div_diff, dist="norm", plot=plt)
plt.title('Q-Q Plot of div_diff')

plt.tight_layout()
plt.savefig('normality_test.png')

# Output results
print(f"Mean: {mean:.5f}")
print(f"Std: {std:.5f}")
print(f"Skewness: {skew:.5f}")
print(f"Kurtosis: {kurtosis:.5f}")
print(f"D'Agostino's K^2 Test: p-value = {p_dagostino:.5e}")
print(f"Shapiro-Wilk Test: p-value = {p_shapiro:.5e}")



```

```text
Mean: 0.00467
Std: 0.18209
Skewness: 0.55154
Kurtosis: 5.37404
D'Agostino's K^2 Test: p-value = 7.19213e-39
Shapiro-Wilk Test: p-value = 6.01110e-25


```

To determine if the differences in diversity (`div_diff`) are normally distributed, I performed a quantitative normality analysis and created diagnostic plots.

### 1. Statistical Normality Tests

The null hypothesis for these tests is that the data is sampled from a normal distribution.

* **D'Agostino's K^2 Test:** p < 0.0001 (7.19 \times 10^{-39})
* **Shapiro-Wilk Test:** p < 0.0001 (6.01 \times 10^{-25})

**Conclusion:** Both tests strongly reject the null hypothesis. The distribution of `div_diff` **differs significantly from a normal distribution**.

### 2. Descriptive Shape Parameters

* **Skewness: 0.55** (Positive value indicates the distribution is slightly right-skewed; there are more extreme positive differences than negative ones).
* **Kurtosis: 5.37** (A normal distribution has a kurtosis of 3.0. A value of 5.37 indicates a **Leptokurtic** distribution, meaning it has "fat tails" and a sharper peak than a normal distribution. This suggests that while most differences are near zero, extreme outliers occur more frequently than expected under normality).

### 3. Visual Inspection (See `normality_test.png`)

* **Histogram:** While the data is centered near zero, you can see the "peakedness" and the asymmetry in the tails compared to the red normal curve overlay.
* **Q-Q Plot:** In a normal distribution, the blue dots should follow the red diagonal line perfectly. Instead, we see an **"S-curve" pattern**:
* The points at the ends (tails) curve away from the line, confirming the heavy-tailed nature (kurtosis) identified by the statistics.
* The slight upward arch in the center confirms the positive skew.



### Summary

The `div_diff` variable is **not normally distributed**. It is characterized by high kurtosis (heavy tails) and a slight positive skew. This explains why the Bayesian analysis using a Normal model (which assumes thin tails) and a Gamma model (which usually expects a specific skew) resulted in wide credibility intervals; the data has more "extreme" events in the differences than these standard models anticipate.
