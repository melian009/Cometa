
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

files = dir('*.csv');
num_files = length(files);
#results = cell(length(files), 1);
for i = 1:num_files
    #results{i} = dlmread(files(i).name)
    files(i).name
    Di = dlmread(files(i).name);
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
            if DIVK(k,1) <= 0.15;
               R = find(S(1,:) == U(k,1));
               S(R) = [];
            end
        end
        #DIVS(j,1) = sum(DIVK);#Diversity
        DIVS(j,1) = length(S);#Richness
    end  
DIVG(i,1) = sum(DIVS);
#pause
#migration :: 1st column
#gamma :: 2nd column
#diversity :: 3rd column
end

save rescuecoremo.txt DIVG

