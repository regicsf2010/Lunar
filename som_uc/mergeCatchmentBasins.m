function [ clusterCoresWithID ] = mergeCatchmentBasins( clusterCoresWithID, nClusterCores, watersheds, nWatersheds )

for i = 1 : nWatersheds
    posCB = logical(watersheds == i); % it must be logical to use as an argument later
    overlap = 0;
    for k = 1 : nClusterCores
        posCC = clusterCoresWithID == k; % get the indices of the cluster core 'k'
        if (sum(posCC(posCB)) ~= 0) % evaluate the overlap of the catchment basin 'i' and the cluster core 'k'
            overlap = k;
            break;
        end
    end
    
    if overlap ~= 0 % occurred overlap between Wi and Ck
        clusterCoresWithID(posCB) = overlap;
    end
end


end

