%=====================Abiotic trait=========================     
SpatialMatrix;%Active when run alone
SR = 10;%Species landscape
Zm = 50;%Zm is the mean abiotic trait value
sigma = 10;
Zra = (Zm -  1*sigma) : (sigma / 100) : (Zm + 1*sigma); 
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
    sigma = 2; 
    Zi = (mu -  5*sigma) : (sigma / 100) : (mu + 5*sigma); 
    pdfNormal = normpdf(Zi, mu, sigma);
    %plot(x, pdfNormal/max(pdfNormal));
    SRD = repmat(Zi, [10,1,10]);
%Fitness function    
for pD = 1:length(Zi);
WD(pD,2) = exp(-gamma*(Zi(1,pD) - D)^2);
WD(pD,1) = Zi(1,pD) - D;
end
%============================================================
  
%==========================Biotic trait======================
%Resource
   for s = 3.35;%Std
                Zr = -1.5*s:1e-1:1.5*s;%Tuning s or 0.5 changes initial S abundance  
                ZrB = normpdf(Zr, 0, s);%Frequency each phenotype
                Zr = Zr + abs(min(Zr));%Move everything to the right.
                SRB = repmat(Zr, [10,1,10]);
    end

%Consumer
   for s =3.35;%Std
                Zc = -1.5*s:1e-1:1.5*s;%Tuning s or 0.5 changes initial S abundance  
                ZrC = normpdf(Zc, 0, s);%Frequency each phenotype
                Zc = Zc + abs(min(Zc));%Move everything to the right.
                SCB = repmat(Zc, [10,1,10]); 
   end
  
for pB = 1:length(Zr);
WB(pB,2) = 1/(1 + exp(-gamma*(Zr(1,pB) - mean(Zc))^2));
WB(pB,1) = Zr(1,pB) - mean(Zc);
end

