 
global SR sigma ro gamma

%%%3. INITIAL SAMPLING BAD
%SpatialMatrix;%Active when run alone
Zm = 50;%Zm is the mean abiotic trait value
%sigma = 1;
%ro = 1;
Zra = (Zm -  ro*sigma) : (sigma / 100) : (Zm + ro*sigma); 
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
