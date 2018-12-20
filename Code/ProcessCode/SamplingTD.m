%1. Initial trait distributions
mu = 0;%Mean

for i = 1:3
for s = i;%Extend n-species:0.5:20;
r1 = -2*s:1e-1:2*s;  
yr1 = normpdf(r1, mu, s);
r1 = r1 + abs(min(r1));% Move everything to the right.
hold on
hr1 = plot(r1,yr1);%Visualize
a =unifrnd(0,1);
b =unifrnd(0,1);
c =unifrnd(0,1);
set(hr1,'color',[a b c]);
set(hr1,'LineWidth',2);
end
end


%for s = 1:0.5:2;%Extend n-species:0.5:2;
%p1 = -3*s:1e-1:3*s;  %smaller 5e-1
%yp1 = normpdf(p1, mu, s);
%p1 = p1 + abs(min(p1));% Move everything to the right.
%end



%2. Compute W each phenotype
%for gamma = 1:10;
%  Wr = zeros(length(r1));
%for i = 1:length(r1); 
%     r1(1,i);
%     mean(r1);
%     Wr(i,2) = abs(1/(1 + e^gamma*(r1(1,i) - mean(r1))^2));
     %Wr(i,2) = abs(e^gamma*((r1(1,i) - mean(r1)))^2);
%     Wr(i,1) = abs(r1(1,i) - mean(r1));
%end
%hold on
%ax = plotyy (p1, yp1, Wr(:,1), Wr(:,2));
%set(ax,'LineWidth',2);
%xlabel('Trait Value/W decay with distance to mean','fontsize', 16)
%ylabel(ax(2),'Frequency','fontsize', 16)
%ylabel(ax(1),'W','fontsize', 16)
%end
