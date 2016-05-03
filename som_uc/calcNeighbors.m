function [ neighbors ] = calcNeighbors(m, n)
nNeurons = m * n;
neighbors = zeros(nNeurons, nNeurons);
for i = 1 : nNeurons
    neuronsPos = getNeuronPos(i, m, n); % find the neighbors indices of the neuron i
    neighbors(i, neuronsPos) = 1; % convention 1 for connectivity between neurons
end
end

function [ neuronsPos ] = getNeuronPos(pos, m, n)
[j, i] = ind2sub([n m], pos); % Attention: invert (i,j) to (j,i) and (m,n) to (n,m)
k = 0;

if(i - 1 > 0) % up
    k = k + 1;
    neuronsPos(k) = n * (i - 2)  + j;    
end

if(i - 1 > 0 && j - 1 > 0) % up-left
    k = k + 1;
    neuronsPos(k) = n * (i - 2)  + (j - 1);    
end    

if(j - 1 > 0) % left
    k = k + 1;
    neuronsPos(k) = n * (i - 1)  + (j - 1);    
end

if(i + 1 <= m && j - 1 > 0) % down - left
    k = k + 1;
    neuronsPos(k) = n * i  + (j - 1);    
end    

if(i + 1 <= m) % down
    k = k + 1;
    neuronsPos(k) = n * i  + j;    
end    

if(i + 1 <= m && j + 1 <= n) % down-right
    k = k + 1;
    neuronsPos(k) = n * i  + (j + 1);    
end

if(j + 1 <= n) % right
    k = k + 1;
    neuronsPos(k) = n * (i - 1)  + (j + 1);    
end

if(i - 1 > 0 && j + 1 <= n) % up-right
    k = k + 1;
    neuronsPos(k) = n * (i - 2)  + (j + 1);    
end
    
end


