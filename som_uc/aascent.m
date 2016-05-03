function [ I ] = aascent( i_vector, neighbors, p_vector )
% Notification:
%    This code is quite similar to ddescent script.
%    There is no pseudo implementation of this code in any Ultsch's papers.
%    The following implementation is based on the opposite of ddescent code.   
%
%% Additional informations
nNeurons = length(i_vector);
I = zeros(1, nNeurons);

%% Calculating immersion of each neuron
for i = 1 : nNeurons
    neuron_out = ascent(i_vector(i), neighbors, p_vector);
    if(neuron_out == i_vector(i))
        for j = find(neighbors(i_vector(i), :))
            out = ascent(j, neighbors, p_vector);
            if(p_vector(out) > p_vector(i_vector(i))) % Difference from ddescent
                I(i) = out;
                break;
            end
        end
        if(I(i) == 0) 
            I(i) = neuron_out; 
        end
    else
        I(i) = neuron_out;
    end
end

end

