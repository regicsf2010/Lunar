function [ classes ] = classification( immersion, neurons, clusterCores, X, borderID )

bm = bestMatch(neurons, X);     % calculate best matches for each sample
classes = clusterCores(bm);     % define which cluster belongs to each sample
indices = classes == borderID;  % find samples indices classified as borders

if(sum(indices) ~= 0)           % if exist samples classified as borders
    classes(indices) = clusterCores(immersion(bm(indices))); % consider its immersion
end

end

