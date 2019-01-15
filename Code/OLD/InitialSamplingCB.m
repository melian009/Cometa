%%%3. INITIAL SAMPLING BAD
%SpatialMatrix;%Active when run alone
SC = 10;%#Consumer species landscape
Zm = 75;%Mean biotic trait of consumer species
sigma = 1;
Zcb = (Zm -  2*sigma) : (sigma / 100) : (Zm + 2*sigma); 
pdfNormal = normpdf(Zcb, Zm, sigma);
%Plot-----------------------------
%hr1 = plot(Zcb, pdfNormal);%Active when run alone to visualize distribution
%hr1 = plot(Zcb, pdfNormal/max(pdfNormal));%test plot
%a =unifrnd(0,1);
%b =unifrnd(0,1);
%c =unifrnd(0,1);
%set(hr1,'color',[a b c]);
%set(hr1,'LineWidth',2);
%----------------------------------------
