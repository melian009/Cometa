
%h = ;%vector phi decreasing in additive genetic variance
Q=load('qmatriz.txt'); %direct
T=load('tmatriz.txt'); %indirect
for i = 1:58;
degree(i,1) = nnz(Q(i,:));
end


for i = 1:58;
TraitEvoDir(i,1) = sum(Q(i,:));
end

for i = 1:58;
TraitEvoIndir(i,1) = sum(T(i,:));
end

subplot(2,2,1)
plot(h,TraitEvoDir)
subplot(2,2,2)
plot(h,TraitEvoIndir)

plot(h,degree)




