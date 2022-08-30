%%%2. SPATIAL MATRIX 
  %(RGG -- homogeneous: same Theta per species\heterogeneous: gradient per species (Matrix is funciton of A trait distribution)
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
  %------------------------------------------------------