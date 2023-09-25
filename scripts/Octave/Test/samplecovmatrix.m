%https://stats.stackexchange.com/questions/120179/generating-data-with-a-given-sample-covariance-matrix
n = 10000;
d = 3;
Sigma = [1  0.7  0.7;0.7 1 0;0.7 0 1];
%rng(42)
X = randn(n, d) * chol(Sigma);
cov(X)
