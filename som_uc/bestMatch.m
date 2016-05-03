function [ winNeuronPos, shortestDists, winNeuronWeights ] = bestMatch( neurons, X )
%% Additional Informations
[nNeurons dim]= size(neurons); % convention of neurons PER ROW
nSamples = length(X);
winNeuronPos = zeros(nSamples, 1);
shortestDists = zeros(nSamples, 1);
winNeuronWeights = zeros(nSamples, dim);

%% Find the neuron with the best match
for i = 1 : nSamples
    sDist = inf; % aux variable for shortest distance
    for j = 1 : nNeurons
        dist = sum((neurons(j, :) - X(i, :)).^2); % squared euclidean distance
        if(dist < sDist)
            winNeuronPos(i) = j; % stores the winning neuron position
            shortestDists(i) = dist; % stores the winning neuron distance (from X to neuron(i))
            winNeuronWeights(i, :) = neurons(j, :); % stores the winning neuron weights vector
            sDist = dist;
        end
    end    
end
end

