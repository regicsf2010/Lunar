function [ neuron_out ] = descent( neuron_in, neighbors, u_vector )
%% Find the neighbors of neuron i
neighbors_neuron_in = find(neighbors(neuron_in, :));

%% Discover which neighbor has the minimum uheight
[min_uheight, neuronPos] = min(u_vector(neighbors_neuron_in));

%% Compare the minimum neighbor uheight to the neuron i
if(min_uheight < u_vector(neuron_in))
    neuron_out = neighbors_neuron_in(neuronPos);
else
    neuron_out = neuron_in;
end

end

