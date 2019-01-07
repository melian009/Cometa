%%%3. INITIAL SAMPLING BAD
SpatialMatrix;
SR = 10;SC = 10;%Species landscape
%Dm is the mean distance in the landscape obtained from SpatialMatrix
sigma = 10;
Zd = (Dm -  2*sigma) : (sigma / 100) : (Dm + 2*sigma); 
pdfNormal = normpdf(Zd, Dm, sigma);
%Plot----------------------------------
hr1 = plot(Zd, pdfNormal);%test plot
%hr1 = plot(Zd, pdfNormal/max(pdfNormal));%test plot
%a =unifrnd(0,1);
%b =unifrnd(0,1);
%c =unifrnd(0,1);
%set(hr1,'color',[a b c]);
%set(hr1,'LineWidth',2);
%----------------------------------------