function [ I ] = ddescent( i_vector, neighbors, u_vector )
%% Additional informations
nNeurons = length(i_vector);
I = zeros(1, nNeurons);

%% Calculating immersion of each neuron
for i = 1 : nNeurons
    neuron_out = descent(i_vector(i), neighbors, u_vector);
    if(neuron_out == i_vector(i)) % Equation (6), first choice (Equation (5), second choice)
        % Evaluate each neighbor of neuron_out
        for j = find(neighbors(i_vector(i), :))
            out = descent(j, neighbors, u_vector);
            if(u_vector(out) < u_vector(i_vector(i)))
                I(i) = out;
                break;
            end
        end
        % Equation (6), second choice (Failed second requirement)
        if(I(i) == 0) 
            I(i) = neuron_out;
        end
    else % Equation (6), second choice (Equation (5), first choice)
        I(i) = neuron_out;
    end
end

end

