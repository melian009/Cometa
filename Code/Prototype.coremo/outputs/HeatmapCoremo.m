%=============================================================
%COevolutionary MUtualistic NEtworks in Space (COMUNES) 
%Gilarranz and Melian @EAWAG (started NOV 2018)
%=============================================================

%---------------------------------GOAL--------------------------------------
%Plot covariance matrix from coevolutionary selection scenario
%---------------------------------------------------------------------------

%CHECK 0:
%------------------------------SCENARIOS----------------------------------------
%Sampling distributions from independent observed abundances and matching across all pairs per site
%Sampling distributions from the empirical abundances and matching across all pairs per site:

%Both scenarios -- extract total abundance plants-pollinators observed per site and use as input
%-------------------------------------------------------------------------------
%CHECK 1:fully connected >  ... iim proxy landscape fragmentation, tune m


%%%0. INPUT DATA (Modified from Luisjo matlab code Extract_Correlation...m to octave) 
%==========================================================================
%https://wiki.octave.org/Dataframe_package
%https://stackoverflow.com/questions/32504203/install-octave-package-manually
pkg load dataframe
%https://stackoverflow.com/questions/28407344/reading-text-number-mixed-csv-files-as-tables-in-octave
data = dataframe ("CoremoC_m0.8059_gamma2.188259e+00.csv");