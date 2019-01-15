%=============================================================
%Coevolutionary rescue in ecological networks
%BAD Modular scenario
%Andreazzi, Astegiano and Melian @EAWAG DEC 2018 (v2 JAN 2018)
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
       %3. Kill:cumsum(1/W) W function R or C OK(R)
       %4. Reorganize species row killed
       %5. Reposition: 
           %random < m == Migration = Site f(distance) + Random species + W(D)
           %random > m == Birth = Random species + W(BAD) + mutation
       %================================================================
       
         m=unifrnd(0,1);%gradient migration rate
         gamma = unifrnd(0,10);%gradient strength coevo selection
         
         for j = 1:MaxG;
             for t = 1:(length(Zrb)*SR*SC)*2;%#R-C abundances landscape
               
                 %--------------------Death,Random----------------------------
                 KillHab = unidrnd(P);%random selection site
                 a = min(min(RS));b = max(max(CS));
                 KillSp = round(unifrnd(a,b));
                 KillInd = find(RS(KillHab,:)) == KillSp;%INDS Sp in KillHab
                 %KillInd = unidrnd(SR);%random selection species
                 %------------------------------------------------------------
                 
                 %W -- equal contribution to W each trait
                 %W Abiotic
                 munew = mean(NAR(KillHab,KillInd));%Check KillInd
                 for pA = 1:length(KillInd);
                 WA(1,pA) = exp(-gamma*(NAR(KillHab,KillInd(1,pA)) - munew)^2);
                 %WA(pA,1) = Zra(1,pA) - munew;%Distance to mean
                 end
               
                 %W Dispersal  
                 for pD = 1:length(KillInd);
                 WA(1,pD) = exp(-gamma*(NDR(KillHab,KillInd(pD,1)) - mu)^2);
                 %WD(pD,1) = Zi(1,pD) - D;%Distance to mean
                 end
                 
                 %W Biotic
                 for pB = 1:length(KillInd);
                 WB(1,pB) = 1/(1 + exp(-gamma*(NBR(KillHab,KillInd(pB,1)) - mean(NBC))^2));
                 %WB(pB,1) = Zrb(1,pB) - mean(Zcb);
                 end
                 WBADR = 1/((WB(1,:) + WA(1,:) + WD(1,:))/3);%W each ind Sp KillHab
                 kill = cumsum(WBADR); K = unifrnd(min(kill),max(kill));
                 KI = find(K >= WBADR);%KI is the dying ind
                 
                 %-------------------------------------------------------------
                 
                 
                 
                 
                 %Original function in WR
                 %WA(pA,2) = exp(-gamma*(Zra(1,pA) - munew)^2);
                 %WA(pA,1) = Zra(1,pA) - munew;
                 
                 %WD(pD,2) = exp(-gamma*(Zi(1,pD) - D)^2);
                 %WD(pD,1) = Zi(1,pD) - D;

                 %WB(pB,2) = 1/(1 + exp(-gamma*(Zr(1,pB) - mean(Zc))^2));
                 %WB(pB,1) = Zr(1,pB) - mean(Zc);
                 
                 %WR;%Kill individual sp R with prob(W)
                 %WC;%Kill ind sp C with prob(W)

                 %ep=unifrnd(0,1,1);%event probability
                 %if ep < m,  %Migration event
                  
                 %   MHP = unifrnd(0,1);
                %   KillHab = unidrnd(S);
                 %  if MHP >= P_ij(KillHabR,KillHabR);
                 %     MigrantHab = find(P_ij(KillHab,:) >= MHP,1);    
                 %  else
                 %     MigrantHab = find(P_ji(:,KillHab) >= MHP,1);
                 %  end                                  
                    
                %    if numel(MigrantHab)>0, %Update
                        %4. Implement local birth dynamics and speciation dynamics
                %        MigrantInd = unidrnd(J);  
                %        cevents = cevents + 1;
                %        Pairs(cevents,1) = KillHab;
                %        Pairs(cevents,2) = MigrantHab(1,1); 
                %        R(KillHab,KillInd)=R(MigrantHab(1,1),MigrantInd);            
                %    end
                    
                %elseif ep <= m+v,  %Birth --> offspring 
                %    newSp = newSp +1;
                %    R(KillHab,KillInd) = newSp;
                %else               %birth
                %    BirthLocalInd = unidrnd(J);
                %    while BirthLocalInd == KillInd,
                %        BirthLocalInd = unidrnd(J);
                %    end
                %    R(KillHab,KillInd) = R(KillHab,BirthLocalInd);
                %end
              %end%t
               
     
                 % end
         end
     end
     
     
%%%5. OUTPUTS=================================================================

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
   end%i
  %=======================================================================
  
        
        
%----------------OLD----To be deleted------------------------------------ 
        
            %l=1-(m+v);%birth rate %Define following GEMs
            %R = zeros(S,J);       %the same species in every site
            %R=repmat([1:S]',1,J); %a different species in every site
     
 %Fitness function A-----------------------%Check STPM code for plot
%alpha = 5;munewA = mean(SRA(1,:,1));
%for pA = 1:length(Z);
%WA(pA,2) = exp(-alpha*(Z(1,pA) - munewA)^2);%W each trait value A 
%WA(pA,1) = Z(1,pA) - munewA;
%end

%Fitness trait D-----------------------%Check STPM code for plot
%for pD = 1:length(Zd);
%WD(pD,2) = exp(-alpha*(Zd(1,pD) - D)^2);
%WD(pD,1) = Zd(1,pD) - D;
%end

%Fitness function B
%for pB = 1:length(Zr);
%WB(pB,2) = 1/(1 + exp(-alpha*(Zr(1,pB) - mean(Zc))^2));
%WB(pB,1) = Zr(1,pB) - mean(Zc);
%end

%Total fitness each phenotype at time 
%------------------------------------------

%Mating --- non-overlapping -- pick up site and two parents-->
%mutation offspring 

      
    %end
  %end
%end
%end


            %------Part to be introduced in the Main -- Demography                    
            %preallocation main matrices and vectors
            %countgen = 0;Pairs = zeros(1,2);cevents = 0;newSp = 100;
            %gamma=[];
   
            %start loop of generations
            %for k = 1:MaxGenerations,
            %countgen = countgen + 1;
           
              %W each phenotype for S = 1, 2, 3... N

              %Modular W function

 
              %Magic W function
               

            


                %if mod(t,10), disp(['t: ' num2str(t) ' / ' num2str(J*S)]); end %Check
              
              %KillHab = unidrnd(S);
               % KillInd = unidrnd(J);
               % ep=unifrnd(0,1,1);  %event probability
               % if ep < m,  
                  
                %   MHP = unifrnd(0,1);
                %   KillHab = unidrnd(S);
                %   if MHP >= P_ij(KillHab,KillHab);
                %      MigrantHab = find(P_ij(KillHab,:) >= MHP,1);    
                %   else
                %      MigrantHab = find(P_ji(:,KillHab) >= MHP,1);
                %   end                                  
                    
                %    if numel(MigrantHab)>0, 
                        %4. Implement local birth dynamics and speciation dynamics
                %        MigrantInd = unidrnd(J);  
                %        cevents = cevents + 1;
                %        Pairs(cevents,1) = KillHab;
                %        Pairs(cevents,2) = MigrantHab(1,1); 
                %        R(KillHab,KillInd)=R(MigrantHab(1,1),MigrantInd);            
                %    end
                    
                %elseif ep <= m+v,  %mutation
                %    newSp = newSp +1;
                %    R(KillHab,KillInd) = newSp;
                %else               %birth
                %    BirthLocalInd = unidrnd(J);
                %    while BirthLocalInd == KillInd,
                %        BirthLocalInd = unidrnd(J);
                %    end
                %    R(KillHab,KillInd) = R(KillHab,BirthLocalInd);
                %end
              %end%t
              
              %Sp_eachSt=arrayfun(@(ix) unique(R(ix,:)), [1:size(R,1)],'uniformoutput',false);
              %alpha(g)%Num of species at each site for present generation
              %alpha = arrayfun(@(v) length(cell2mat(v)),Sp_eachSt);
              %gamma(countgen) = numel(unique(R));
              %alphaM(countgen) = mean(alpha);
              %alphaSD(countgen) = std(alpha);
            %end%loop generations  
           
          %end%ri
