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
Len = 1000;
ro = 1;
N = Len;
Sigma = [1 0 0.8;0 1 0;0.8 0 1];%Desired 3TC matrix
%Sigma = [1 0;0 1];%Desired 3TC matrix
S = size(Sigma);
d = S(1,1);

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
X(:,2) = X(:,2)+1 .^6;
X(:,3) = X(:,2)+1 .^6;

cov(X);
mean(X);
std(X);
X = bsxfun(@minus, X, mean(X));
X = X * inv(chol(cov(X)));
X = X * chol(Sigma);
cov(X);
mean(X);
std(X);

%=========================================================

%subplot(3,3,1)
%hist(X(:,1),40)
%colormap (jet ());

%hold on

%hist(X(:,2),40,"facecolor", "r", "edgecolor", "b")


subplot(3,3,4)
for i = 1:Len;
hold on
hr1 = plot3(X(i,1),X(i,2),X(i,3),'.',"markersize", 12);
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr1,'color',[a b c]);
end

% clf;
% x = randn (Len, 1);
% y = randn (Len, 1);
% c = x.^2 .* y.^2;
% scatter (X(:,1), X(:,2), 20, c, 'filled');

xlabel('Trait B','fontsize', 14)
ylabel('Trait A','fontsize', 14)
zlabel('Trait M','fontsize', 14)
%set('LineWidth',4);
%set(gca,'fontsize',14);

%===================================================


%OPTION 2================================================
%===========biotic vector
Len = 1000;
ro = 1;
N = Len;
%Sigma = [1 0.7 0.7;0.7 1 0;0.7 0 1];%Desired 3TC matrix
%Sigma = [1 0.8;0.8 1];%Desired 3TC matrix
Sigma = [1 0 0;0 1 0;0 0 1];%Desired 3TC matrix
S = size(Sigma);
d = S(1,1);

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
cov(X);
mean(X);
std(X);
X = bsxfun(@minus, X, mean(X));
X = X * inv(chol(cov(X)));
X = X * chol(Sigma);
cov(X);
mean(X);
std(X);
%=========================================================
%subplot(3,3,2)
%hist(X(:,1),40)
%colormap (summer ());

%hold on

%hist(X(:,2),40,"facecolor", "r", "edgecolor", "b")

subplot(3,3,5)
for i = 1:Len;
hold on
hr1 = plot3(X(i,1),X(i,2),X(i,3),'.',"markersize", 12);
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr1,'color',[a b c]);
end
xlabel('Trait B','fontsize', 14)
ylabel('Trait A','fontsize', 14)
zlabel('Trait M','fontsize', 14)
%set('LineWidth',4);
%set(gca,'fontsize',14);

%==============================================================

%OPTION 3================================================
%===========biotic vector
Len = 1000;
ro = 1;
N = Len;
%Sigma = [1 0.7 0.7;0.7 1 0;0.7 0 1];%Desired 3TC matrix
Sigma = [1 0 -0.8;0 1 0;-0.8 0 1];%Desired 3TC matrix
S = size(Sigma);
d = S(1,1);

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
cov(X);
mean(X);
std(X);
X = bsxfun(@minus, X, mean(X));
X = X * inv(chol(cov(X)));
X = X * chol(Sigma);
cov(X);
mean(X);
std(X);
%=========================================================
%subplot(3,3,3)
%hist(X(:,1),40)
%colormap (summer ());

%hold on

%hist(X(:,2),40,"facecolor", "r", "edgecolor", "b")

subplot(3,3,6)
for i = 1:Len;
hold on
hr1 = plot3(X(i,1),X(i,2),X(i,3),'.',"markersize", 12);
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr1,'color',[a b c]);
end
xlabel('Trait B','fontsize', 14)
ylabel('Trait A','fontsize', 14)
zlabel('Trait M','fontsize', 14)
set('LineWidth',4);
set(gca,'fontsize',14);



