
#====================================================================================================
#https://wiki.octave.org/Dataframe_package
#https://stackoverflow.com/questions/32504203/install-octave-package-manually
#pkg load dataframe
%https://stackoverflow.com/questions/28407344/reading-text-number-mixed-csv-files-as-tables-in-octave
#====================================================================================================
#CoremoC_m0.0022_gamma9.98088.csv   CoremoC_m0.4933_gamma3.08838.csv   CoremoC_m0.7785_gamma2.3052.csv	CoremoR_m0.3900_gamma9.62659.csv   CoremoR_m0.6920_gamma6.28553.csv
#CoremoC_m0.0600_gamma8.21914.csv   CoremoC_m0.5405_gamma0.852437.csv  CoremoC_m0.8213_gamma7.65219.csv	CoremoR_m0.3927_gamma7.22659.csv   CoremoR_m0.7007_gamma2.49781.csv
#CoremoC_m0.1074_gamma3.14027.csv   CoremoC_m0.5420_gamma7.05378.csv   CoremoC_m0.9321_gamma5.88505.csv	CoremoR_m0.4630_gamma0.634339.csv  CoremoR_m0.7121_gamma8.88714.csv
#CoremoC_m0.1094_gamma3.77733.csv   CoremoC_m0.6018_gamma5.98077.csv   CoremoC_m0.9673_gamma8.64148.csv	CoremoR_m0.4748_gamma6.1504.csv    CoremoR_m0.7269_gamma2.3912.csv
#CoremoC_m0.1315_gamma9.3601.csv    CoremoC_m0.6504_gamma9.12065.csv   CoremoR_m0.0022_gamma9.98088.csv	CoremoR_m0.4933_gamma3.08838.csv   CoremoR_m0.7785_gamma2.3052.csv
#CoremoC_m0.1872_gamma1.09161.csv   CoremoC_m0.6728_gamma8.10257.csv   CoremoR_m0.0600_gamma8.21914.csv	CoremoR_m0.5405_gamma0.852437.csv  CoremoR_m0.8213_gamma7.65219.csv
#CoremoC_m0.3900_gamma9.62659.csv   CoremoC_m0.6920_gamma6.28553.csv   CoremoR_m0.1074_gamma3.14027.csv	CoremoR_m0.5420_gamma7.05378.csv   CoremoR_m0.9321_gamma5.88505.csv
#CoremoC_m0.3927_gamma7.22659.csv   CoremoC_m0.7007_gamma2.49781.csv   CoremoR_m0.1094_gamma3.77733.csv	CoremoR_m0.6018_gamma5.98077.csv   CoremoR_m0.9673_gamma8.64148.csv
#CoremoC_m0.4630_gamma0.634339.csv  CoremoC_m0.7121_gamma8.88714.csv   CoremoR_m0.1315_gamma9.3601.csv	CoremoR_m0.6504_gamma9.12065.csv   CoremoC_m0.4748_gamma6.1504.csv    CoremoC_m0.7269_gamma2.3912.csv    CoremoR_m0.1872_gamma1.09161.csv	CoremoR_m0.6728_gamma8.10257.csv


#______________________________________________________________________________________
#https://stackoverflow.com/questions/11621846/loop-through-files-in-a-folder-in-matlab
#R=3;%Replicates
#count = 0;
#files = dir('*.csv');
#for file = files'
#    csv = load(file.name)
   csv = load("CoremoCm0.0022gamma9.98088.csv");
   U = unique(csv);
   for i = 1:10;
       for j = 1:length(U);
           D(j,1) = find(csv(i,:) == U(j,1));
           Di(i,j) = (length(D(j,1))/length(csv(i,:)))*log((length(D(j,1))/length(csv(i,:))));
       end
   end    

   #P(i,1) = 0.0022;
   #P(i,2) = 0.98088;
   #P(i,3) = p*log(p)
    #for i = 1:R;
    #    q = unique(csv(9+i,:));#Check 9!
    #    q = size(q);
    #end
    
    #count = count + 1;
    #Q(count,1) = mean(q);
#end
#______________________________________________________________________________________

#Not used
#______________________________________________________
#data = dataframe("CoremoC_m0.0984_gamma6.32925.csv");
#______________________________________________________

