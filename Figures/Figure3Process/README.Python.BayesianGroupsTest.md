We used Bayesian comparison of two groups using the Normal and Gamma
model for the columns correlated_div and modular_div - do their mean and variance significantly differ? 


```python
import pandas as pd
import numpy as np

# Load the data
df = pd.read_csv('diversity_difference.csv')

# Basic info
print(df[['correlated_div', 'modular_div']].describe())
print(df[['correlated_div', 'modular_div']].head())

# Check for missing values
print(df[['correlated_div', 'modular_div']].isnull().sum())



```

```text
       correlated_div  modular_div
count     1044.000000  1044.000000
mean         2.050666     2.045992
std          0.820786     0.824785
min          0.065136     0.065136
25%          2.147205     2.153504
50%          2.394786     2.385296
75%          2.539684     2.541015
max          2.720412     2.740911
   correlated_div  modular_div
0        0.085476     0.067089
1        0.237230     0.264894
2        2.375694     2.380004
3        2.296055     2.437782
4        2.574478     2.578007
correlated_div    0
modular_div       0
dtype: int64


```

```python
import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt

# Data
y1 = df['correlated_div'].values
y2 = df['modular_div'].values
n1, n2 = len(y1), len(y2)
mean1, mean2 = np.mean(y1), np.mean(y2)
var1, var2 = np.var(y1, ddof=1), np.var(y2, ddof=1)

# Number of samples
S = 20000

# 1. Normal Model Bayesian Comparison
# Priors: p(mu, sigma^2) propto 1/sigma^2
# Posterior sigma^2 ~ Inv-Gamma((n-1)/2, (n-1)s^2/2)
# Posterior mu | sigma^2 ~ N(mean, sigma^2/n)

sigma2_1_samples = stats.invgamma.rvs((n1 - 1) / 2, scale=(n1 - 1) * var1 / 2, size=S)
mu1_samples = stats.norm.rvs(mean1, np.sqrt(sigma2_1_samples / n1))

sigma2_2_samples = stats.invgamma.rvs((n2 - 1) / 2, scale=(n2 - 1) * var2 / 2, size=S)
mu2_samples = stats.norm.rvs(mean2, np.sqrt(sigma2_2_samples / n2))

diff_mu_normal = mu1_samples - mu2_samples
ratio_sigma2_normal = sigma2_1_samples / sigma2_2_samples

# 2. Gamma Model Bayesian Comparison
# Likelihood: Gamma(shape=a, rate=b)
# Using a simple Metropolis-Hastings or since n is large, use normal approximation to the posterior (Laplace)
# Or just MCMC. Let's do a simple MCMC.

def log_posterior_gamma(params, data):
    a, b = params
    if a <= 0 or b <= 0:
        return -np.inf
    # Priors p(a) ~ Exp(0.01), p(b) ~ Exp(0.01) (weakly informative)
    log_prior = stats.expon.logpdf(a, scale=100) + stats.expon.logpdf(b, scale=100)
    log_lik = np.sum(stats.gamma.logpdf(data, a, scale=1/b))
    return log_prior + log_lik

def sample_gamma_mcmc(data, S=S):
    # Starting values from MLE
    shape, loc, scale = stats.gamma.fit(data, floc=0)
    a_start, b_start = shape, 1/scale
    
    current_p = np.array([a_start, b_start])
    current_log_post = log_posterior_gamma(current_p, data)
    
    samples = np.zeros((S, 2))
    # Adaptive-ish proposal
    step = np.array([0.05, 0.05]) 
    
    for i in range(S):
        proposal = current_p + np.random.normal(0, step)
        prop_log_post = log_posterior_gamma(proposal, data)
        
        if prop_log_post > current_log_post or np.random.rand() < np.exp(prop_log_post - current_log_post):
            current_p = proposal
            current_log_post = prop_log_post
        
        samples[i] = current_p
    return samples

# Sampling for Gamma
# Burn-in 2000
gamma_samples1 = sample_gamma_mcmc(y1, S + 2000)[2000:]
gamma_samples2 = sample_gamma_mcmc(y2, S + 2000)[2000:]

# Mean = a/b, Var = a/b^2
mu1_gamma = gamma_samples1[:, 0] / gamma_samples1[:, 1]
var1_gamma = gamma_samples1[:, 0] / (gamma_samples1[:, 1]**2)

mu2_gamma = gamma_samples2[:, 0] / gamma_samples2[:, 1]
var2_gamma = gamma_samples2[:, 0] / (gamma_samples2[:, 1]**2)

diff_mu_gamma = mu1_gamma - mu2_gamma
ratio_var_gamma = var1_gamma / var2_gamma

# Summaries
def get_summary(samples, name):
    return {
        'mean': np.mean(samples),
        'hdi_low': np.percentile(samples, 2.5),
        'hdi_high': np.percentile(samples, 97.5),
        'prob_gt_0': np.mean(samples > 0) if 'diff' in name else np.mean(samples > 1)
    }

results = {
    'Normal_Mu_Diff': get_summary(diff_mu_normal, 'diff'),
    'Normal_Var_Ratio': get_summary(ratio_sigma2_normal, 'ratio'),
    'Gamma_Mu_Diff': get_summary(diff_mu_gamma, 'diff'),
    'Gamma_Var_Ratio': get_summary(ratio_var_gamma, 'ratio')
}

print(results)

# Plotting
fig, axes = plt.subplots(2, 2, figsize=(12, 10))

# Normal Mu Diff
axes[0, 0].hist(diff_mu_normal, bins=50, color='skyblue', density=True, alpha=0.7)
axes[0, 0].axvline(0, color='red', linestyle='--')
axes[0, 0].set_title('Normal Model: Difference in Means\n(Correlated - Modular)')
axes[0, 0].set_xlabel('$\mu_1 - \mu_2$')

# Normal Var Ratio
axes[0, 1].hist(ratio_sigma2_normal, bins=50, color='salmon', density=True, alpha=0.7)
axes[0, 1].axvline(1, color='red', linestyle='--')
axes[0, 1].set_title('Normal Model: Ratio of Variances\n(Correlated / Modular)')
axes[0, 1].set_xlabel('$\sigma^2_1 / \sigma^2_2$')

# Gamma Mu Diff
axes[1, 0].hist(diff_mu_gamma, bins=50, color='lightgreen', density=True, alpha=0.7)
axes[1, 0].axvline(0, color='red', linestyle='--')
axes[1, 0].set_title('Gamma Model: Difference in Means\n(Correlated - Modular)')
axes[1, 0].set_xlabel('$E[Y_1] - E[Y_2]$')

# Gamma Var Ratio
axes[1, 1].hist(ratio_var_gamma, bins=50, color='orange', density=True, alpha=0.7)
axes[1, 1].axvline(1, color='red', linestyle='--')
axes[1, 1].set_title('Gamma Model: Ratio of Variances\n(Correlated / Modular)')
axes[1, 1].set_xlabel('$Var[Y_1] / Var[Y_2]$')

plt.tight_layout()
plt.savefig('bayesian_comparison.png')
plt.show()



```

```text
{'Normal_Mu_Diff': {'mean': 0.0049526366740160295, 'hdi_low': -0.06531892108054253, 'hdi_high': 0.07579272489533574, 'prob_gt_0': 0.5529}, 'Normal_Var_Ratio': {'mean': 0.9919675911928613, 'hdi_low': 0.8777776579002861, 'hdi_high': 1.1181162916286602, 'prob_gt_0': 0.4349}, 'Gamma_Mu_Diff': {'mean': 0.0071090874802144325, 'hdi_low': -0.12766040756203065, 'hdi_high': 0.1390541931422542, 'prob_gt_0': 0.54435}, 'Gamma_Var_Ratio': {'mean': 0.9829303845368151, 'hdi_low': 0.8196119134263578, 'hdi_high': 1.1572019525987616, 'prob_gt_0': 0.4092}}
has vm saved
has vm saved


```

The Bayesian comparison of `correlated_div` and `modular_div` shows that **neither their means nor their variances significantly differ** under either the Normal or the Gamma model.

### Methodology

To assess the differences, I performed Bayesian parameter estimation for each group:

1. **Normal Model:** Data was modeled as y \sim \mathcal{N}(\mu, \sigma^2) using non-informative priors.
2. **Gamma Model:** Data was modeled as y \sim \text{Gamma}(\alpha, \beta) (where \alpha is shape and \beta is rate) using weakly informative priors. I used Markov Chain Monte Carlo (MCMC) sampling to estimate the joint posterior of the parameters.

The quantities of interest were the **Difference in Means** (subtraction) and the **Ratio of Variances** (division).

### Key Results

| Model | Metric | Posterior Mean | 95% Credibility Interval (HDI) | Probability (P > \text{Null}) |
| --- | --- | --- | --- | --- |
| **Normal** | **Mean Diff** (\mu_1 - \mu_2) | 0.005 | [-0.065, 0.076] | 55.3% (P > 0) |
|  | **Var Ratio** (\sigma^2_1 / \sigma^2_2) | 0.992 | [0.878, 1.118] | 43.5% (P > 1) |
| **Gamma** | **Mean Diff** (E_1 - E_2) | 0.007 | [-0.128, 0.139] | 54.4% (P > 0) |
|  | **Var Ratio** (V_1 / V_2) | 0.983 | [0.820, 1.157] | 40.9% (P > 1) |

### Interpretation

* **Means:** For both models, the 95% credibility interval for the difference in means includes zero. The probability that `correlated_div` has a higher mean than `modular_div` is roughly 54-55%, which is very close to a coin flip (50%). This suggests no significant difference in the average diversity between the groups.
* **Variances:** The ratio of variances is very close to 1 (equality) in both models. The 95% intervals easily encompass 1.0, and the probabilities are close to 50%, indicating that the spread or uncertainty in diversity is essentially identical for both modular and correlated structures.
* **Model Comparison:** The results are consistent across both distributions. The Normal model provides slightly tighter estimates, while the Gamma model (which is often better for strictly positive data like diversity indices) shows slightly more uncertainty but confirms the same lack of a significant effect.

In summary, based on the Bayesian analysis of the 1,044 samples provided, there is **no evidence of a meaningful difference** in diversity metrics between the correlated and modular groups.
