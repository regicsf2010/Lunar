function [ nClusterCores, sizeEachCluster, borders ] = getClusterCoresInfo( neighbors, borders, borderID, indsSorted )
%% Additional informations
ccID = -inf; % convention for cluster core ID
borders(logical(borders ~= borderID)) = ccID; % sets each 'not a border' neuron as ccID
v = 0; % this variable is used to indicate the number of a cluster core

%% Calculating the cluster cores 
for i = indsSorted % iterates the indices of u_vector from the lowest to highest
    if(borders(i) ~= borderID) % it must be 'not a border' neuron; only 'not a border' neuron belongs to a cluster core
        nns_i = borders( find( neighbors(i, :) ) ); % get the indices of the neighbors with find function
        nns_i(logical(nns_i == borderID)) = []; % removes the borders
        nns_i(logical(nns_i == ccID)) = []; % removes 'not a border' neurons that were not evaluated yet
        % Here, nns_i contains only neurons already evaluated or is empty
        if(isempty(nns_i)) % it means that there are no evaluated neurons at the neighbor of the neuron i
            v = v + 1;
            borders(i) = v; % 'v' indicates the id of cluster cores
        else
            borders(i) = nns_i(1); % There is a problem here when nns_i has 
        end                        % more than one different value.
    end                            % There must be post-processing to adjust 
end                                % the borders.

%% Post-processing
% This processing tries to fix problems like:
% Convention: -1 = border, j = cluster core id
%   A = [ 1 -1  3]   result    A = [ 1 -1  1]  but can be   A = [ 3 -1  3]
%       [-1  1 -1] =========>      [-1  1 -1]  =========>       [-1  3 -1] 
%       [-1 -1  2]                 [-1 -1  1]                   [-1 -1  3]
% TODO - Try to think in something smart here.

for i = indsSorted
    if(borders(i) ~= borderID)
        nns_i = borders( find( neighbors(i, :) ) );
        nns_i(logical(nns_i == borderID)) = []; % removes the borders
        if ~isempty(nns_i) && ~all(nns_i == nns_i(1)) % discovers if there are ids of different cluster cores, if so...
            values2update = nns_i( (nns_i ~= nns_i(1)) ); % get ids different from the first one
            borders( ismember(borders, values2update) ) = nns_i(1); % discovers the position of all neurons with these ids and update their ids to the first one
        end
    end
end

%% Count cluster cores and size of each cluster
%   Warning:
%       The highest cluster id IS NOT the number of cluster cores yet.
%       The post-processing code does not guarantee that.
%
maxClusterID = max(max(borders)); 
[search, inds] = ismember(1 : maxClusterID, borders); % 'search' is logical equal to 1 for each cluster core found
% Sum all the 1's is equal to the number of cluster cores
nClusterCores = sum(search);
sizeEachCluster = zeros(1, nClusterCores);
inds(inds == 0) = []; % removes zeros mean 'ids not found' by ismember function
for i = 1 : nClusterCores
    sizeEachCluster(i) = sum(borders == borders(inds(i))); % discovers the size of each cluster core
end

%% Correctly label the cluster cores from 1 to nClusterCores
for i = 1 : nClusterCores
    borders( borders == borders(inds(i)) ) = i;
end

end


