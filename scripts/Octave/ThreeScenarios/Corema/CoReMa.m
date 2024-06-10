%=================================================================
%Coevolutionary rescue in ecological networks
%Coevolutionary biodiversity rescue in multitrait landscapes (alt)
%BAD Modular scenario
%Andreazzi, Astegiano and Melian @EAWAG DEC 2018
%Updated @Mallorca FEB-MAR 2020
%=================================================================

%---------------------------------GOAL--------------------------------------
%Plot heat map Coevolutionary rescue in gradient disper vs. coevol selection
%---------------------------------------------------------------------------

clear;%seed=17;rng(seed);%depending running matlab or octave
pkg load statistics
MaxRep = 25;%number of replicates
for r = 1:MaxRep;%tic -- #replicates  
  
         %=====MIGRATION AND COEVOLUTIONARY SELECTION GRADIENT============
         m=unifrnd(0,1);%gradient migration rate
         gamma = unifrnd(0,10);%gradient strength coevo selection
         %-----OUTPUTS--------------------------------------------------------------
         fnamR = sprintf('CoremaR_m%0.4f_gamma%04d',m,gamma);
         fnamC = sprintf('CoremaC_m%0.4f_gamma%04d',m,gamma);
         migration = sprintf('migration_m%0.4f',m);
         coevgamma = sprintf('gamma_gamma%04d',gamma);
         fnamDistanceMatrix = sprintf('CoremaDM_m%0.4f_gamma%04d',m,gamma);
         %==========================================================================
  
%%%1. FIXED PARAMETERS===========================================
  MaxG = 30; %number of generations per replicates
  nua=0.001;%rate phenotypic change
  nub=-0.001;%rate phenotypic change
  SR = 5;SC = 5;%Initial species in landscape
%================================================================
  
%%%2. SPATIAL MATRIX========================================================
  %We will use random geometric graphs (RGG) in homogeneous landscapes:
  %Each species have the same abiotic optima across al sites. As discussed, 
  %the alternative can be to explore an heterogeneous gradient: Each species
  %a different abiotic optima across in each site.
  %=========================================================================
  
  L= 100;%size of the landscape 1000
  P = 10;%number of sites 10
  n = unifrnd(0,L,P,2);%two coordinates each sites
  Pd = zeros(P,P);
  Pdmean = zeros(P,P);
  for i = 1:P,
      for j = i+1:P,
          dx2 = (n(i,1) - n(j,1))^2;%Euclidean distance
          dy2 = (n(i,2) - n(j,2))^2;
          d(i,j) = sqrt(dx2 + dy2);%distance matrix
          Pd(i,j) = 1/d(i,j);
          %==================================================================
          %the lower the distance between i and j the higher the probability
          %to move individuals between them
          %==================================================================        
          Pdmean(i,j) = d(i,j);%mean distance across all pairs of sites
      end
  end 
  Pd(P,P) = 0;
  Pdmean=Pdmean+Pdmean';
  D = nonzeros(triu(Pdmean,1));
  Dm = mean(D);%Optimum dispersal value for the dispersal trait comparison
  Pd=Pd+Pd';
  Pdf = sinkhornKnopp(Pd);%Symmetric migration foll. double stochastic matrix
  P_ij = cumsum(Pdf,2);
  P_ji = cumsum(Pdf,1);
  %===========================================================================
 
%%%3. INITIAL SAMPLING BAD traits=============================================
%Modular -- P patches -- abundance N each sp -- SR number resource species
%1. sampling 3 distributions independently for each resource and consumer sp.
%2. same N but different trait values for each species in each site
%=============================================================================

%Initial Carrying capacity per site ++++++++++++++++++++++++++++++++++++++++++++++++++
Z=round(unifrnd(6,10));%arbitrary boundary values for the trait
sigma = 0.5;ro = 0.5;%mean & var initial trait distribution
Len = (Z -  ro*sigma) : (sigma / 100) : (Z + ro*sigma);%initial abundance each species
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%Resources=====================================================================

for i = 1:P;%loop sites
    for j = 1:SR;%loop resource species   
        %Sampling biotic trait=========================================================
        Zmr=round(unifrnd(1,4));%initial mean biotic trait
        sigmar = 12;%initial variance biotic trait
        Zrb(j,1:length(Len)) = (Zmr -  ro*sigmar) : (sigmar / 100) : (Zmr + ro*sigmar);
        SBR(j,1:length(Len)) = j;%track number of resource species
        %==============================================================================

        
%============Magic trait scenario====================================
%generates a biotic trait first and then uses the correlation matrix
%to sample the abiotic and the dispersal trait 
%==================================================================== 

%RESOURCES______________________________________________________________________
%https://stats.stackexchange.com/questions/120179/generating-data-with-a-given-sample-covariance-matrix    
N = size(Len);%Initial pop size
d=3;
Sigma = [1 0.7 0.7;0.7 1 0;0.7 0 1];%desired trait cov matrix

%Test
%X = randn(N(1,2), d) * chol(Sigma);
%size(X);
%cov(X);

%Sampling from covariance biotic for the abiotic and the dispersal 
%Sampling biotic
stdB = std(Zrb(j,:));meanB = Zmr;
B = (stdB.*randn(N(1,2),1) + meanB);
X(:,1) = B;

%Sampling abiotic trait ================================================
Zm = round(unifrnd(45,55));%initial mean abiotic trait
sigmaa = 10;%initial variance abiotic trait
Zra(j,1:length(Len)) = (Zm -  ro*sigmaa) : (sigmaa / 100) : (Zm + ro*sigmaa); 
stdA = std(Zra(j,:));meanA = Zm;
A = (stdA.*randn(N(1,2),1) + meanA);
X(:,2) = A;

%Sampling dispersal trait=======================================================
mu = mean(D);%optimum dispersal value obtained from all pairwise distance values
sigmad = 2;%initial variance dispersal trait
Zrd(j,1:length(Len)) = (mu -  ro*sigmad) : (sigmad / 100) : (mu + ro*sigmad); 
stdM = std(Zrd(j,:));meanM = mu;
Di = (stdM.*randn(N(1,2),1) + meanM);
X(:,3) = Di;
%cov(X)

%Normalized--------------------
X = bsxfun(@minus, X, mean(X));
X = X * inv(chol(cov(X)));
X = X * chol(Sigma);
%cov(X)%Matches desired cov matrix Sigma

%Transform to desired mean and std for B, A, and M
  X(:,1) = meanB + (X(:,1) - mean(X(:,1))) * (stdB/std(X(:,1)));
  X(:,2) = meanA + (X(:,2) - mean(X(:,2))) * (stdA/std(X(:,2)));
  X(:,3) = meanM + (X(:,3) - mean(X(:,3))) * (stdM/std(X(:,3)));
%cov(X)
%pause
Zrb(j,1:length(Len)) = X(:,1)';
Zra(j,1:length(Len)) = X(:,2)';
Zrd(j,1:length(Len)) = X(:,3)';

%______________________________________________________________________
      
    end
    %===========Site-resource species-trait-matrix========================
    %This matrix tracks all individuals per site and trait distributions.
    %Each site is at its carrying capacity
    %=====================================================================
    %site i ... trait j species k (zijk,...)
    %...
    %...
    %=====================================================================
    NBR(i,1:SR*length(Len)) = reshape(Zrb.',1,[]);%biotic trait 
    NAR(i,1:SR*length(Len)) = reshape(Zra.',1,[]);%abiotic trait
    NDR(i,1:SR*length(Len)) = reshape(Zrd.',1,[]);%dispersal trait
    RS(i,1:SR*length(Len)) = reshape(SBR.',1,[]);%sp. ID resource vector
end
%==============================================================================


%CONSUMERS=====================================================================
for i = 1:P;%loop sites
    for j = 1:SC;%loop consumer species   
        %Sampling biotic trait=========================================================
        Zmc=round(unifrnd(1,4));%initial mean biotic trait
        sigmar = 12;%initial variance dispersal trait
        Zcb(j,1:length(Len)) = (Zmc -  ro*sigmar) : (sigmar / 100) : (Zmc + ro*sigmar);
        SBC(j,1:length(Len)) = SR + j;%track total number of species res + consumer
        %==============================================================================


%RESOURCES______________________________________________________________________
%https://stats.stackexchange.com/questions/120179/generating-data-with-a-given-sample-covariance-matrix    
N = size(Len);%Initial pop size
d=3;
Sigma = [1 0.7 0.7;0.7 1 0;0.7 0 1];%desired trait cov matrix

%Test
%X = randn(N(1,2), d) * chol(Sigma);
%size(X);
%cov(X);

%Sampling from covariance biotic for the abiotic and the dispersal 
%Sampling biotic
stdB = std(Zcb(j,:));meanB = Zmc;
B = (stdB.*randn(N(1,2),1) + meanB);
X(:,1) = B;

%Sampling abiotic trait ================================================
Zm = round(unifrnd(45,55));%initial mean abiotic trait
sigmaa = 10;%initial variance abiotic trait
Zca(j,1:length(Len)) = (Zm -  ro*sigmaa) : (sigmaa / 100) : (Zm + ro*sigmaa); 
stdA = std(Zca(j,:));meanA = Zm;
A = (stdA.*randn(N(1,2),1) + meanA);
X(:,2) = A;

%Sampling dispersal trait=======================================================
mu = mean(D);%optimum dispersal value obtained from all pairwise distance values
sigmad = 2;%initial variance dispersal trait
Zcd(j,1:length(Len)) = (mu -  ro*sigmad) : (sigmad / 100) : (mu + ro*sigmad); 
stdM = std(Zcd(j,:));meanM = mu;
Di = (stdM.*randn(N(1,2),1) + meanM);
X(:,3) = Di;
%cov(X)

%Normalized--------------------
X = bsxfun(@minus, X, mean(X));
X = X * inv(chol(cov(X)));
X = X * chol(Sigma);
%cov(X)%Matches desired cov matrix Sigma

%Transform to desired mean and std for B, A, and M
  X(:,1) = meanB + (X(:,1) - mean(X(:,1))) * (stdB/std(X(:,1)));
  X(:,2) = meanA + (X(:,2) - mean(X(:,2))) * (stdA/std(X(:,2)));
  X(:,3) = meanM + (X(:,3) - mean(X(:,3))) * (stdM/std(X(:,3)));
%cov(X)
%pause
Zcb(j,1:length(Len)) = X(:,1)';
Zca(j,1:length(Len)) = X(:,2)';
Zcd(j,1:length(Len)) = X(:,3)';

%______________________________________________________________________
      
    end
    %===========Site-resource species-trait-matrix========================
    %This matrix tracks all individuals per site and trait distributions.
    %Each site is at its carrying capacity
    %=====================================================================
    %site i ... trait j species k (zijk,...)
    %...
    %...
    %=====================================================================
    NBC(i,1:SC*length(Len)) = reshape(Zcb.',1,[]);%biotic trait 
    NAC(i,1:SC*length(Len)) = reshape(Zca.',1,[]);%abiotic trait
    NDC(i,1:SC*length(Len)) = reshape(Zcd.',1,[]);%dispersal trait
    CS(i,1:SC*length(Len)) = reshape(SBC.',1,[]);%sp. ID resource vector
end
%==============================================================================


%%%4. MAIN==============================================================
         for j = 1:MaxG;%# generations per replicate
             for t = 1:length(Zrb)*SR*P + length(Zcb)*SC*P;
                 %==============GENERATION======================================
                 %one generation equals total #individuals in the landscape
                 %zero-sum dynamics: never empty sites == #individuals landscape
                 %============================================================== 
               
                 %==========TRAIT DRIVEN DEMOGRAPHY============================
                 %--------------------Death----------------------------
                 KillHab = unidrnd(P);%random selection site
                 W = cat(2, unique(RS(KillHab,:)),unique(CS(KillHab,:)));
 	         KillSp = randelement(W,1);%random selection species ID
                 %========================================================
                 %Simultaneous resource and consumer dynamics 
                 %KillSp selects randomly a resource or consumer species ID
                 %========================================================
                 %Change here
                 KillIndR = find(RS(KillHab,:) == KillSp);%list inds species ID                  
                 KillIndC = find(CS(KillHab,:) == KillSp);%list species 

                 if ~isempty(KillIndR && KillIndC);
                    if KillSp <= SR;
                       KillInd = find(RS(KillHab,:) == KillSp);%list inds species ID
                                    
                 %W===MODULAR==================================
                 %equal contribution to W each trait resources
                 %=============================================
                 
                 %Fitness, W Abiotic======================================
                 %Obtain optimal abiotic mean from population at each time
                 %--------------------------------------------------------
                 munewR = mean(NAR(KillHab,KillInd));
                 
                 %Abiotic Calculate fitness each individual, W, ===============================
                 WA = zeros(1,length(KillInd));
                 for p = 1:length(KillInd);
                     WA(1,p) = exp(-gamma*(NAR(KillHab,KillInd(1,p)) - munewR)^2);
                     %WA(2,pA) = Zra(1,pA) - munewR;%Distance to mean for visualization
                 end
                 %=====================================================================
                 WD = zeros(1,length(KillInd));
                 %W Dispersal====================================================

                 for p = 1:length(KillInd);
                     WD(1,p) = exp(-gamma*(NDR(KillHab,KillInd(1,p)) - mu)^2);
                     %WD(pD,1) = Zi(1,pD) - D;%Distance to mean for visualization
                 end
                 %===============================================================
               
                 %W Biotic=================================================================================
                 WB = zeros(1,length(KillInd));
                 for p = 1:length(KillInd);
                     WB(1,p) = 1/(1 + exp(-gamma*(NBR(KillHab,KillInd(1,p)) - mean(NBC(KillHab,:)))^2));
                     %WB(pB,1) = Zrb(1,pB) - mean(Zcb);%Distance to mean for visualization
                 end
                 %=========================================================================================
               
                 %W each individual species ID to obtain probability to die============== 
                 DieWBADR = length(KillInd);
                 DieWBADR = 1./(WB+0.001);%Avoid Infty         
                 Kill = cumsum(DieWBADR);
                 K = unifrnd(0,max(Kill));
                 KI = find(K <= Kill);%1st in the KI list is the dying ind
                 %Kill(KI(1,1));%Ind to replace from                  
                 else
                     KillInd = find(CS(KillHab,:) == KillSp);%list species ID
                 
                 %W===MODULAR =======================================
                 %equal contribution to W each trait consumers
                 %===================================================
                 
                 %Fitness, W Abiotic===================================
                 munewC = mean(NAC(KillHab,KillInd));%Check KillInd
                 
                 %Calculate fitness each individual, W=================================
                 WA = zeros(1,length(KillInd));
                 for p = 1:length(KillInd);
                     WA(1,p) = exp(-gamma*(NAC(KillHab,KillInd(1,p)) - munewC)^2);
                     %WA(pA,1) = Zca(1,pA) - munewC;%Distance to mean for visualization
                 end
                 %=====================================================================
               
                 %W Dispersal====================================================
                 WD = zeros(1,length(KillInd));
                 for p = 1:length(KillInd);
                     WD(1,p) = exp(-gamma*(NDC(KillHab,KillInd(1,p)) - mu)^2);
                     %WD(pD,1) = Zi(1,pD) - D;%Distance to mean for visualization
                 end
                 %===============================================================
                 
                 %W Biotic========================================================================
                 WB = zeros(1,length(KillInd));
                 for p = 1:length(KillInd);
                     WB(1,p) = exp(-gamma*(NBC(KillHab,KillInd(1,p)) - mean(NBR(KillHab,:)))^2);
                     %WB(pB,1) = Zrb(1,pB) - mean(Zcb);%Distance to mean for visualization
                 end
                 %================================================================================
               
                 %W each individual to obtain probability to die
                 DieWBADC = length(KillInd);
                 DieWBADC = 1./(WB + 0.001);        
                 Kill = cumsum(DieWBADC);
                 K = unifrnd(0,max(Kill));
                 KI = find(K <= Kill);%1st in the KI list is the dying ind
                end %KillSp      
              %==========================================================
              
              
              %Second step trait DEMOGRAPHY: ================================
              %replace death ind by local birth or by migration
              %==============================================================
                              

                 ep=unifrnd(0,1,1);%event probability to have local birth or migration
                 if ep <= m,%we have a migration event
                   
                    %Loop to select from which site we choose the migrant=======
                    MHP = unifrnd(0,1);
                    if MHP >= P_ij(KillHab,KillHab);
                       MigrantHab = find(P_ij(KillHab,:) >= MHP,1);
                    else
                       MigrantHab = find(P_ji(:,KillHab) >= MHP,1);
                    end                                                      
                     
                    if numel(MigrantHab)>0,%habitat exists
                       if KillSp <= SR;%if death was R, then migration belongs to R
                         
                          %Choose randomly species from unique ID in MigrantHab
                          UMigrant = randelement(unique(RS(MigrantHab,:)),1);
                          
                          %Compute list individuals from randomly chosen species
                          MigInd = find(RS(MigrantHab,:) == UMigrant);%list inds species ID
                          if ~isempty(MigInd); 
                             
                          %W Dispersal=======================================================
                          WD = zeros(1,length(MigInd));
                          %Individual-ID from migrant can be different to the death-ID
                          for p = 1:length(MigInd);
                              WD(1,p) = exp(-gamma*(NDR(MigrantHab,MigInd(1,p)) - mu)^2);
                              %WD(pDm,1) = Zi(1,pD) - D;%Distance to mean for visualization
                          end
                          %==================================================================
                          
                          %===REPLACEMENT====================================================================
                          %Replace the migrant in the local habitat from individual with highest W species ID
                          MigWDR = 1./WD;         
                          Mig = cumsum(MigWDR);
                          M = unifrnd(0,max(Mig));
                          MI = find(M <= Mig);%1st in the MI list is the migrating ind
                          %MI(1,1);Ind to replace the death ind
                          SP = RS(MigrantHab,MigInd(1,MI(1,1)));
                          
                          %Replace trait value old ind with new trait value migrant for the BAD
                          NDR(KillHab,KillInd(1,KI(1,1))) = NDR(MigrantHab,SP);%dispersal trait
                          NBR(KillHab,KillInd(1,KI(1,1))) = NBR(MigrantHab,SP);%biotic trait
                          NAR(KillHab,KillInd(1,KI(1,1))) = NAR(MigrantHab,SP);%abiotic trait
                          
                          %Replace old ID with new ID migrant
                          RS(KillHab,KillInd(1,KI(1,1))) = SP;
                          end%~isempty(MigInd);

%Test___________________________
%Maa = MigrantHab
%Species = SP
%Maaa = MigInd(1,MI(1,1))
%A = RS(KillHab,KillInd(1,KI(1,1)))
%pause
%________________________________
                          %==================================================================================
                     
                     
                       else %if death was C, then migration belongs to C
                       
                          %Choose randomly species in MigrantHab
                          UMigrant = randelement(unique(CS(MigrantHab,:)),1);
                          
                          %Calculate W dispersal trait randomly chosen species
                          MigInd = find(CS(MigrantHab,:) == UMigrant);%list inds species ID
                          if ~isempty(MigInd);

                          %W Dispersal=======================================================
                          %Individual-ID from migrant can be different to the death-ID
                          WD = zeros(1,length(MigInd));
                          for p = 1:length(MigInd);
                              WD(1,p) = exp(-gamma*(NDC(MigrantHab,MigInd(1,p)) - mu)^2);
                              %WD(pDm,1) = Zi(1,pD) - D;%Distance to mean for visualization
                          end
                          %==================================================================
                          
                          %===REPLACEMENT====================================================================
                          %Replace the migrant in the local habitat from individual with highest W species ID
                          MigWDC = 1./WD;         
                          Mig = cumsum(MigWDC);
                          M = unifrnd(0,max(Mig));
                          MI = find(M <= Mig);%1st in the MI list is the migrating ind
                          Mig(MI(1,1));%Ind to replace the death ind
                          SP = CS(MigrantHab,MigInd(1,MI(1,1)));

			  %Replace trait value old ind with new trait value migrant for the BAD
                          NDC(KillHab,KillInd(1,KI(1,1))) = NDC(MigrantHab,SP);%dispersal trait
                          NBC(KillHab,KillInd(1,KI(1,1))) = NBC(MigrantHab,SP);%biotic trait
                          NAC(KillHab,KillInd(1,KI(1,1))) = NAC(MigrantHab,SP);%abiotic trait
                      
                          
                          %Replace old ID with new ID migrant
                          %CS(KillHab,KI(1,1)) = CS(MigrantHab,MI(1,1));
                          CS(KillHab,KillInd(1,KI(1,1))) = SP;
                          end%~isempty(MigInd);

%Maa = MigrantHab
%Species = SP
%Maaa = MigInd(1,MI(1,1))
%A = CS(KillHab,KillInd(1,KI(1,1)))
%pause
                          %===================================================================================
                                     
                       end%belonging to R or C
                   end%numel
                    
                 else %>m, we have a local birth in site KillHab --> offspring+mu(trait change) 
                
                     if KillSp <= SR;%if death was R, then local birth belongs to R
                       
                        %Choose randomly species from KillHab (local site)
                        ULocal = randelement(unique(RS(KillHab,:)),1);
                        
                        %Compute list individuals from randomly chosen local species
                        LocInd = find(RS(KillHab,:) == ULocal);%list inds species ID
                        if ~isempty(LocInd);
                          
		 %-----------W each individual for births                      
                 %Fitness, W Abiotic======================================
                 %Obtain optimal abiotic mean from population at each time
                 %--------------------------------------------------------
                 munewR = mean(NAR(KillHab,LocInd));
                 
                 %Abiotic Calculate fitness each individual, W, ===============================
                 WA = zeros(1,length(LocInd));
                 for p = 1:length(LocInd);
                     WA(1,p) = exp(-gamma*(NAR(KillHab,LocInd(1,p)) - munewR)^2);
                 end
                 %=====================================================================
                 WD = zeros(1,length(LocInd));
                 %W Dispersal====================================================

                 for p = 1:length(LocInd);
                     WD(1,p) = exp(-gamma*(NDR(KillHab,LocInd(1,p)) - mu)^2);
                     %WD(pD,1) = Zi(1,pD) - D;%Distance to mean for visualization
                 end
                 %===============================================================
               
                 %W Biotic=================================================================================
                 WB = zeros(1,length(LocInd));
                 for p = 1:length(LocInd);
                     WB(1,p) = 1/(1 + exp(-gamma*(NBR(KillHab,LocInd(1,p)) - mean(NBC(KillHab,:)))^2));
                     %WB(pB,1) = Zrb(1,pB) - mean(Zcb);%Distance to mean for visualization
                 end
                 %=========================================================================================

                        
                          %W BAD locals =======================================================
                          %Individual-ID from local birth can be different to the death-ID
                          %W each individual to obtain probability to local birth
                          %These BAD were calculated for the dying individual
                          %We use only the W for all here as 
                          BirthWBADR = WB;         
                          Birth = cumsum(BirthWBADR);
                          BA = unifrnd(0,max(Birth));
                          BI = find(BA <= Birth);%1st in the BI list is the reproducing ind
                          BIRTH = RS(KillHab,LocInd(1,BI(1,1)));

%Test_______________________________
%KillHab
%LocInd(1,BI(1,1))
%BIRTH = RS(KillHab,LocInd(1,BI(1,1)))
%RS(KillHab,BI(1,1))
%pause
%___________________________________

                          
                          %====REPLACEMENT========================================================================================
                          %Replace trait value old ind with new trait value offspring for the BAD
                          %Check https://ch.mathworks.com/help/matlab/ref/rand.html for the rand() setup
                          %Each trait change independently but with a different value within the range [nub nua]

                          %CHANGESAME DIRECTION ONLY BIOTIC CHANGES
                          bchanR = (nua + (nub-nua).*rand(1,1));%trait changes follow biotic direction
                          NDR(KillHab,KillInd(1,KI(1,1))) = NDR(KillHab,LocInd(1,BI(1,1))) + bchanR;%dispersal trait
                          NBR(KillHab,KillInd(1,KI(1,1))) = NBR(KillHab,LocInd(1,BI(1,1))) + bchanR;%biotic trait
                          NAR(KillHab,KillInd(1,KI(1,1))) = NAR(KillHab,LocInd(1,BI(1,1))) + bchanR;%abiotic trait
                          
                          %Replace old ID with new ID migrant
                          RS(KillHab,KillInd(1,KI(1,1))) = BIRTH;
                          end%~isempty(LocInd);
                          %========================================================================================================

                    else%if death was C, then local birth belongs to C
                    
                          %Choose randomly species from KillHab (local site)
                          ULocal = randelement(unique(CS(KillHab,:)),1);
                        
                          %Compute list individuals from randomly chosen local species
                          LocInd = find(CS(KillHab,:) == ULocal);%list inds species ID
                          if ~isempty(LocInd);

                 %Fitness, W Abiotic===================================
                         munewC = mean(NAC(KillHab,LocInd));%Check KillInd
                 
                         %Calculate fitness each individual, W=================================
                 WA = zeros(1,length(LocInd));
                 for p = 1:length(LocInd);
                     WA(1,p) = exp(-gamma*(NAC(KillHab,LocInd(1,p)) - munewC)^2);
                     %WA(pA,1) = Zca(1,pA) - munewC;%Distance to mean for visualization
                 end
                 %=====================================================================
               
                 %W Dispersal====================================================
                 WD = zeros(1,length(LocInd));
                 for p = 1:length(LocInd);
                     WD(1,p) = exp(-gamma*(NDC(KillHab,LocInd(1,p)) - mu)^2);
                     %WD(pD,1) = Zi(1,pD) - D;%Distance to mean for visualization
                 end
                 %===============================================================
                 
                 %W Biotic========================================================================
                 WB = zeros(1,length(LocInd));
                 for p = 1:length(LocInd);
                     WB(1,p) = exp(-gamma*(NBC(KillHab,LocInd(1,p)) - mean(NBR(KillHab,:)))^2);
                     %WB(pB,1) = Zrb(1,pB) - mean(Zcb);%Distance to mean for visualization
                 end
                 %================================================================================

                    
                          %W BAD locals =======================================================
                          %Individual-ID from local birth can be different to the death-ID
                          %W each individual to obtain probability to local birth
                          %These BAD were calculated for the dying individual
                          %We use only the W for all here as 
                          BirthWBADC = WB;         
                          Birth = cumsum(BirthWBADC);
                          BA = unifrnd(0,max(Birth));
                          BI = find(BA <= Birth);%1st in the BI list is the reproducing ind
                          BIRTH = CS(KillHab,LocInd(1,BI(1,1))); 
                          
                          %====REPLACEMENT========================================================================================
                          %Replace trait value old ind with new trait value offspring for the BAD
                          %Check https://ch.mathworks.com/help/matlab/ref/rand.html for the rand() setup
                          %Each trait change independently but with a different value within the range [nub nua] for both R and C

                          %CHANGE SAME DIRECTION ONLY BIOTIC CHANGES 
                          bchanC = (nua + (nub-nua).*rand(1,1));%trait changes follow biotic direction
                          NDC(KillHab,KillInd(1,KI(1,1))) = NDC(KillHab,LocInd(1,BI(1,1))) + bchanC;%dispersal trait
                          NBC(KillHab,KillInd(1,KI(1,1))) = NBC(KillHab,LocInd(1,BI(1,1))) + bchanC;%biotic trait
                          NAC(KillHab,KillInd(1,KI(1,1))) = NAC(KillHab,LocInd(1,BI(1,1))) + bchanC;%abiotic trait
                          
                          %Replace old ID with new ID migrant
                          CS(KillHab,KillInd(1,KI(1,1))) = BIRTH;
                          end%~isempty(LocInd);
                          %========================================================================================================
                	
                      end%close KillSp loop
                 end%migration or local birth
	        end %~isempty(KillIndR and C);
              end%t
         end%MaxG
     
         %%%5. OUTPUTS==========================================================================
         %Outputs to plot heat map Coevolutionary rescue in disper vs. coevol selection gradient
         %============Compute alpha, beta and gamma richness per replicate after================
         
            fid = fopen([fnamR '.csv'],'a');  %Save raw matrices...
            %fprintf(fid, [repmat('% 6f ',1,size(NBR,2)), '\n'],NBR');
            %fprintf(fid, [repmat('% 6f ',1,size(NAR,2)), '\n'],NAR');
            %fprintf(fid, [repmat('% 6f ',1,size(NDR,2)), '\n'],NDR');
            fprintf(fid, [repmat('% 6f ',1,size(RS,2)), '\n'],RS');
            fclose(fid);
            
            fid = fopen([fnamC '.csv'],'a');  %Save raw matrices...
            %fprintf(fid, [repmat('% 6f ',1,size(NBC,2)), '\n'],NBC');
            %fprintf(fid, [repmat('% 6f ',1,size(NAC,2)), '\n'],NAC');
            %fprintf(fid, [repmat('% 6f ',1,size(NDC,2)), '\n'],NDC');
            fprintf(fid, [repmat('% 6f ',1,size(CS,2)), '\n'],CS');
            fclose(fid);

            fid = fopen([migration '.csv'],'a');  %Save raw matrices...
            fprintf(fid, [repmat('% 6f ',1,size(m,2)), '\n'],m');
            fclose(fid);

            fid = fopen([coevgamma '.csv'],'a');  %Save raw matrices...
            fprintf(fid, [repmat('% 6f ',1,size(gamma,2)), '\n'],gamma');
            fclose(fid);
            
            

            %fid = fopen([fnamDistanceMatrix '.csv'],'a');  %Save raw matrices...
            %fprintf(fid, [repmat('% 6f ',1,size(Pdmean,2)), '\n'],Pdmean');
            %fclose(fid);  
            
            
            %Open outputs to analyze these outputs in octave=============================
            %Install dataframe within the octave promt as
            %pkg install -forge dataframe
            %Call it
            %pkg load dataframe
            %data = dataframe("name.csv")
            %=============================================================================                   
   %toc
   end%MaxRep
 
