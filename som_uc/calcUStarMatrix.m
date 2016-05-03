function [ UStarMatrix, UStar ] = calcUStarMatrix( u_matrix, p_matrix )
%% Calculating U*-Matrix
p_low = calcPLow(p_matrix); % calculate the probability of each data density be low
UStarMatrix = u_matrix .* p_low; % calculate U*-Matrix

%% Alternative way to calculate U*-Matrix
% scaleFactor = calcScaleFactor(p_matrix);
% UStarMatrix = u_matrix .* scaleFactor;

%% Transforming U*-Matrix in vector
UStar = transform(UStarMatrix, 'mat2vec', size(UStarMatrix));
end

