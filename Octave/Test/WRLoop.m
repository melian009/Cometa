global SR sigma ro gamma


%=====================Abiotic trait=========================     
%SpatialMatrix;%Active when run alone
%SR = 5;%Species landscape
Zm = 50;%Zm is the mean abiotic trait value
%sigma = 10;
Zra = (Zm -  ro*sigma) : (sigma / 100) : (Zm + ro*sigma); 
SRA = repmat(Zra, [10,1,10]);
pdfNormal = normpdf(Zra, Zm, sigma);
        
%Fitness function 
munew = mean(SRA(1,:,1));
for pA = 1:length(Zra);
WA(pA,2) = exp(-gamma*(Zra(1,pA) - munew)^2);
WA(pA,1) = Zra(1,pA) - munew;
end
%===========================================================

%====================Dispersal trait=========================
D = mean(D);%Optimum dispersal value
%Extract distribution from landscape values
mu = D; 
    sigmad = 2; 
    Zi = (mu -  ro*sigmad) : (sigmad / 100) : (mu + ro*sigmad); 
    pdfNormal = normpdf(Zi, mu, sigmad);
    %plot(x, pdfNormal/max(pdfNormal));
    SRD = repmat(Zi, [10,1,10]);
%Fitness function    
for pD = 1:length(Zi);
WD(pD,2) = exp(-gamma*(Zi(1,pD) - D)^2);
WD(pD,1) = Zi(1,pD) - D;
end
%============================================================
  
%====================================Biiotic Trait===========
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

