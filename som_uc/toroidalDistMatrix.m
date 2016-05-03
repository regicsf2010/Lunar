function [ dist_matrix ] = toroidalDistMatrix(n, m)
%% Additional information
% Creates distance matrix. 
% Third dimension stores the neuron id
mdist = zeros(n, m, n * m); 


% Conversion from the matrix indices to euclidean space
% (i, j) --> (x, y), where (i, j) is a matrix indices and (x, y) is a point
% x = j, convertion
% y = n - i + 1, convertion

% Equation for the toroidal distance matrix
% d(x, y) = sqrt( min( abs(x' - x''), m - abs(x' - x'') ) + 
%                 min( abs(y' - y''), m - abs(y' - y'') ) )

%% Computes each distance regarding the neuron id = m * (i-1) + j.
for i = 1 : n
    for j = 1 : m
        ii = j; % converts to the euclidean space 
        jj = (n - i) + 1; % converts to the euclidean space
        for k = 1 : n
            for l = 1 : m
                kk = l; 
                ll = (n - k) + 1;
                mdist(k, l, m * (i-1) + j) = sqrt(min([abs(ii - kk), m - abs(ii - kk)])^2 + ...
                                                  min([abs(jj - ll), n - abs(jj - ll)])^2);
            end
        end
        
    end    
end

%% Format the output as a matrix
dist_matrix = zeros(n * m); % the output matrix
for i = 1 : n * m
    dist_matrix(i, :) = transform(mdist(:, :, i), 'mat2vec', [n m]);
end

end


