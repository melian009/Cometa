count = 0;
for i = 1:58;
count = count + 0.025;
h(i,1) = (1 - e^-count);
end
h = sort(h, "descend");