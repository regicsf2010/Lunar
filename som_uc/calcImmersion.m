function [ i_matrix, i_vector ] = calcImmersion( neighbors, u_vector, p_vector, dims )
%% Calculating immersion
i_vector = 1 : length(u_vector);
% Apply gradient descent in U-matrix
i_vector = ddescent(i_vector, neighbors, u_vector);
% Apply gradient ascent in P-matrix
%   Warning:
%       The technical report does not mention aascent in P-matrix.
%       There is one mention of this application in another Ultsch's paper.
%       There is no significant changes in the result whether applied or
%       not.
%
i_vector = aascent(i_vector, neighbors, p_vector);

%% Transformation from vector to matrix
i_matrix = transform(i_vector, 'vec2mat', dims);

end

