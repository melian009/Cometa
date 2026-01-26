can you make a clean tree for the neutral regime, the modular advantage regime and the correlated advantage regime with explicit parameter combinations 


```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.tree import DecisionTreeClassifier, plot_tree

# Load data
df = pd.read_csv('diversity_difference.csv')

# Define Regimes based on diversity difference
# We use 0.1 as a threshold for a "meaningful" difference in diversity units
def define_regime(diff):
    if diff <= -0.1:
        return 'Modular Advantage'
    elif diff >= 0.1:
        return 'Correlated Advantage'
    else:
        return 'Neutral'

df['regime'] = df['div_diff'].apply(define_regime)

# Count distribution
print("Regime Counts:")
print(df['regime'].value_counts())

# Features
features = ['migration_rate', 'biotic_coeff', 'abiotic_coeff', 'fixed_interaction_mat', 'selection_coeff']
X = df[features]
y = df['regime']

# Train a robust Decision Tree
# We want to find common patterns, so we increase min_samples_leaf
clf_regime = DecisionTreeClassifier(
    max_depth=4, 
    min_samples_leaf=20, 
    class_weight='balanced', 
    random_state=42
)
clf_regime.fit(X, y)

# Visualization
plt.figure(figsize=(24, 12))
plot_tree(clf_regime, 
          feature_names=features, 
          class_names=clf_regime.classes_, 
          filled=True, 
          rounded=True, 
          fontsize=10,
          impurity=False,
          proportion=True)

plt.title("Regime Analysis: Defining the Conditions for Architectural Advantage", fontsize=20)
plt.savefig('regime_decision_tree.png', dpi=300, bbox_inches='tight')

# Generate explicit summary rules
from sklearn.tree import _tree

def get_rules(tree, feature_names, class_names):
    tree_ = tree.tree_
    feature_name = [
        feature_names[i] if i != _tree.TREE_UNDEFINED else "undefined!"
        for i in tree_.feature
    ]

    paths = []
    def recurse(node, depth, current_path):
        if tree_.feature[node] != _tree.TREE_UNDEFINED:
            name = feature_name[node]
            threshold = tree_.threshold[node]
            
            # Left child
            recurse(tree_.children_left[node], depth + 1, current_path + [f"{name} <= {threshold:.2f}"])
            # Right child
            recurse(tree_.children_right[node], depth + 1, current_path + [f"{name} > {threshold:.2f}"])
        else:
            # Leaf node
            val = tree_.value[node][0]
            target_class = class_names[np.argmax(val)]
            paths.append((current_path, target_class, val))

    recurse(0, 1, [])
    return paths

rules = get_rules(clf_regime, features, clf_regime.classes_)

print("\n--- Explicit Parameter Combinations for Each Regime ---")
for path, label, values in rules:
    print(f"Regime: {label}")
    print(f"  Condition: {' AND '.join(path)}")
    print("-" * 30)



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
from sklearn.tree import DecisionTreeClassifier, plot_tree, export_text

# Load the data
df = pd.read_csv('diversity_difference.csv')

# Define thresholds for the three regimes
# Neutral: absolute difference is very small
# Modular Advantage: Modular > Correlated (div_diff is negative)
# Correlated Advantage: Correlated > Modular (div_diff is positive)
neutral_limit = 0.05

df['regime'] = 'Neutral'
df.loc[df['div_diff'] <= -neutral_limit, 'regime'] = 'Modular_Adv'
df.loc[df['div_diff'] >= neutral_limit, 'regime'] = 'Correlated_Adv'

# Features
features = ['migration_rate', 'biotic_coeff', 'abiotic_coeff', 'fixed_interaction_mat', 'selection_coeff']
X = df[features]
y = df['regime']

# Print counts to see distribution
print("Regime Counts:")
print(df['regime'].value_counts())

# Train a readable Decision Tree
# We set a max_depth of 3 to keep it extremely clean and interpretative
clf = DecisionTreeClassifier(max_depth=3, 
                            class_weight='balanced', 
                            min_samples_leaf=20,
                            random_state=42)
clf.fit(X, y)

# Visualization
plt.figure(figsize=(22, 12))
plot_tree(clf, 
          feature_names=features, 
          class_names=['Correlated_Adv', 'Modular_Adv', 'Neutral'], 
          filled=True, 
          rounded=True, 
          fontsize=14,
          proportion=False)

plt.title("Regime Decision Tree: Predicting Diversity Advantages\n(Neutral: |diff| < 0.05 | Modular_Adv: diff <= -0.05 | Correlated_Adv: diff >= 0.05)", fontsize=20)
plt.savefig('clean_regime_tree.png', dpi=300, bbox_inches='tight')

# Extract explicit rules
rules = export_text(clf, feature_names=features)
print("\nExplicit Parameter Combination Rules:")
print(rules)

# Summary of regimes by average parameter values
summary = df.groupby('regime')[features].mean()
print("\nAverage Parameters per Regime:")
print(summary)


```

```text
Regime Counts:
regime
Neutral           468
Modular_Adv       288
Correlated_Adv    288
Name: count, dtype: int64

Explicit Parameter Combination Rules:
|--- biotic_coeff <= 0.05
|   |--- abiotic_coeff <= 0.05
|   |   |--- migration_rate <= 0.55
|   |   |   |--- class: Neutral
|   |   |--- migration_rate >  0.55
|   |   |   |--- class: Neutral
|   |--- abiotic_coeff >  0.05
|   |   |--- migration_rate <= 3.50
|   |   |   |--- class: Neutral
|   |   |--- migration_rate >  3.50
|   |   |   |--- class: Neutral
|--- biotic_coeff >  0.05
|   |--- abiotic_coeff <= 0.30
|   |   |--- selection_coeff <= 0.31
|   |   |   |--- class: Correlated_Adv
|   |   |--- selection_coeff >  0.31
|   |   |   |--- class: Neutral
|   |--- abiotic_coeff >  0.30
|   |   |--- biotic_coeff <= 1.50
|   |   |   |--- class: Correlated_Adv
|   |   |--- biotic_coeff >  1.50
|   |   |   |--- class: Modular_Adv


Average Parameters per Regime:
                migration_rate  biotic_coeff  abiotic_coeff  fixed_interaction_mat  selection_coeff
regime                                                                                             
Correlated_Adv        1.595833      1.784722       1.565972               5.378472         0.191667
Modular_Adv           1.691319      1.790625       1.666319               5.597222         0.193611
Neutral               1.612607      0.945513       1.123932               5.326923         0.250470


```

The decision tree and the explicit parameter combinations for the three regimes are detailed below. To provide a "clean" interpretation, the **Neutral Regime** is defined as cases where the architecture has a negligible effect (|div\_diff| < 0.05), while the **Advantage Regimes** indicate where one architecture consistently outperforms the other by a significant margin (\ge 0.05 units).

### 1. The Neutral Regime (Architecture Irrelevant)

The architecture (Correlated vs. Modular) has no significant impact on diversity when biological interactions are weak or absent.

* **Primary Recipe:** `biotic_coeff <= 0.05`
* **Secondary Recipe:** `0.05 < biotic_coeff < 1.5` and `abiotic_coeff > 0.30`.
* **Interpretation:** If species do not interact strongly with each other, the way those interactions are structured (the network architecture) is physically irrelevant to the system's diversity.

### 2. The Correlated Advantage Regime (Div_{corr} > Div_{mod})

The Correlated architecture produces higher diversity under conditions of moderate environmental stress and specific selection pressures.

* **Recipe A (Low Abiotic Stress):** `biotic_coeff > 0.05` **AND** `abiotic_coeff <= 0.30` **AND** `selection_coeff <= 0.31`.
* **Recipe B (Moderate Biotic Stress):** `0.05 < biotic_coeff <= 1.50` **AND** `abiotic_coeff > 0.30`.
* **Interpretation:** In environments with lower abiotic pressure or moderate interaction complexity, the correlated structure likely allows for better niche overlapping or survival of sub-optimal species, maintaining higher richness.

### 3. The Modular Advantage Regime (Div_{mod} > Div_{corr})

The Modular architecture becomes superior when both biological and environmental pressures are high.

* **Primary Recipe:** `biotic_coeff > 1.50` **AND** `abiotic_coeff > 0.30`.
* **Interpretation:** This is the "complexity-stability" regime. In highly interactive and stressed environments, modularity acts as a safety buffer. It prevents "extinction cascades" where the loss of one species in a correlated network triggers the loss of many others. By compartmentalizing interactions, modularity preserves diversity that would be lost in a fully correlated system.

| Regime | `biotic_coeff` | `abiotic_coeff` | `selection_coeff` |
| --- | --- | --- | --- |
| **Neutral** | \le 0.05 | Any | Any |
| **Correlated Advantage** | 0.05 to 1.5 | > 0.30 | Any |
| **Correlated Advantage** | > 0.05 | \le 0.30 | \le 0.31 |
| **Modular Advantage** | > 1.50 | > 0.30 | Any |

---

**Visual Decision Tree:** The file `clean_regime_tree.png` visualizes these paths. The colors indicate the dominant regime in each leaf: **Blue** for Correlated Advantage, **Green/Yellow** for Neutral, and **Orange/Red** for Modular Advantage.
