%---------------------------------------------------------------------------
%e-co-evolutionary dynamics in mutualistic meta-networks
%GEMs -- non-zero sum dynamics
%CJ Melian 
%---------------------------------------------------------------------------
  %%%1. FIXED PARAMETERS
  clear;
  %seed=17;
  %rng(seed);
  MaxRep = 1;          %number of replicates
  MaxGenerations = 100; %number of generations per replicates
  %--------------------------------------------------------
  
  %%%2. Spatial matrix Euclidean?
  n == XX;%distance matrix
  L=1000; % size of the landscape
  S = 10;%number of sites 
  n = unifrnd(0,L,S,2);%positions of sites RGG
  Sd = zeros(S,S);
  for i = 1:S-1,
      for j = i+1:S,
          dx2 = (n(i,1) - n(j,1))^2;%Euclidean distance
          dy2 = (n(i,2) - n(j,2))^2;
          d(i,j) = sqrt(dx2 + dy2);
          Sd(i,j) = 1/d(i,j);
      end
  end
  %Symmetric model following double stochastic matrix acct sierra size
              Sd(S,S) = 0;
              Sd=Sd+Sd';
              Sdf = sinkhornKnopp(Sd);
              P_ij = cumsum(Sdf,2);
              P_ji = cumsum(Sdf,1)
  %------------------------------------------------------
  
  %%%3. Key parameters: sampling traits plants--pollin from prior distributions
  m=0.3; %migration rate
  v=0.001;%speciation rate 
  l=1-(m+v);%birth rate %Define following GEMs
  J = 100;%individuals per site
  hp = %heritability plant trait
  ha = %heritability animal trait
  Zp = unidrnd()%#flowers per capita
  Za = inidrnd()%#visits per capita
  %-----------------------------------
  
          %start loop of replicates
          for ri = 1:MaxRep;   
            %tic
            
            %initial condition --- account for habitat size
            R = ones(S,J);       %the same species in every site
            %R=repmat([1:S]',1,J); %a different species in every site
            
            %preallocation main matrices and vectors
            countgen = 0;Pairs = zeros(1,2);cevents = 0;newSp = 100;
            gamma=[];
   
            %start loop of generations
            for k = 1:MaxGenerations,

            countgen = countgen + 1;
           
           
              
              %Demographic and trait dynamics
              for t = 1:J*S,  %MonteCarlo Time --> Account GEMs
                
                %if mod(t,10), disp(['t: ' num2str(t) ' / ' num2str(J*S)]); end %Check
              
              KillHab = unidrnd(S);
                KillInd = unidrnd(J);
                ep=unifrnd(0,1,1);  %event probability
                if ep < m,  
                  
                   MHP = unifrnd(0,1);
                   KillHab = unidrnd(S);
                   if MHP >= P_ij(KillHab,KillHab);
                      MigrantHab = find(P_ij(KillHab,:) >= MHP,1);    
                   else
                      MigrantHab = find(P_ji(:,KillHab) >= MHP,1);
                   end                                  
                    
                    if numel(MigrantHab)>0, 
                        %4. Implement local birth dynamics and speciation dynamics
                        MigrantInd = unidrnd(J);  
                        cevents = cevents + 1;
                        Pairs(cevents,1) = KillHab;
                        Pairs(cevents,2) = MigrantHab(1,1); 
                        R(KillHab,KillInd)=R(MigrantHab(1,1),MigrantInd);            
                    end
                    
                elseif ep <= m+v,  %mutation
                    newSp = newSp +1;
                    R(KillHab,KillInd) = newSp;
                else               %birth
                    BirthLocalInd = unidrnd(J);
                    while BirthLocalInd == KillInd,
                        BirthLocalInd = unidrnd(J);
                    end
                    R(KillHab,KillInd) = R(KillHab,BirthLocalInd);
                end
              end%t
              
              Sp_eachSt=arrayfun(@(ix) unique(R(ix,:)), [1:size(R,1)],'uniformoutput',false);
              %alpha(g)%Num of species at each site for present generation
              alpha = arrayfun(@(v) length(cell2mat(v)),Sp_eachSt);
              gamma(countgen) = numel(unique(R));
              alphaM(countgen) = mean(alpha);
              alphaSD(countgen) = std(alpha);
            end%loop generations  
            
            fnam = sprintf('Sym_A%0.4f_GPT%04d.txt',As(1,ii),GPTs(1,jj));
            fid = fopen(fnam,'a');
            %fprintf(fid,'%f %f %f %3f %3f\n',ri,countgen,gamma,alphaM,alphaSD);    
            %fnam1 = sprintf('gamma%d %d %d %d %d.txt',ri,As(1,ii),A,GPT,f);
            %fid = fopen(fnam1,'w');
            fprintf(fid, [repmat('% 6f ',1,size(gamma,2)), '\n'],gamma);
            fprintf(fid, [repmat('% 6f ',1,size(alphaM,2)), '\n'],alphaM);
            fprintf(fid, [repmat('% 6f ',1,size(alphaSD,2)), '\n'],alphaSD);
            fclose(fid);
            mpost = cevents/(MaxGenerations*S*J)
            save([fnam '_migr_events.dat'],'Pairs', 'ri', 'mpost');
            %toc
          end%ri
