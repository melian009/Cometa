%%%3. INITIAL SAMPLING BAD
SpatialMatrix;
SR = 10;SC = 10;%Species landscape
Zm = 50;%Zm is the mean abiotic trait value
sigma = 1;
Za = (Zm -  2*sigma) : (sigma / 100) : (Zm + 2*sigma); 
pdfNormal = normpdf(Za, Zm, sigma);
%Plot-----------------------------
hr1 = plot(Za, pdfNormal);%test plot
%hr1 = plot(Zd, pdfNormal/max(pdfNormal));%test plot
%a =unifrnd(0,1);
%b =unifrnd(0,1);
%c =unifrnd(0,1);
%set(hr1,'color',[a b c]);
%set(hr1,'LineWidth',2);
%----------------------------------------
