%https://stats.stackexchange.com/questions/120179/generating-data-with-a-given-sample-covariance-matrix?noredirect=1&lq=1
n = 1000;
d = 3;
Sigma = [1 0.7 0.7;0.7 1 0;0.7 0 1];
     rand("seed",30);%Octave
%rng(42)%matlab
X = randn(n, d) * chol(Sigma);
cov(X)

X = randn(n, d);
X = bsxfun(@minus, X, mean(X));
X = X * inv(chol(cov(X)));
X = X * chol(Sigma);
cov(X)