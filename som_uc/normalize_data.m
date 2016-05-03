function [ dataNorm ] = normalize_data(data, x, y, feature_pos, type)
%NORMALIZE_DATA 
%   Samples (1 - per row; 2 - per column)
% WARNING: 
%   1 - per column; 
%   2 - per row;
maximum = max(data, [], feature_pos); 
minimum = min(data, [], feature_pos); 
range = maximum - minimum;

dataNorm = zeros(size(data));

switch(type)
    case 'minmax'
        if(feature_pos == 1)        % Samples per row
            for i = 1 : length(range)
                dataNorm(:, i) = (data(:, i) - minimum(i)) / range(i);
                dataNorm(:, i) = dataNorm(:, i) * (y - x) + x;
            end
        elseif(feature_pos == 2)    % Samples per column
            for i = 1 : length(range)
                dataNorm(i, :) = (data(i, :) - minimum(i)) / range(i);
                dataNorm(i, :) = dataNorm(i, :) * (y - x) + x;
            end    
        end
    case 'zscore'
        if(feature_pos == 1)        % Samples per row
            dataNorm = zscore(data);
        elseif(feature_pos == 2)    % Samples per column
            dataNorm = zscore(data');
            dataNorm = dataNorm';
        end
end

end

