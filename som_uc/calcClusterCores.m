function [ clusterCores, nClusterCores, sizeEachCluster, clusterCoresWithID ] = calcClusterCores( neighbors, u_vector, p_vector, borderID)
%% Additional information
[u_vectorSorted, u_indsSorted] = sort(u_vector); % u_vectorSorted used for calculating percentiles only
p_vectorSorted = sort(p_vector); % p_vectorSorted used for calculating percentiles only
nNeurons = length(u_vectorSorted); % number of neurons
p_mi = zeros(1, 51); % p_mi and p_lambda are used for storing mi's and lambda's thresholds candidates
p_lambda = zeros(1, 51);

%% Evaluating the best
lambda = percentile(u_vectorSorted, nNeurons, 50); % sets lambda and varies mi up to 50
for p = 0 : 50    
    mi = percentile(p_vectorSorted, nNeurons, p);
    borders = calcBorders(u_vector, p_vector, lambda, mi, borderID); % run cluster cores function
    [nClusterCores, sizeEachCluster] = getClusterCoresInfo(neighbors, borders, borderID, u_indsSorted); % get informations from the cluster cores matrix
    p_mi(p + 1) = nEntropy(nClusterCores, sizeEachCluster); % calculates entropy
end

[~, pos] = max(p_mi);
pos = pos - 1; % correction for range 0 up to 50
final_mi = percentile(p_vectorSorted, nNeurons, pos); % 'pos' can be [1, 51], but in the literature says [0, 50]
for p = 50 : 100
    lambda = percentile(u_vectorSorted, nNeurons, p);
    borders = calcBorders(u_vector, p_vector, lambda, final_mi, borderID);
    [nClusterCores, sizeEachCluster] = getClusterCoresInfo(neighbors, borders, borderID, u_indsSorted);
    p_lambda(p - 49) = nEntropy(nClusterCores, sizeEachCluster);
end

[~, pos] = max(p_lambda);
pos = pos + 49; % correction for range 50 up to 100
final_lambda = percentile(u_vectorSorted, nNeurons, pos);

%% Finally calculate borders with the fittest lambda and mi
clusterCores = calcBorders(u_vector, p_vector, final_lambda, final_mi, borderID); % -1 = 'border', 0 = 'not a border'
[nClusterCores, sizeEachCluster, clusterCoresWithID] = getClusterCoresInfo(neighbors, clusterCores, borderID, u_indsSorted);

end

%% Calulate a percentile of the neurons' size by 'Nearest Rank Method'
function [ val ] = percentile( vector, lengthVector, percent )
pos = round(lengthVector * (percent / 100));
if(pos == 0) % There is a possibility of 'pos = 0', in this case 'val = 0'.
    val = 0; % Just a convention. Not sure if is correct.
else
    val = vector(pos); % get the value of the percentile at the position 'pos'
end
end

%% Calculate nEntropy
function [ entropy ] = nEntropy( nClusterCores, sizeEachCluster )
neuronsCB = sum(sizeEachCluster);
p = sizeEachCluster ./ neuronsCB;
lp = log2(p);
entropy = (p * lp') / log2(1 / nClusterCores);
end



