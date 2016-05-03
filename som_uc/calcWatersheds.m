function [ watersheds, nWatersheds, sizeEachWatershed ] = calcWatersheds( neighbors, u_vector, borderID )
%% Additional information
[~, inds] = sort(u_vector);
unlabeledID = -inf;
watersheds = ones(1, length(u_vector)) * unlabeledID;
v = 0;

for i = inds % starts with the local minima
    nws = watersheds( find( neighbors(i, :) ) ); % get the indices of the neighbors with find function
    nws(nws == borderID) = []; % removes borders neurons
    nws(nws == unlabeledID) = []; % removes unlabeled neurons
    
    if(isempty(nws)) % if empty, it means is a local minima neuron
        v = v + 1;
        watersheds(i) = v;
    elseif all(nws == nws(1)) % growing catchment basins
        watersheds(i) = nws(1);        
    elseif(length(nws) > 1) % between two catchment basins, if so it is a border
        watersheds(i) = borderID;  
    end
    
end

nWatersheds = max(watersheds);
sizeEachWatershed = zeros(1, nWatersheds);

for i = 1 : nWatersheds
    sizeEachWatershed(i) = sum(watersheds == i);
end

