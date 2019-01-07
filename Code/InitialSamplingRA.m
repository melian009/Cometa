%%%3. INITIAL SAMPLING BAD
%SpatialMatrix;%Active when run alone
SR = 10;%Species landscape
Zm = 50;%Zm is the mean abiotic trait value
sigma = 1;
Zra = (Zm -  2*sigma) : (sigma / 100) : (Zm + 2*sigma); 
pdfNormal = normpdf(Zra, Zm, sigma);
%Plot-----------------------------
%hr1 = plot(Zra, pdfNormal);%Active when run alone to visualize distribution
%hr1 = plot(Zra, pdfNormal/max(pdfNormal));%test plot
%a =unifrnd(0,1);
%b =unifrnd(0,1);
%c =unifrnd(0,1);
%set(hr1,'color',[a b c]);
%set(hr1,'LineWidth',2);
%----------------------------------------
