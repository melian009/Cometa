mu = 0;
for t = 1;%traits
SRD = zeros(10,11,2);
    for i = 1:10;
        for j = 1:2;
            for s = 1;%Std
                Zi = -0.5*s:1e-1:0.5*s;%Tuning 2 changes initial S abundance  
                Zri = normpdf(Zi, mu, s);
                Zi = Zi + abs(min(Zi));%Move everything to the right.
                %SRD = zeros(i,length(Zi),j);
Zi
length(Zi)
                SRD(i,:,j) = Zi
pause
%Plotting trait distributions---
%hold on
%hr1 = plot(Zi,Zri);%Visualize
%a =unifrnd(0,1);
%b =unifrnd(0,1);
%c =unifrnd(0,1);
%set(hr1,'color',[a b c]);
%set(hr1,'LineWidth',2);
%-------------------------------
           end
        end
    end
end

