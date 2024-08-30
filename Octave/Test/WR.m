gamma = 10;
ro = 1;
%=====================Abiotic trait=========================     
SpatialMatrix;%Active when run alone
SR = 10;%Species landscape
Zm = 50;%Zm is the mean abiotic trait value
sigma = 10;
Zra = (Zm -  1*sigma) : (sigma / 100) : (Zm + 1*sigma); %n change initial abu
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
    Zi = (mu -  1*sigma) : (sigma / 100) : (mu + 1*sigma); 
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
%SR = 10;%#Resource species landscape
Zmr = 2;%Mean biotic trait of resource species
sigma = 12;
Zrb = (Zmr -  ro*sigma) : (sigma / 100) : (Zmr + ro*sigma); 
pdfNormal = normpdf(Zrb, Zmr, sigma);

%Consumer
Zmc = 4;%Mean biotic trait of resource species
sigma = 1;
Zcb = (Zmc -  ro*sigma) : (sigma / 100) : (Zmc + ro*sigma); 
pdfNormal = normpdf(Zcb, Zmc, sigma);


for pB = 1:length(Zrb);
WB(pB,2) = 1/(1 + exp(-gamma*(Zrb(1,pB) - mean(Zcb))^2));
WB(pB,1) = Zrb(1,pB) - mean(Zcb);
end

subplot(3,2,5)
hr1 = plot(Zrb, pdfNormal/max(pdfNormal)); 
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr1,'color',[a b c]);
set(hr1,'LineWidth',2);

hold on
subplot(3,2,6)
hr1 = plot(WB(:,1),WB(:,2));%Visualize
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr1,'color',[a b c]);
set(hr1,'LineWidth',2);

