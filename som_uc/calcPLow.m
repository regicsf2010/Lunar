function [ p_low ] = calcPLow( p_matrix )
%% Additional informations
[m, n] = size(p_matrix);
nNeurons = m * n;
p_low = zeros(m, n);

%% Calculating the probability of each data density be low
for i = 1 : m
    for j = 1 : n
        p_low(i, j) = length(find(p_matrix > p_matrix(i, j)));
    end
end

p_low = p_low ./ nNeurons;

end

