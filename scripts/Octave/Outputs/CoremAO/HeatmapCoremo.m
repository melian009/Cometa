
#====================================================================================================
#https://wiki.octave.org/Dataframe_package
#https://stackoverflow.com/questions/32504203/install-octave-package-manually
#pkg load dataframe
%https://stackoverflow.com/questions/28407344/reading-text-number-mixed-csv-files-as-tables-in-octave
#====================================================================================================
pkg load io
#______________________________________________________________________________________
#https://stackoverflow.com/questions/11621846/loop-through-files-in-a-folder-in-matlab

#resources=============================================
files = dir('CoremoR*.csv');
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

    Di = dlmread(files(i).name);
    U = unique(Di);
    for j = 1:10;#sites
        D = zeros(1,1);DIV=zeros(1,1);DIVK=zeros(1,1);#DIVS=zeros(1,1);
        #Richness
        S = unique(Di(j,:));
        #Diversity
        for k = 1:length(U);
            D = find(Di(j,:) == U(k,1));    
            DIV = length(D)/(length(Di(j,:)));#* log(length(D)/length(Di(j,:)));
            DIVK(k,1) = DIV;
            if DIVK(k,1) <= 0.10;
               R = find(S(1,:) == U(k,1));
               S(R) = [];
            end
        end
        #DIVS(j,1) = sum(DIVK);#Diversity
        DIVS(j,1) = length(S);#Richness
    end  
DIVGro(i,3) = sum(DIVS);#diversity :: 3rd column
DIVGro(i,1) = str2double(middleStringM);#migration :: 1st column
DIVGro(i,2) = str2double(middleStringG);#gamma :: 2nd column
#pause
end
#======================================================

#Consumers========================================================
files = dir('CoremoC*.csv');
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

    Di = dlmread(files(i).name);
    U = unique(Di);
    for j = 1:10;#sites
        D = zeros(1,1);DIV=zeros(1,1);DIVK=zeros(1,1);#DIVS=zeros(1,1);
        #Richness
        S = unique(Di(j,:));
        #Diversity
        for k = 1:length(U);
            D = find(Di(j,:) == U(k,1));    
            DIV = length(D)/(length(Di(j,:)));#* log(length(D)/length(Di(j,:)));
            DIVK(k,1) = DIV;
            if DIVK(k,1) <= 0.10;
               R = find(S(1,:) == U(k,1));
               S(R) = [];
            end
        end
        #DIVS(j,1) = sum(DIVK);#Diversity
        DIVS(j,1) = length(S);#Richness
    end  
DIVGco(i,3) = sum(DIVS);#diversity :: 3rd column
DIVGco(i,1) = str2double(middleStringM);#migration :: 1st column
DIVGco(i,2) = str2double(middleStringG);#gamma :: 2nd column
#pause
end
#=====================================================================










