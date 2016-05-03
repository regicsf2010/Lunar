function out = transform(in, transformation, dims)
%% Transform the 'In' variabel from matrix to vector or vice-versa

switch(transformation)
    case 'vec2mat'
        out = zeros(dims(1), dims(2)); % Notice that dims are the output dimension
        for i = 1 : dims(1)
            ini = dims(2) * (i - 1) + 1;
            fim = ini + dims(2) - 1;
            out(i, :) = in(ini : fim);
        end
        
    case 'mat2vec'
        % out_aux = in';
        % out = out_aux(:)';
        out = zeros(1, dims(1) * dims(2)); % the size of the vector
        for i = 1 : dims(1)
            ini = dims(2) * (i - 1) + 1;
            fim = ini + dims(2) - 1;
            out(ini : fim) = in(i, :);
        end
end

end