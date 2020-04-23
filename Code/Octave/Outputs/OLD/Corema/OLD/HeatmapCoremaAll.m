
#====================================================================================================
#https://wiki.octave.org/Dataframe_package
#https://stackoverflow.com/questions/32504203/install-octave-package-manually
#pkg load dataframe
%https://stackoverflow.com/questions/28407344/reading-text-number-mixed-csv-files-as-tables-in-octave
#====================================================================================================
pkg load io
#______________________________________________________________________________________
#https://stackoverflow.com/questions/11621846/loop-through-files-in-a-folder-in-matlab
#R=3;%Replicates
#count = 0;

# go to folders up the hierarchy:
#upUpFolder = fileparts(fileparts(pwd));
# go into another folder
#files = dir(fullfile('../','CoremaRES/*.csv'));
# do whatever you like
#files=dir('folder/*.csv')

#resources
#folder = uigetdir();
files = dir('./*.csv');

num_files = length(files);
#results = cell(length(files), 1);
for i = 1:num_files

    #results{i} = dlmread(files(i).name)
    #A = (files(i).name)

    IDX = strfind(files(i).name, "m0");
    templateM = 'm0';
    templateG = 'gamma';

#https://ch.mathworks.com/matlabcentral/answers/384583-how-to-extract-substring-from-string
indexmig1 = strfind(files(i).name, templateM) + length(templateM) - 1;
indexmig2 = strfind(files(i).name, '_g');
middleStringM = files(i).name(indexmig1:indexmig2-1);
#trim off any spaces if desired
#middleStringMig = strtrim(middleStringM)

indexgam1 = strfind(files(i).name, templateG) + length(templateG) - 1;
indexgam2 = strfind(files(i).name, '.c');
middleStringG = files(i).name(indexgam1+1:indexgam2-1);
#trim off any spaces if desired
#middleStringGam = strtrim(middleStringG)
#-------------------------------------------------------------------------------------------

    Di = dlmread(files(i).name);#Check
    #Di = readtable(files(i).name)#Check

    U = unique(Di);
    for j = 1:10;#sites
        D = zeros(1,1);DIV=zeros(1,1);DIVK=zeros(1,1);#DIVS=zeros(1,1);
        #Richness
        S = unique(Di(j,:));
        #Diversity
        for k = 1:length(U);
            D = find(Di(j,:) == U(k,1));    
            DIV = length(D)/(length(Di(j,:)));# * log(length(D)/length(Di(j,:)));
            DIVK(k,1) = DIV;
            if DIVK(k,1) <= 0.1;
               R = find(S(1,:) == U(k,1));
               S(R) = [];
            end
        end
        #DIVS(j,1) = sum(DIVK);#Diversity
        DIVS(j,1) = length(S);#Richness
    end  
DIVG(i,3) = sum(DIVS);#diversity :: 3rd column
DIVG(i,1) = str2double(middleStringM);#migration :: 1st column
DIVG(i,2) = str2double(middleStringG);#gamma :: 2nd column
#pause
end

#save rescuecoremaR.csv DIVG

#Heatmap
#HeatInput;#All
#rescuecoremaR;#RMODR
#rescuecoremaC;#RMODC

#HM = zeros(101,3);
#HM(:,1) = HI(:,1);
#HM(:,2) = HI(:,2);
#HM(:,3) = (RMODR(:,1)+RMODC(:,1))/100;

x = DIVG(:,1);
y = DIVG(:,2);
z = DIVG(:,3)/100;
n=length(x);


[X, Y] = meshgrid(linspace(min(x),max(x),n), linspace(min(y),max(y),n));
Z = griddata(x,y,z,X,Y);
colormap(jet)
imagesc (X, Y, Z)

xlabel('Migration','fontsize',16)
ylabel('Gamma','fontsize',16)
cb = colorbar; 
zlabel(cb,'Rescue')
title('Magic','fontsize',16)
#set(gca,'fontsize',6);
set(gca,'YDir','normal')

axis([min(x)+0.1 max(x)-0.1 min(y)+0.15 max(y)-0.1])
print -color -F:18 HeatmapCorema.pdf


#[X, Y] = meshgrid(linspace(min(x),max(x),n), linspace(min(y),max(y),n));
#Z = griddata(x,y,z,X,Y);
#// Remove the NaNs for imshow:
#Z(isnan(Z)) = 0;
#imshow(Z)


#m = min(Z(Z~=0));
#M = max(Z(Z~=0));
#imshow((Z-m)/(M-m));










