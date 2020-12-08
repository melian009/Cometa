
HeatInput;
rescuecoremo;

HM = zeros(130,3);
HM(:,1) = HI(:,1);
HM(:,2) = HI(:,2);
HM(:,3) = RMOD(:,1);
n=130;

x = HM(:,1);
y = HM(:,2);
z = HM(:,3);


#test---
#a1=[225.512 2.64537 0.00201692
#225.512  2.64537 0.00201692
#226.94   1.59575 0.00225557
#226.94   1.59575 0.00225557
#227.31   1.70513 0.002282
#227.31   1.70513 0.002282
#227.729  5.34308 0.00205535
#227.729  5.34308 0.00205535
#227.975  5.12741 0.001822
#227.975  5.12741 0.001822]
#x = a1(:,1);
#y = a1(:,2)
#z = a1(:,3)
#n = 10;
[X, Y] = meshgrid(linspace(min(x),max(x),n), linspace(min(y),max(y),n));
Z = griddata(x,y,z,X,Y);


#[X, Y] = meshgrid(linspace(min(x),max(x),n), linspace(min(y),max(y),n));
#Z = griddata(x,y,z,X,Y);
#// Remove the NaNs for imshow:
Z(isnan(Z)) = 0;
imshow(Z)


m = min(Z(Z~=0));
M = max(Z(Z~=0));
imshow((Z-m)/(M-m));
