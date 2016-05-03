function [PMatrix, P] = calcPMatrix(neuronsWeights, neighbors, X, dims)
%% Additional informations
p = 0.2013; % 0.2013 = produces 88% of the maximal information
paretoRadius = chi2cdf(p, size(X, 2)) / 2;
numNeurons = dims(1) * dims(2);
P = zeros(1, numNeurons);

%% Calculating P-Matrix
for i = 1 : numNeurons
    for j = find(neighbors(i, :)) % access just the adjacencies of neuron i
        for s = 1 : length(X)
            dist = sqrt(sum( (X(s, :) - neuronsWeights(j, :)).^2 ));
            if(dist < paretoRadius)
                P(i) = P(i) + 1;
            end
        end
    end
end

%% Transforming P vector in 'matrix' indeed (neuron position 'from bottom to top')
PMatrix = transform(P, 'vec2mat', dims);

end


