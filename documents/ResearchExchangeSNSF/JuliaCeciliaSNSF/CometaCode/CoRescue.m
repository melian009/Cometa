%---------------------------------------------------------------------------
%e-co-evolutionary rescue
%Andreazzi, Astegiano and Melian @EAWAG DEC 2018
%---------------------------------------------------------------------------
  %%%1. FIXED PARAMETERS
  clear;%seed=17;rng(seed);
  MaxRep = 1;%number of replicates
  MaxGenerations = 100; %number of generations per replicates
  nu=0.001;%mutation rate
  %JR = 100; JC = 100;%individuals per site == defined below in step 3
  SR = 10;SC = 10;%Species landscape
   %--------------------------------------------------------
  
  %%%2. SPATIAL MATRIX (RGG -- homogeneous: same Theta per species\heterogeneous: gradient per species (Matrix is funciton of A trait distribution)
  L=1000; % size of the landscape
  P = 10;%number of sites 
  n = unifrnd(0,L,P,2);%positions of sites RGG
  Pd = zeros(P,P);
  for i = 1:P-1,
      for j = i+1:P,
          dx2 = (n(i,1) - n(j,1))^2;%Euclidean distance
          dy2 = (n(i,2) - n(j,2))^2;
          d(i,j) = sqrt(dx2 + dy2);
          Pd(i,j) = 1/d(i,j);
      end
  end 
              Pd(P,P) = 0;
              Pd=Pd+Pd';
              Pdf = sinkhornKnopp(Pd);%Symmetric migration model following double stochastic matrix
              P_ij = cumsum(Pdf,2);
              P_ji = cumsum(Pdf,1)
  %------------------------------------------------------
 
%%%3. SAMPLING BAD: Modular -- Magic scenarios  
%Modular (sampling 3 distr independently each SR && SC
for t = 1:3;%traits
STP = zeros(i,length(Zi),j);%Prior length Zi
    for i = 1:SR;
        for j = 1:P;
            for s = 1;%Std
                Zi = -2*s:1e-1:2*s;%Tuning 2 changes initial S abundance  
                Zri = normpdf(Zi, mu, s);
                Zi = Zi + abs(min(Zi));%Move everything to the right.
                SRD(i,:,j) = Zi;
                
%Plotting trait distributions---
%hold on
%hr1 = plot(Zi,Zri);%Visualize
%a =unifrnd(0,1);
%b =unifrnd(0,1);
%c =unifrnd(0,1);
%set(hr1,'color',[a b c]);
%set(hr1,'LineWidth',2);
%-------------------------------
           end
        end
    end
end

%Magic (Sampling distribution from cov matrix)


  
  %-----------------------------------
  %%%4. Main start loop of replicates
          for ri = 1:MaxRep;   
            %tic

            m=linspace[0,1,10];%migration rate
            alpha=linspace[min,max,C];%strength coevo selection 
            %l=1-(m+v);%birth rate %Define following GEMs
            R = zeros(S,J);       %the same species in every site
            R=repmat([1:S]',1,J); %a different species in every site
            
            %preallocation main matrices and vectors
            %countgen = 0;Pairs = zeros(1,2);cevents = 0;newSp = 100;
            gamma=[];
   
            %start loop of generations
            %for k = 1:MaxGenerations,
            %countgen = countgen + 1;
           
              %W each phenotype for S = 1, 2, 3... N

              %Modular W function

 
              %Magic W function
               

             for t = 1:J*S;%Selection-Mating-Migration
             %MonteCarlo Time --> Account GEMs
            
             end
            end%ri


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
            

            %%%5. OUTPUTS

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
            %toc
          %end%ri
