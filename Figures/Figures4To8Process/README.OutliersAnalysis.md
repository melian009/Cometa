Python code to extract the parameter combination patterns given by migration_rate, biotic_coeff, abiotic_coeff, fixed_interaction_mat, and selection_coeff
 that predict the outliers or the extreme cases. 
 
 @This is the most important pattern to quantify the strength of the difference betweeen correlated and modular
 
 
```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.tree import DecisionTreeClassifier, export_text
from sklearn import tree

# Load data
df = pd.read_csv('diversity_difference.csv')

# Define outliers: Top 5% and Bottom 5% of div_diff
low_threshold = df['div_diff'].quantile(0.05)
high_threshold = df['div_diff'].quantile(0.95)

df['category'] = 'Typical'
df.loc[df['div_diff'] <= low_threshold, 'category'] = 'Modular_Dominant' # Negative diff
df.loc[df['div_diff'] >= high_threshold, 'category'] = 'Correlated_Dominant' # Positive diff

print(f"Low threshold (5th percentile): {low_threshold:.4f}")
print(f"High threshold (95th percentile): {high_threshold:.4f}")
print(df['category'].value_counts())

# Features and target
features = ['migration_rate', 'biotic_coeff', 'abiotic_coeff', 'fixed_interaction_mat', 'selection_coeff']
X = df[features]
y = df['category']

# Train a Decision Tree to identify the rules for outliers
# We use a shallow tree to get interpretable rules
dt = DecisionTreeClassifier(max_depth=4, class_weight='balanced', random_state=42)
dt.fit(X, y)

# Get the text representation of the tree
tree_rules = export_text(dt, feature_names=features)
print("\nDecision Tree Rules for Outliers:")
print(tree_rules)

# Feature Importance
importance = pd.Series(dt.feature_importances_, index=features).sort_values(ascending=False)
print("\nFeature Importance:")
print(importance)

# Plot distributions of parameters by category
plt.figure(figsize=(15, 10))
for i, col in enumerate(features):
    plt.subplot(2, 3, i+1)
    sns.boxplot(x='category', y=col, data=df)
    plt.title(f'{col} by Category')

plt.tight_layout()
plt.savefig('parameter_patterns.png')



```

```text
Low threshold (5th percentile): -0.2731
High threshold (95th percentile): 0.2950
category
Typical                938
Modular_Dominant        53
Correlated_Dominant     53
Name: count, dtype: int64

Decision Tree Rules for Outliers:
|--- biotic_coeff <= 0.05
|   |--- class: Typical
|--- biotic_coeff >  0.05
|   |--- abiotic_coeff <= 0.30
|   |   |--- selection_coeff <= 0.31
|   |   |   |--- biotic_coeff <= 3.50
|   |   |   |   |--- class: Typical
|   |   |   |--- biotic_coeff >  3.50
|   |   |   |   |--- class: Modular_Dominant
|   |   |--- selection_coeff >  0.31
|   |   |   |--- class: Typical
|   |--- abiotic_coeff >  0.30
|   |   |--- selection_coeff <= 0.31
|   |   |   |--- fixed_interaction_mat <= 2.50
|   |   |   |   |--- class: Correlated_Dominant
|   |   |   |--- fixed_interaction_mat >  2.50
|   |   |   |   |--- class: Modular_Dominant
|   |   |--- selection_coeff >  0.31
|   |   |   |--- abiotic_coeff <= 3.50
|   |   |   |   |--- class: Correlated_Dominant
|   |   |   |--- abiotic_coeff >  3.50
|   |   |   |   |--- class: Correlated_Dominant


Feature Importance:
biotic_coeff             0.393343
selection_coeff          0.258449
abiotic_coeff            0.220069
fixed_interaction_mat    0.128139
migration_rate           0.000000
dtype: float64


```

```python
# Check unique values for parameters
for col in features:
    print(f"{col}: {df[col].nunique()} unique values: {sorted(df[col].unique())}")

# Calculate the mean div_diff for different combinations of the top 3 parameters
# Grouping by bins for continuous-ish variables
top_params = ['biotic_coeff', 'abiotic_coeff', 'selection_coeff']

# Since most have few levels, we can use pivot tables or groupbys
# But first, let's visualize the "Outlier Probability" as a function of these parameters.
# Let's create a heatmap or a faceted plot.

plt.figure(figsize=(14, 6))

# Plotting the relationship between top 2 parameters and div_diff
plt.subplot(1, 2, 1)
sns.scatterplot(data=df, x='biotic_coeff', y='abiotic_coeff', hue='div_diff', size='abs_div_diff', palette='coolwarm')
plt.title('Biotic vs Abiotic Coeff (Color = Div_Diff)')

plt.subplot(1, 2, 2)
sns.scatterplot(data=df, x='selection_coeff', y='div_diff', hue='category')
plt.title('Selection Coeff vs Div_Diff')

plt.tight_layout()
plt.savefig('parameter_correlations.png')

# Let's look at the interaction of biotic and abiotic on div_diff
pivot_df = df.groupby(['biotic_coeff', 'abiotic_coeff'])['div_diff'].mean().unstack()
plt.figure(figsize=(10, 8))
sns.heatmap(pivot_df, annot=True, cmap='RdBu_r', center=0)
plt.title('Mean div_diff by Biotic and Abiotic Coefficients')
plt.savefig('heatmap_params.png')

# Quantifying patterns for "Extreme Cases"
extremes = df[df['category'] != 'Typical']
print("\nMean parameters for Extreme vs Typical:")
print(df.groupby('category')[features].mean())

# Identify specific high-impact combinations
# Combination with largest absolute mean difference
combinations = df.groupby(['biotic_coeff', 'abiotic_coeff', 'selection_coeff'])['div_diff'].agg(['mean', 'count', 'std'])
print("\nTop 10 combinations by absolute mean div_diff:")
print(combinations.reindex(combinations['mean'].abs().sort_values(ascending=False).index).head(10))
```

```python
# Fix column and rerun
df['abs_div_diff'] = df['div_diff'].abs()

# Detailed analysis of combinations
# We have 5 main parameters. Let's find combinations with high frequency of outliers.
df['is_outlier'] = (df['category'] != 'Typical').astype(int)

# Grouping to find patterns
pattern_summary = df.groupby(['biotic_coeff', 'abiotic_coeff', 'selection_coeff', 'fixed_interaction_mat']).agg(
    mean_diff = ('div_diff', 'mean'),
    abs_mean_diff = ('div_diff', lambda x: x.abs().mean()),
    outlier_rate = ('is_outlier', 'mean'),
    count = ('div_diff', 'count')
).reset_index()

# Sort by absolute mean difference to find where the architecture matters most
top_patterns = pattern_summary.sort_values('abs_mean_diff', ascending=False).head(15)
print("\nTop Parameter Combinations for Extreme Differences:")
print(top_patterns)

# Let's check selection_coeff specifically
print("\nEffect of Selection Coeff on Outlier Rate:")
print(df.groupby('selection_coeff')['is_outlier'].mean())

# Visualization of Top Patterns
plt.figure(figsize=(12, 6))
sns.boxplot(x='selection_coeff', y='div_diff', hue='category', data=df)
plt.title('Distribution of div_diff by Selection Coeff')
plt.savefig('selection_coeff_impact.png')

# Final Tree with better tuning
dt_final = DecisionTreeClassifier(max_depth=3, min_samples_leaf=10, random_state=42)
dt_final.fit(X, (df['div_diff'] > 0.1).astype(int)) # Predicting cases where Correlated >> Modular

print("\nRules for Correlated > Modular (div_diff > 0.1):")
print(export_text(dt_final, feature_names=features))

dt_final_neg = DecisionTreeClassifier(max_depth=3, min_samples_leaf=10, random_state=42)
dt_final_neg.fit(X, (df['div_diff'] < -0.1).astype(int)) # Predicting cases where Modular >> Correlated

print("\nRules for Modular > Correlated (div_diff < -0.1):")
print(export_text(dt_final_neg, feature_names=features))
```




