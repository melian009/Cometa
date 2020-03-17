
#====================================================================================================
#https://wiki.octave.org/Dataframe_package
#https://stackoverflow.com/questions/32504203/install-octave-package-manually
#pkg load dataframe
%https://stackoverflow.com/questions/28407344/reading-text-number-mixed-csv-files-as-tables-in-octave
#====================================================================================================


#______________________________________________________________________________________
#https://stackoverflow.com/questions/11621846/loop-through-files-in-a-folder-in-matlab
R=3;%Replicates
count = 0;
files = dir('*.csv');
for file = files'
    csv = load(file.name);
    for i = 1:R;
        q = unique(csv(9+i,:));#Check 9!
        q = size(q);
    end
    
    count = count + 1;
    Q(count,1) = mean(q);
end
#______________________________________________________________________________________

#Not used
#______________________________________________________
#data = dataframe("CoremoC_m0.0984_gamma6.32925.csv");
#______________________________________________________

