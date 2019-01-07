%%%3. INITIAL SAMPLING BAD
%SpatialMatrix;%Active when run alone
SR = 10;%Species landscape
%Dm is the mean distance in the landscape obtained from SpatialMatrix
sigma = 10;
Zrd = (Dm -  2*sigma) : (sigma / 100) : (Dm + 2*sigma); 
pdfNormal = normpdf(Zrd, Dm, sigma);
%Plot----------------------------------
%hr1 = plot(Zrd, pdfNormal);%Active when run alone to visualize distribution
%hr1 = plot(Zrd, pdfNormal/max(pdfNormal));%test plot
%a =unifrnd(0,1);
%b =unifrnd(0,1);
%c =unifrnd(0,1);
%set(hr1,'color',[a b c]);
%set(hr1,'LineWidth',2);
%----------------------------------------