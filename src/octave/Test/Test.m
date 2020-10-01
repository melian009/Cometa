mu = 0;
%Resource
   for s = 3.35;%Std
                Zr = -1.5*s:1e-1:1.5*s;%Tuning s or 0.5 changes initial S abundance  
                ZrB = normpdf(Zr, mu, s);%Frequency each phenotype
                Zr = Zr + abs(min(Zr));%Move everything to the right.
                SRB = repmat(Zr, [10,1,10]);
%Plotting trait distributions---
%hold on
subplot(3,2,5)
hr1 = plot(Zr,ZrB);%Visualize
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr1,'color',[a b c]);
set(hr1,'LineWidth',2);
end
%-------------------------------

%Consumer
   for s =3.35;%Std
                Zc = -1.5*s:1e-1:1.5*s;%Tuning s or 0.5 changes initial S abundance  
                ZrC = normpdf(Zc, mu, s);%Frequency each phenotype
                Zc = Zc + abs(min(Zc));%Move everything to the right.
                SCB = repmat(Zc, [10,1,10]);
%Plotting trait distributions---
%hold on
hold on
hr2 = plot(Zc,ZrC);%Visualize
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr2,'color',[a b c]);
set(hr2,'LineWidth',2);
  end
  
gamma = 0;
for pB = 1:length(Zr);
WB(pB,2) = exp(-gamma*(Zr(1,pB) - mean(Zc))^2);
WB(pB,1) = Zr(1,pB) - mean(Zc);
end
subplot(3,2,6)
hr1 = plot(WB(:,1),WB(:,2));%Visualize
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr1,'color',[a b c]);
  