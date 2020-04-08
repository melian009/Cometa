
HeatInput;#All
rescuecoremoR;#RMODR
rescuecoremoC;#RMODC

HM = zeros(130,3);
HM(:,1) = HI(:,1);
HM(:,2) = HI(:,2);
HM(:,3) = (RMODR(:,1)+RMODC(:,1))/100;
n=130;

x = HM(:,1);
y = HM(:,2);
z = HM(:,3);

[X, Y] = meshgrid(linspace(min(x),max(x),n), linspace(min(y),max(y),n));
Z = griddata(x,y,z,X,Y);
colormap(jet)
imagesc (X, Y, Z)

xlabel('Migration')
ylabel('Gamma')
cb = colorbar; 
zlabel(cb,'Rescue')
title('Modular')
 

#[X, Y] = meshgrid(linspace(min(x),max(x),n), linspace(min(y),max(y),n));
#Z = griddata(x,y,z,X,Y);
#// Remove the NaNs for imshow:
#Z(isnan(Z)) = 0;
#imshow(Z)


#m = min(Z(Z~=0));
#M = max(Z(Z~=0));
#imshow((Z-m)/(M-m));
