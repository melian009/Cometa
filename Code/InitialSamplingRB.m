%%%3. INITIAL SAMPLING BAD
%SpatialMatrix;%Active when run alone
SR = 10;%#Resource species landscape
Zm = 75;%Mean biotic trait of resource species
sigma = 1;
Zrb = (Zm -  2*sigma) : (sigma / 100) : (Zm + 2*sigma); 
pdfNormal = normpdf(Zrb, Zm, sigma);
%Plot-----------------------------
%hr1 = plot(Zrb, pdfNormal);%Active when run alone to visualize distribution
%hr1 = plot(Zrb, pdfNormal/max(pdfNormal));%test plot
%a =unifrnd(0,1);
%b =unifrnd(0,1);
%c =unifrnd(0,1);
%set(hr1,'color',[a b c]);
%set(hr1,'LineWidth',2);
%----------------------------------------
