#pleiotropy_matrix = [1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 0; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1],

%Pleiotropy
L = 150;L1=50;L2=100;
T = 15;T1=5;T2=10;
B = zeros(L,T);%Pleiotropy

%Epistasis
a = 5;%Std
b = 500;%Mean
E = a.*randn(1000,1) + b;

%Generate Pleiotropy modular
for i = 1:L;
    for j = 1:T;
        if i <= L1 && j <= T1;
           r1 = randi(2,1,1)-1;
           if r1 == 1;
              B(i,j) = 1;
           else
              B(i,j) = 0;
           end          
        elseif i > L1 && i <= L2 && j > T1 && j <= T2
           r2 = randi(2,1,1)-1;
           if r2 == 1;
              B(i,j) = 1;
           else
              B(i,j) = 0;
           end       
        elseif i > L2 && j > T2
           r3 = randi(2,1,1)-1;
           if r3 == 1;
              B(i,j) = 1;
           else
              B(i,j) = 0;
           end
        end   
   end       
end

%Genetic Redundancy
N = 1000;#number individuals
Z = zeros(N,3)
for n = 1:N;
    Wb(n,1) =
    Wa(n,1) =      
end

