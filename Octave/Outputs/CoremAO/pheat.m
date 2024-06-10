HeatmapCoremo;
HeatmapCorema;

#---HeatmapCorema.m---------------------------
xa = DIVGra(:,1);
ya = DIVGra(:,2);
za = ((DIVGra(:,3) + DIVGca(:,3))/100);#12% less number of species

#zra = DIVGra(:,3);#Resources
#zca = DIVGca(:,3);#Consumers
na=length(xa);


#---HeatmapCoremo.m---------------------------
xo = DIVGro(:,1);
yo = DIVGro(:,2);
zo = (DIVGro(:,3) + DIVGco(:,3))/100;

#zro = DIVGro(:,3);#Resources
#zco = DIVGco(:,3);#Consumers
no=length(xo);

#====================================================


#Resources + Consumers Coremo====================================================
[X, Y] = meshgrid(linspace(min(xo),max(xo),no), linspace(min(yo),max(yo),no));
Z = griddata(xo,yo,zo,X,Y);

#colorMap = jet(128);
#colormap(colorMap);   % Apply the colormap
#colorbar;

colormap(jet)

subplot(2,2,1)
#cm = jet(100);cm(1:end,:)=[];colormap(cm)
imagesc (X, Y, Z)


axis([min(xo)+0.12 max(xo)-0.12 min(yo)+0.15 max(yo)-0.15])
c2 = caxis;
#c2 = [0.86, 0.9];

xlabel('Migration','fontsize',12)
ylabel('Gamma','fontsize',12)
cb = colorbar; 
zlabel(cb,'Rescue')
title('Modular','fontsize',12)
#set(gca,'fontsize',6);
set(gca,'YDir','normal')
#====================================================================
#Consumers Coremo
#[Xc, Yc] = meshgrid(linspace(min(xo),max(xo),no), linspace(min(yo),max(yo),no));
#Zc = griddata(xo,yo,zco,Xc,Yc);
#colormap(cm)
#contourf(peaks)
#subplot(2,2,2)
#imagesc (Xc, Yc, Zc)
#axis([min(xo)+0.1 max(xo)-0.1 min(yo)+0.15 max(yo)-0.1])

#xlabel('Migration','fontsize',10)
#ylabel('Gamma','fontsize',10)
#cb = colorbar; 
#zlabel(cb,'Rescue')
#title('Modular Consumers','fontsize',10)
#set(gca,'fontsize',6);
#set(gca,'YDir','normal')
#===================================================================



#Resources Corema=======================================================
[X, Y] = meshgrid(linspace(min(xa),max(xa),na), linspace(min(ya),max(ya),na));
Z = griddata(xa,ya,za,X,Y);

#caxis([1 70])
subplot(2,2,2)

#cma = jet(100);cma(end-20:end,:)=[];colormap(cma)
imagesc (X, Y, Z)

axis([min(xa)+0.12 max(xa)-0.12 min(ya)+0.15 max(ya)-0.15])

c1 = caxis;
c3 = [min([c1 c2]), max([c1 c2])];
#c3 = [0.86,0.9];
caxis(c3)
#pause

xlabel('Migration','fontsize',12)
ylabel('Gamma','fontsize',12)
cb = colorbar; 
zlabel(cb,'Rescue')
title('Magic','fontsize',12)
#set(gca,'fontsize',6);
set(gca,'YDir','normal')
colorbar('off')
#=======================================================================
#Consumers Corema
#[Xc, Yc] = meshgrid(linspace(min(xa),max(xa),na), linspace(min(ya),max(ya),na));
#Zc = griddata(xa,ya,zca,Xc,Yc);
#colormap(cm)
#contourf(peaks)
#subplot(2,2,4)
#imagesc (Xc, Yc, Zc)
#axis([min(xa)+0.1 max(xa)-0.1 min(ya)+0.15 max(ya)-0.1])

#xlabel('Migration','fontsize',10)
#ylabel('Gamma','fontsize',10)
#cb = colorbar; 
#zlabel(cb,'Rescue')
#title('Magic Consumers','fontsize',10)
#set(gca,'fontsize',6);
#set(gca,'YDir','normal')
#======================================================


#final
#[X, Y] = meshgrid(linspace(min(x),max(x),n), linspace(min(y),max(y),n));
#Z = griddata(x,y,z,X,Y);
#colormap(jet)
#imagesc (X, Y, Z)

#print -color -F:12 Heatmap.pdf









