
global SR sigma ro gamma

%%%3. INITIAL SAMPLING BAD
%SpatialMatrix;%Active when run alone
%SR = 10;%#Resource species landscape
Zmr = 2;%Mean biotic trait of resource species
sigmar = 12;
Zrb = (Zmr -  ro*sigmar) : (sigmar / 100) : (Zmr + ro*sigmar); 
pdfNormal = normpdf(Zrb, Zmr, sigmar);
%Plot-----------------------------
%hr1 = plot(Zrb, pdfNormal);%Active when run alone to visualize distribution
%hr1 = plot(Zrb, pdfNormal/max(pdfNormal));%test plot
%a =unifrnd(0,1);
%b =unifrnd(0,1);
%c =unifrnd(0,1);
%set(hr1,'color',[a b c]);
%set(hr1,'LineWidth',2);
%----------------------------------------
