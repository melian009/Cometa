%================================
%Covariance trait matrix
%https://stats.stackexchange.com/questions/120179/generating-data-with-a-given-sample-covariance-matrix?noredirect=1&lq=1
%================================

%----MAGIC scenario -------------------------
%Smmetric cov matrix with structure
     %1  Cba Cbd
     %Cab 1  Cad
     %Cdb Cda 1
%--------------------------------------------

%OPTION 1================================================
%===========biotic vector
Len = 200;
ro = 1;
d = 3;
N = Len;
Sigma = [1 0.7 0.7;0.7 1 0;0.7 0 1];%Desired trait cov matrix

Zmr=round(unifrnd(1,4));%initial mean biotic trait
sigmar = 12;%initial variance biotic trait
Zrb = ((Zmr -  ro*sigmar) : (sigmar / 100) : (Zmr + ro*sigmar));

a = std(Zrb);
b = Zmr;

%===================
%Test mean 0 std 1
%a = 1;
%b = 0;
%===================

X = (a.*randn(N,d) + b) * chol(Sigma);
cov(X)
mean(X)
std(X)
X = bsxfun(@minus, X, mean(X));
X = X * inv(chol(cov(X)));
X = X * chol(Sigma);
cov(X)
mean(X)
std(X)
%=========================================================

%OPTION 2=====================================================
%Biotic trait-----------------------
a = std(Zrb);b = Zmr;
B = (a.*randn(N,1) + b);
X(:,1) = B;
%-----------------------------------

%Sampling abiotic trait========================================================
Zm = round(unifrnd(45,55));%initial mean abiotic trait
sigmaa = 10;%initial variance abiotic trait
Zra = (Zm -  ro*sigmaa) : (sigmaa / 100) : (Zm + ro*sigmaa);
a = std(Zra);b = Zm;
A = (a.*randn(N,1) + b);
X(:,2) = A;

%Sampling dispersal trait=======================================================
L=1000;%size of the landscape
P = 10;%number of sites 
n = unifrnd(0,L,P,2);%two coordinates each sites
Pd = zeros(P,P);
Pdmean = zeros(P,P);
for i = 1:P,
      for j = i+1:P,
          dx2 = (n(i,1) - n(j,1))^2;%Euclidean distance
          dy2 = (n(i,2) - n(j,2))^2;
          d(i,j) = sqrt(dx2 + dy2);%distance matrix
          Pd(i,j) = 1/d(i,j);
          %==================================================================
          %the lower the distance between i and j the higher the probability
          %to move individuals between them
          %==================================================================        
          Pdmean(i,j) = d(i,j);%mean distance across all pairs of sites
      end
end 
Pd(P,P) = 0;
Pdmean=Pdmean+Pdmean';
D = nonzeros(triu(Pdmean,1));
Dm = mean(D);%Optimum dispersal value for the dispersal trait comparison
Pd=Pd+Pd';
Pdf = sinkhornKnopp(Pd);%Symmetric migration foll. double stochastic matrix
P_ij = cumsum(Pdf,2);
P_ji = cumsum(Pdf,1);
 
 
mu = mean(D);%optimum dispersal value obtained from all pairwise distance values
sigmad = 2;%initial variance dispersal trait
Zrd = (mu -  ro*sigmad) : (sigmad / 100) : (mu + ro*sigmad); 
a = std(Zrd);b = mu;
Di = (a.*randn(N,1) + b);
X(:,3) = Di;
%mean(X(:,3))
%pause
%===============================================================================

X = X * chol(Sigma);

%Checking Outputs=========================================================

cov(X)
mean(X)
std(X)
X = bsxfun(@minus, X, mean(X));
X = X * inv(chol(cov(X)));
X = X * chol(Sigma);
cov(X)
mean(X)
std(X)
%==========================================================================



