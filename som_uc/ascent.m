function [ neuron_out ] = ascent( neuron_in, neighbors, p_vector )
%% Find the neighbors of neuron i
neighbors_neuron_in = find(neighbors(neuron_in, :));

%% Discover which neighbor has the maximum pheight
[max_pheight, neuronPos] = max(p_vector(neighbors_neuron_in));

%% Compare the maximum neighbor pheight to the neuron i
if(max_pheight > p_vector(neuron_in)) % Difference from descent
    neuron_out = neighbors_neuron_in(neuronPos);
else
    neuron_out = neuron_in;
end

end

