function [ mdist ] = toroidalDistMatrix2(n, m)
%% Additional information
% Creates distance matrix
mdist = zeros(n * m, n * m); 

% Equation for the toroidal distance matrix
% d(x, y) = sqrt( min( abs(x' - x''), m - abs(x' - x'') ) + 
%                 min( abs(y' - y''), m - abs(y' - y'') ) )

%% Computes each distance regarding the neuron id
for l = 1 : n * m % neuron's linear indice
    j = rem(l - 1, m) + 1; % neuron's subscript j
    i = (l - j) / m + 1; % neuron's subscript i
        for c = l + 1 : n * m
            jj = rem(c - 1, m) + 1; 
            ii = (c - jj) / m + 1; 
            mdist(l, c) = sqrt(min([abs(i - ii), n - abs(i - ii)])^2 + ... % euclidean
                               min([abs(j - jj), m - abs(j - jj)])^2);
            %mdist(l, c) = min([abs(i - ii), n - abs(i - ii)]) + ...
            %                   min([abs(j - jj), m - abs(j - jj)]); % manhattan            
        end
end
mdist = mdist' + mdist; % copying upper triangle to bottom triangle matrix
end