%=============================================================
%Coevolutionary rescue in ecological networks
%BAD Modular scenario
%Andreazzi, Astegiano and Melian @EAWAG DEC 2018 (v1.3 JAN 2018)
%=============================================================

%---------------------------------GOAL--------------------------------------
%Plot heat map Coevolutionary rescue in gradient disper vs. coevol selection
%---------------------------------------------------------------------------
  
%%%1. FIXED PARAMETERS===========================================
  clear;%seed=17;rng(seed);
  MaxRep = 1;%number of replicates
  MaxG = 100; %number of generations per replicates
  nu=0.001;%mutation rate (phenotypic change)
  SR = 3;SC = 1;%Species landscape
  sigma = 1;ro = 1;
  %================================================================
  
%%%2. SPATIAL MATRIX========================================================
  %RGG -- homogeneous: same Theta per species
  %heterogeneous: gradient per species(Matrix function of trait distribution)
  L=1000; % size of the landscape
  P = 10;%number of sites 
  n = unifrnd(0,L,P,2);%positions of sites RGG
  Pd = zeros(P,P);
  Pdmean = zeros(P,P);
  for i = 1:P,
      for j = i+1:P,
          dx2 = (n(i,1) - n(j,1))^2;%Euclidean distance
          dy2 = (n(i,2) - n(j,2))^2;
          d(i,j) = sqrt(dx2 + dy2);%distance matrix
          Pd(i,j) = 1/d(i,j);%the lower the distance the higher the probability
          Pdmean(i,j) = d(i,j);%the lower the distance the higher the probability
      end
  end 
  Pd(P,P) = 0;
  Pdmean=Pdmean+Pdmean';
  D = nonzeros(triu(Pdmean,1));
  Dm = mean(D);%Optimum dispersal value
  Pd=Pd+Pd';
  Pdf = sinkhornKnopp(Pd);%Symmetric migration model following double stochastic matrix
  P_ij = cumsum(Pdf,2);
  P_ji = cumsum(Pdf,1);
  %===========================================================================
 
%%%3. INITIAL SAMPLING BAD==================================================
%Modular -- P patches -- N abundance each sp and SR number resource species
%1. sampling 3 dist. independently for each resource and consumer species
%2. same N but different trait values for each species in each site

%Initial length +++++++++++++++++++++++++++++++++++++++++
Z=round(unifrnd(6,10));
Len = (Z -  ro*sigma) : (sigma / 100) : (Z + ro*sigma); 
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%Resources---------------------------------------------------------------
for i = 1:P;
    for j = 1:SR;   
Zmr=round(unifrnd(1,4));%Mean biotic trait
sigmar = 12;
Zrb(j,1:length(Len)) = (Zmr -  ro*sigmar) : (sigmar / 100) : (Zmr + ro*sigmar);
SBR(j,1:length(Len)) = j;

sigmaa = 10;
Zm = round(unifrnd(45,55));%Mean abiotic trait
Zra(j,1:length(Len)) = (Zm -  ro*sigmaa) : (sigmaa / 100) : (Zm + ro*sigmaa); 

mu = mean(D);%Optimum dispersal value;Extract distribution from landscape values
sigmad = 2; 
Zrd(j,1:length(Len)) = (mu -  ro*sigmad) : (sigmad / 100) : (mu + ro*sigmad); 
    end
    NBR(i,1:SR*length(Len)) = reshape(Zrb.',1,[]);%Matrix to vector
    NAR(i,1:SR*length(Len)) = reshape(Zra.',1,[]);
    NDR(i,1:SR*length(Len)) = reshape(Zrd.',1,[]);
    RS(i,1:SR*length(Len)) = reshape(SBR.',1,[]);%Sp ID vector
end
%------------------------------------------------------------------------

%Consumers---------------------------------------------------------------
for i = 1:P;
    for j = 1:SC;   
Zmc=round(unifrnd(1,4));%Mean biotic trait
sigmar = 12;
Zcb(j,1:length(Len)) = (Zmc -  ro*sigmar) : (sigmar / 100) : (Zmc + ro*sigmar);
SBC(j,1:length(Len)) = SR + j;

sigmaa = 10;
Zm = round(unifrnd(45,55));%Mean abiotic trait
Zca(j,1:length(Len)) = (Zm -  ro*sigmaa) : (sigmaa / 100) : (Zm + ro*sigmaa); 

mu = mean(D);%Optimum dispersal value;Extract distribution from landscape values
sigmad = 2; 
Zcd(j,1:length(Len)) = (mu -  ro*sigmad) : (sigmad / 100) : (mu + ro*sigmad); 
    end
    NBC(i,1:SC*length(Len)) = reshape(Zcb.',1,[]);%Matrix to vector
    NAC(i,1:SC*length(Len)) = reshape(Zca.',1,[]);
    NDC(i,1:SC*length(Len)) = reshape(Zcd.',1,[]);
    CS(i,1:SC*length(Len)) = reshape(SBC.',1,[]);%Sp ID vector
end
%------------------------------------------------------------------------

%======================================================================

%%%4. Main==============================================================
  
     for i = 1:MaxRep;%tic
       
       %================Loop===========================================
       %0. N < K per site  OK
       %1. Random site OK
       %2. Random species (unique N < 0) OK
       %3. Kill:cumsum(1/W) W function R or C OK(R and C)
       %4. Reorganize species row killed
       %5. Reposition: 
           %random < m == Migration = Site f(distance) + Random species + W(D)
           %random > m == Birth = Random species + W(BAD) + mutation
       %================================================================
       
         m=unifrnd(0,1);%gradient migration rate
         gamma = unifrnd(0,10);%gradient strength coevo selection
         
         for j = 1:MaxG;
             for t = 1:(length(Zrb)*SR*SC)*2;%#R-C abundances landscape
               
                 %--------------------Death----------------------------
                 KillHab = unidrnd(P);%random selection site
                 a = min(min(RS));b = max(max(CS));
                 KillSp = round(unifrnd(a,b));
              if KillSp <= SR;
                 KillInd = find(RS(KillHab,:) == KillSp);%INDS Sp in KillHab
                                      
                 %W===equal contribution to W each trait resources =========
                 %W Abiotic
                 munewR = mean(NAR(KillHab,KillInd));%Check KillInd
                 
                 for pA = 1:length(KillInd);
                 WA(1,pA) = exp(-gamma*(NAR(KillHab,KillInd(1,pA)) - munewR)^2);
                 %WA(pA,1) = Zra(1,pA) - munewR;%Distance to mean
                 end
               
                 %W Dispersal  
                 for pD = 1:length(KillInd);
                 WD(1,pD) = exp(-gamma*(NDR(KillHab,KillInd(1,pD)) - mu)^2);
                 %WD(pD,1) = Zi(1,pD) - D;%Distance to mean
                 end
                 
                 %W Biotic
                 for pB = 1:length(KillInd);
                 WB(1,pB) = 1/(1 + exp(-gamma*(NBR(KillHab,KillInd(1,pB)) - mean(NBC(KillHab,:)))^2));
                 %WB(pB,1) = Zrb(1,pB) - mean(Zcb);
                 end
               
                 %W to die
                 DieWBADR = 1./((WB+WA+WD)/3)          
                 Kill = cumsum(DieWBADR)
                 K = unifrnd(0,max(Kill))
                 KI = find(K <= Kill)%1st KI is the dying ind
                 Kill(KI(1,1));%Ind to replace from 
                 %NBR(KI(1,1));NAR(KI(1,1));NDR(KI(1,1))
                 %pause %to test
                 
              else %CHECK 1
                 KillInd = find(CS(KillHab,:) == KillSp);
                 
                 %W===equal contribution to W each trait consumers =========
                 %W Abiotic
                 munewC = mean(NAC(KillHab,KillInd));%Check KillInd
                 
                 for pA = 1:length(KillInd);
                 WA(1,pA) = exp(-gamma*(NAC(KillHab,KillInd(1,pA)) - munewC)^2);
                 %WA(pA,1) = Zca(1,pA) - munewC;%Distance to mean
                 end
               
                 %W Dispersal  
                 for pD = 1:length(KillInd);
                 WD(1,pD) = exp(-gamma*(NDC(KillHab,KillInd(1,pD)) - mu)^2);
                 %WD(pD,1) = Zi(1,pD) - D;%Distance to mean
                 end
                 
                 %W Biotic
                 for pB = 1:length(KillInd);
                 WB(1,pB) = exp(-gamma*(NBC(KillHab,KillInd(1,pB)) - mean(NBR(KillHab,:)))^2);
                 %WB(pB,1) = Zrb(1,pB) - mean(Zcb);
                 end
               
                 %W to die
                 DieWBADR = 1./((WB+WA+WD)/3)          
                 Kill = cumsum(DieWBADR)
                 K = unifrnd(0,max(Kill))
                 KI = find(K <= Kill)%1st KI is the dying ind
                 Kill(KI(1,1));%Ind to replace from 
                 %NBR(KI(1,1));NAR(KI(1,1));NDR(KI(1,1))
                 %pause %to test
              end       
                 %==========================================================

                 %CHECK 2: distinction resources and consumers
                 ep=unifrnd(0,1,1);%event probability
                 if ep < m, %Migration event
                  %random < m == Migration = Site f(distance) + Random species + W(D)
                  
                    MHP = unifrnd(0,1);
                %   KillHab = unidrnd(S);
                   if MHP >= P_ij(KillHab,KillHab);
                      MigrantHab = find(P_ij(KillHab,:) >= MHP,1);    
                   else
                      MigrantHab = find(P_ji(:,KillHab) >= MHP,1);
                   end                                                      
                   if numel(MigrantHab)>0,%Update
                %        MigrantInd = unidrnd(J);  
                %        cevents = cevents + 1;
                %        Pairs(cevents,1) = KillHab;
                %        Pairs(cevents,2) = MigrantHab(1,1); 
                %        R(KillHab,KillInd)=R(MigrantHab(1,1),MigrantInd);            
                   end
                    
                 elseif ep <= m+v,%Birth --> offspring 
                %CHECK 3: distinction resources and consumers

                 BirthWBADR = (WB+WA+WD)/3;          
                 Birth = cumsum(DieWBADR)
                 B = unifrnd(0,max(Birth))
                 BI = find(B <= Birth)%1st BI is the reproducing ind
                 Birth(BI(1,1));%Ind to reproduce from 
                 %NBR(BI(1,1));NAR(BI(1,1));NDR(BI(1,1))
                 
                 %W to birth
                    
                %    newSp = newSp +1;
                %    R(KillHab,KillInd) = newSp;
                %else               %birth
                %    BirthLocalInd = unidrnd(J);
                %    while BirthLocalInd == KillInd,
                %        BirthLocalInd = unidrnd(J);
                %    end
                %    R(KillHab,KillInd) = R(KillHab,BirthLocalInd);
                 end
              end%t
               
     
     end%MaxG
     
%%%5. OUTPUTS=================================================================

%CHECK 4 
%---------------------------------------------------------------------------
%Plot heat map Coevolutionary rescue in disper vs. coevol selection gradient
%---------------------------------------------------------------------------
            %fnam = sprintf('Sym_A%0.4f_GPT%04d.txt',As(1,ii),GPTs(1,jj));
            %fid = fopen(fnam,'a');
            %fprintf(fid,'%f %f %f %3f %3f\n',ri,countgen,gamma,alphaM,alphaSD);    
            %fnam1 = sprintf('gamma%d %d %d %d %d.txt',ri,As(1,ii),A,GPT,f);
            %fid = fopen(fnam1,'w');
            %fprintf(fid, [repmat('% 6f ',1,size(gamma,2)), '\n'],gamma);
            %fprintf(fid, [repmat('% 6f ',1,size(alphaM,2)), '\n'],alphaM);
            %fprintf(fid, [repmat('% 6f ',1,size(alphaSD,2)), '\n'],alphaSD);
            %fclose(fid);
            %mpost = cevents/(MaxGenerations*S*J)
            %save([fnam '_migr_events.dat'],'Pairs', 'ri', 'mpost');
%=============================================================================                   
            %toc
   end%MaxRep
%=======================================================================
 