function [UMatrix, UVec] = calcUMatrix(neuronsWeights, neighbors, dims)
%% Additional informations
numNeurons = dims(1) * dims(2);
UVec = zeros(1, numNeurons);

%% Calculating U-Matrix
for i = 1 : numNeurons
    aux_mean = 0;
    for j = find(neighbors(i, :)) % access just the adjacencies of neuron i
        aux_mean = aux_mean + sqrt(sum( (neuronsWeights(i, :) - neuronsWeights(j, :)).^2 ));        
    end
    UVec(i) = aux_mean / sum(neighbors(i, :));        
end

%% Transforming U-Matrix vector in 'matrix' indeed (neuron position 'from bottom to top')
UMatrix = transform(UVec, 'vec2mat', dims);

end


