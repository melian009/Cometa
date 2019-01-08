gamma = 10;

%=====================Abiotic trait=========================     
SpatialMatrix;%Active when run alone
SR = 10;%Species landscape
Zm = 50;%Zm is the mean abiotic trait value
sigma = 10;
Zra = (Zm -  1*sigma) : (sigma / 100) : (Zm + 1*sigma); 
SRA = repmat(Zra, [10,1,10]);
pdfNormal = normpdf(Zra, Zm, sigma);
%Plot-----------------------------
subplot(3,2,1)
hr1 = plot(Zra, pdfNormal);%Active when run alone to visualize distribution
%hr1 = plot(Zra, pdfNormal/max(pdfNormal));%test plot
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr1,'color',[a b c]);
set(hr1,'LineWidth',2);
%----------------------------------------
        
%Fitness function 
munew = mean(SRA(1,:,1));
for pA = 1:length(Zra);
WA(pA,2) = exp(-gamma*(Zra(1,pA) - munew)^2);
WA(pA,1) = Zra(1,pA) - munew;
end
subplot(3,2,2)
hr1 = plot(WA(:,1),WA(:,2));%Visualize
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr1,'color',[a b c]);
%===========================================================

%====================Dispersal trait=========================
  L=1000; % size of the landscape
  P = 10;%number of sites 
  n = unifrnd(0,L,P,2);%positions of sites RGG
  Pd = zeros(P,P);
  Pdmean = zeros(P,P);
  for i = 1:P,
      for j = i+1:P,
          dx2 = (n(i,1) - n(j,1))^2;%Euclidean distance
          dy2 = (n(i,2) - n(j,2))^2;
          d(i,j) = sqrt(dx2 + dy2);%distance matrix
          Pd(i,j) = 1/d(i,j);%the lower the distance the higher the probability
          Pdmean(i,j) = d(i,j);%the lower the distance the higher the probability
      end
  end 
  Pd(P,P) = 0;
  Pdmean=Pdmean+Pdmean';
  D = nonzeros(triu(Pdmean,1));
  D = mean(D);%Optimum dispersal value

%Extract distribution from landscape values
mu = D; 
    sigma = 2; 
    Zi = (mu -  5*sigma) : (sigma / 100) : (mu + 5*sigma); 
    pdfNormal = normpdf(Zi, mu, sigma);
    %plot(x, pdfNormal/max(pdfNormal));
    SRD = repmat(Zi, [10,1,10]);

subplot(3,2,3)       
%hr1 = plot(Zi,Zri);%Visualize
hr1 = plot(Zi, pdfNormal/max(pdfNormal)); 
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr1,'color',[a b c]);
set(hr1,'LineWidth',2);
    
%Fitness function    
for pD = 1:length(Zi);
WD(pD,2) = exp(-gamma*(Zi(1,pD) - D)^2);
WD(pD,1) = Zi(1,pD) - D;
end

hold on
subplot(3,2,4)
hr1 = plot(WD(:,1),WD(:,2));%Visualize
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr1,'color',[a b c]);
%---------------------------------------------
  
  
  
%Fitness function B--------------------------
%Resource
   for s = 3.35;%Std
                Zr = -1.5*s:1e-1:1.5*s;%Tuning s or 0.5 changes initial S abundance  
                ZrB = normpdf(Zr, 0, s);%Frequency each phenotype
                Zr = Zr + abs(min(Zr));%Move everything to the right.
                SRB = repmat(Zr, [10,1,10]);
%Plotting trait distributions---
hold on
subplot(3,2,5)
hr1 = plot(Zr,ZrB);%Visualize
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr1,'color',[a b c]);
set(hr1,'LineWidth',2);
end
%-------------------------------

%Consumer
   for s =3.35;%Std
                Zc = -1.5*s:1e-1:1.5*s;%Tuning s or 0.5 changes initial S abundance  
                ZrC = normpdf(Zc, 0, s);%Frequency each phenotype
                Zc = Zc + abs(min(Zc));%Move everything to the right.
                SCB = repmat(Zc, [10,1,10]);
%Plotting trait distributions---
hold on
hr2 = plot(Zc,ZrC);%Visualize
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr2,'color',[a b c]);
set(hr2,'LineWidth',2);
  end
  
for pB = 1:length(Zr);
WB(pB,2) = 1/(1 + exp(-gamma*(Zr(1,pB) - mean(Zc))^2));
WB(pB,1) = Zr(1,pB) - mean(Zc);
end
subplot(3,2,6)
hr1 = plot(WB(:,1),WB(:,2));%Visualize
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr1,'color',[a b c]);

