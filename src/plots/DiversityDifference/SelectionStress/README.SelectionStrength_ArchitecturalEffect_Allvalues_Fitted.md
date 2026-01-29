```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

# 1. Load Data
df = pd.read_csv('diversity_difference.csv')

# 2. Calculate New Selection Strength and Intensity
# Formula: 1/(biotic + 0.1) + 1/(abiotic + 0.1) + selection_coeff + fixed_interaction_mat
df['SS'] = (1 / (df['biotic_coeff'] + 0.1)) + \
           (1 / (df['abiotic_coeff'] + 0.1)) + \
           df['selection_coeff'] + \
           df['fixed_interaction_mat']

df['Intensity'] = df['div_diff'].abs()

# Clean data
df_clean = df.dropna(subset=['SS', 'Intensity']).replace([np.inf, -np.inf], np.nan).dropna(subset=['SS', 'Intensity'])
x = df_clean['SS'].values
y = df_clean['Intensity'].values
n = len(x)

# 3. Define Models
def linear_model(x, a, b):
    return a * x + b

def exp_decay_model(x, a, b, c):
    return a * np.exp(-b * x) + c

# 4. Fit Models
# Linear fit
popt_lin, _ = curve_fit(linear_model, x, y)
y_pred_lin = linear_model(x, *popt_lin)
rss_lin = np.sum((y - y_pred_lin)**2)
k_lin = 2
aic_lin = n * np.log(rss_lin / n) + 2 * k_lin

# Exponential Decay Fit
initial_guess = [max(y), 0.05, min(y)]
try:
    popt_exp, _ = curve_fit(exp_decay_model, x, y, p0=initial_guess, maxfev=10000)
    y_pred_exp = exp_decay_model(x, *popt_exp)
    rss_exp = np.sum((y - y_pred_exp)**2)
    k_exp = 3
    aic_exp = n * np.log(rss_exp / n) + 2 * k_exp
    fit_success = True
except Exception as e:
    fit_success = False
    error_msg = str(e)

# 5. Plotting
plt.figure(figsize=(10, 7))
plt.scatter(x, y, alpha=0.3, color='gray', label='All Data')

# Generate lines for plotting
x_range = np.linspace(min(x), max(x), 500)
plt.plot(x_range, linear_model(x_range, *popt_lin), 'b--', linewidth=2, label=f'Linear Fit (AIC={aic_lin:.2f})')
if fit_success:
    plt.plot(x_range, exp_decay_model(x_range, *popt_exp), 'r-', linewidth=2, label=f'Exp Decay Fit (AIC={aic_exp:.2f})')

plt.xlabel('Selection Strength', fontsize=16)
plt.ylabel('Architectural Effect intensity', fontsize=16)
plt.legend(fontsize=14)
plt.tick_params(axis='both', labelsize=16)

plt.tight_layout()
plt.savefig('intensity_vs_SS_full_fit.png')

# Print statistics
print(f"Sample size (n): {n}")
print(f"Linear Fit - RSS: {rss_lin:.4f}, AIC: {aic_lin:.4f}")
if fit_success:
    print(f"Exp Decay Fit - RSS: {rss_exp:.4f}, AIC: {aic_exp:.4f}")
    print(f"Exp Parameters (a, b, c): {popt_exp}")
else:
    print(f"Nonlinear fit failed: {error_msg}")



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
import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

# Load data
df = pd.read_csv('diversity_difference.csv')

# Calculate New Selection Strength (with offset and fixed_interaction_mat)
df['SS'] = (1 / (df['biotic_coeff'] + 0.1)) + \
           (1 / (df['abiotic_coeff'] + 0.1)) + \
           df['selection_coeff'] + \
           df['fixed_interaction_mat']

# Calculate Architectural Effect Intensity
df['Intensity'] = df['div_diff'].abs()

# Clean data
df_clean = df.dropna(subset=['SS', 'Intensity']).replace([np.inf, -np.inf], np.nan).dropna(subset=['SS', 'Intensity'])
x = df_clean['SS'].values
y = df_clean['Intensity'].values
n = len(x)

# Define models
def linear_model(x, a, b):
    return a * x + b

def exp_decay_model(x, a, b, c):
    return a * np.exp(-b * x) + c

# Fit models
# Linear fit
popt_lin, _ = curve_fit(linear_model, x, y)
y_pred_lin = linear_model(x, *popt_lin)
rss_lin = np.sum((y - y_pred_lin)**2)
k_lin = 2
aic_lin = n * np.log(rss_lin / n) + 2 * k_lin

# Exponential Decay Fit
initial_guess = [max(y), 0.1, min(y)]
try:
    popt_exp, _ = curve_fit(exp_decay_model, x, y, p0=initial_guess, maxfev=20000)
    y_pred_exp = exp_decay_model(x, *popt_exp)
    rss_exp = np.sum((y - y_pred_exp)**2)
    k_exp = 3
    aic_exp = n * np.log(rss_exp / n) + 2 * k_exp
    fit_success = True
except Exception as e:
    fit_success = False
    error_msg = str(e)

# Plotting
plt.figure(figsize=(10, 7))
plt.scatter(x, y, alpha=0.3, color='gray', label='Data')

# Model lines
x_range = np.linspace(min(x), max(x), 500)
plt.plot(x_range, linear_model(x_range, *popt_lin), 'b--', linewidth=2, label=f'Linear Fit (AIC={aic_lin:.2f})')
if fit_success:
    plt.plot(x_range, exp_decay_model(x_range, *popt_exp), 'r-', linewidth=2, label=f'Exp Decay Fit (AIC={aic_exp:.2f})')

plt.xlabel('Selection Strength', fontsize=16)
plt.ylabel('Architectural Effect intensity', fontsize=16)
plt.legend(fontsize=14)
plt.tick_params(axis='both', labelsize=16)
plt.tight_layout()
plt.savefig('intensity_vs_ss_with_fixed.png')

# Output Statistics
print(f"Sample size (n): {n}")
print(f"Linear Fit - RSS: {rss_lin:.4f}, AIC: {aic_lin:.4f}")
if fit_success:
    print(f"Exp Decay Fit - RSS: {rss_exp:.4f}, AIC: {aic_exp:.4f}")
    print(f"Parameters (a, b, c): {popt_exp}")
else:
    print(f"Nonlinear fit failed: {error_msg}")


```

```text
Sample size (n): 1044
Linear Fit - RSS: 18.9488, AIC: -4181.4736
Exp Decay Fit - RSS: 18.9488, AIC: -4179.4718
Parameters (a, b, c): [ 3.01346903e+02  2.46757042e-05 -3.01143639e+02]


```

I have updated the analysis to include the `fixed_interaction_mat` in the Selection Strength calculation. The new index is calculated as:

The plot below shows the **Architectural Effect Intensity** (absolute value of diversity difference) as a function of this new index for the entire dataset, including both linear and nonlinear fits.

### Model Comparison (All Data with Interaction Matrix)

| Model | RSS | AIC |
| --- | --- | --- |
| **Linear Fit** |  | **** |
| **Exponential Decay** |  |  |

### Statistical Summary

In this configuration, the **Linear Fit** and the **Exponential Decay** model perform almost identically in terms of Residual Sum of Squares (RSS). However, because the linear model is simpler (fewer parameters), it achieves a slightly lower AIC value. The exponential model effectively converged to a linear shape (with a decay rate near zero), suggesting that the inclusion of the interaction matrix spreads the selection regimes in a way that the relationship with intensity appears more linear across the aggregate data.

As requested, the font size for labels and tick marks is set to 16, and the title has been removed.

(The generated plot is saved as `intensity_vs_ss_with_fixed.png`) == saved as SelectionStrength_ArchitecturalEffect_Allvalues_Linearfit.png
