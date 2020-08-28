
global SR sigma ro gamma

%%%3. INITIAL SAMPLING BAD
%SpatialMatrix;%Active when run alone
%Dm is the mean distance in the landscape obtained from SpatialMatrix
%sigma = 10
D = mean(D);%Optimum dispersal value;Extract distribution from landscape values
mu = D; 
    sigmad = 2; 
    Zrd = (mu -  ro*sigmad) : (sigmad / 100) : (mu + ro*sigmad); 
    pdfNormal = normpdf(Zrd, Dm, sigmad);
%Plot----------------------------------
%hr1 = plot(Zrd, pdfNormal);%Active when run alone to visualize distribution
%hr1 = plot(Zrd, pdfNormal/max(pdfNormal));%test plot
%a =unifrnd(0,1);
%b =unifrnd(0,1);
%c =unifrnd(0,1);
%set(hr1,'color',[a b c]);
%set(hr1,'LineWidth',2);
%----------------------------------------