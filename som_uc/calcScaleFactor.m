function [ scaleFactor ] = calcScaleFactor( p_matrix )
%% Additional informations
p_vector = transform(p_matrix, 'mat2vec', size(p_matrix));
vMax = max(p_vector);
vMean = mean(p_vector);

%% Alternative way to calculate probability of each data density be low
scaleFactor = 1 + (p_matrix - vMean) ./ (vMean - vMax);

end