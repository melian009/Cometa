% This is the script to run the coevolutionary model, generating the matrices reported in Figure 2A
tic
rand('twister',sum(100*clock));
format long

%parameters
timesteps=6000; %# maximal number of time steps
alpha=0.2;%scaling constant that controls the sensitivity of the evolutionary effect on trait matching
thmedio=10; %the maximal possible trait value favored for environmental selection - these theta-values will be sampled between zero and 10.
%phi=lambda^2(G) * si, with si = 1/(h^2 * lambda^2) the scaling constant affecting sensitivity of mean W to changes in Zi and Zi,p
hmedio=0.2; %mean value of the phi parameter across all species in the network. The phi paramater is product of the additive genetic variance and the slope of the selection gradient
r=load('Bcor.txt'); %read the empirical network. Format: biadjacency matrix representing a bipartite graph. I assume the matrix has no zeroed row or column. This matrix parameterizes the forbidden links of the network (zeroed elements of the matrix)
mmedio=0.7; %mean level of mutualism selection

%generating the matrix of forbidden links
linha=size(r,1);% number of rows
coluna=size(r,2);% number of columns
dim=linha+coluna;% total species richness

F=zeros(dim); %generate an empty square matrix
F(1:linha,linha+1:end)=r; %fill the square matrix
F(linha+1:end,1:linha)=r';
F(F>0)=1; %make F binary.

%generating the parameters of the selection gradient
h=hmedio+ 0.01*randn(dim,1); %sampling the phi-values for each species in the network
while min(h)<0||max(h)>1
    h=hmedio+ 0.01*randn(dim,1); %fixing any phi-value higher than one or smaller than zero.
end

theta= thmedio.*rand(dim,1);%sampling the theta-values of environmental selection for each species in the network.
pmedio=1-mmedio;
vetorp= pmedio+0.01*randn(dim,1);%sampling the strength of environmental selection for each species in the network.

while min(vetorp)<0||max(vetorp)>1
    vetorp = pmedio+0.01*randn(dim,1);%fixing any value of environmental selection higher than one or smaller than zero.
end

%simulation
z=thmedio.*rand(dim,1); %generate a vector with the initial trait values of each species
zn=z; %create an auxiliary vector
bandeira=0;%a variable to detect the end of a simulation and save computation time.
matriz=F; %creating the Q-matrix
tau=6000; %set the variable for time to equilibrium
%numerical simulation
for timestepsi=1:timesteps; %run the simulations
    if bandeira ==0; %is the simulation running?
        %compute the contribution of each interaction to the selection gradient
        for i=1:dim;
            for j=1:dim;
                matriz(i,j)=F(i,j).*exp(-alpha.*((z(i)-z(j)).*(z(i)-z(j)))); 
            end
        end
        
        for i=1:dim;
            matriz(i,:)=matriz(i,:)/sum(matriz(i,:)); %standardize the effects to sum to 1.
        end       
        matriz=diag(1-vetorp)*matriz; %standardize the effects to sum to mi (the level of mutualism selection on species i)
        
        %compute a matrix of trait differences
        zmatriz=diag(z); 
        zmatriz=ones(dim)*zmatriz-zmatriz*ones(dim);
        
        echanges=matriz.*zmatriz; %computing the weighted mismatch between interacting partners
        echanges=sum(echanges,2); %computing the component of mutualism selection to the selection gradient
        
        %evolutionary change
        z2=z; %creating an auxiliary vector
        for i=1:dim;
            zn(i)=h(i).*echanges(i)+vetorp(i).*h(i).*(theta(i)-z(i));%computing the trait change in species i.
            z(i)=z(i)+zn(i); %update the trait value of species i.
        end
        
        %Is trait evolution occuring?
        d=z2-z; %a vector of trait changes for all species
        
            if mean(abs(d(:)))<0.000001 % condition to stop the simulation
                tau=timestepsi; %recording the time-to-quilibrium
                bandeira=1; %stopping the simulation.
            end
        
    end
end

T=inv(eye(dim)-matriz)*diag(vetorp); %generating the T-matrix
dlmwrite('qmatriz.txt',matriz,'delimiter', '\t', 'precision',10); %printing the q-matrix file
dlmwrite('tmatriz.txt',T,'delimiter', '\t', 'precision',10); %printing the t-matrix file

toc %simulation is over.
