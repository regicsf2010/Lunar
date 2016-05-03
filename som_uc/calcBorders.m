function [ borders ] = calcBorders( u_vector, p_vector, lambda, mi, borderID )
%%   Convention:
%       0        -  'Not a border'
%       borderID -  'a border'

%% Additional informations
nNeurons = length(u_vector);
borders = zeros(1, nNeurons); 

%% Discovering the borders
for i = 1 : nNeurons
    if(u_vector(i) > lambda || p_vector(i) < mi)
        borders(i) = borderID;
    end
end

end

