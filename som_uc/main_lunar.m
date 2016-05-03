clear all; clc;


rng(10);

%% Load previous database
load 'database/databaseSmall.mat'
database = data; disp('Database loaded.')
bc = 197;
database(1 : bc, 3) = 0;
database(bc + 1 : end, 3) = 1; % inserting classes 
clearvars ans undam data;

%% Creating SOM
dim1 = 80; % horizontal
dim2 = 50; % vertical
net = selforgmap([dim1 dim2], 'coverSteps', 500,...
                 'initNeighbor', 10, 'topologyFcn', 'gridtop',...
                 'distanceFcn', 'dist'); disp('SOM created.')
%net.trainParam.epochs = 500; % coverSpets * 2 (ordering and tuning phase)

%% Additional configurations
feats = [1 2];
inputs = database(:, 1 : end - 1)'; % samples per colunms
inputs = normalize_data(inputs, 0, 1, 2, 'minmax'); % Normalizing data (2) - samples per column
borderID = -1;

%% Train
[net, tr] = train(net, inputs(feats, :));
% Obtaining informations from the ESOM
neuronsWeights = net.IW{1, 1}; % neurons weight (positions of the neurons)
%[neuronPos, dists, winNeuronWs] = bestMatch(neuronsWeights, inputs(feats, :)');
%pos = net.layers{1}.positions;
neighbors = sparse((net.layers{1}.distances <= 1.5) - eye(net.layers{1}.size));

%% ESOM - U*C Algorithm
[u_matrix, u_vector] = calcUMatrix(neuronsWeights, neighbors, [dim2 dim1]); disp('u_matrix - ok')% Extracting U-Matrix
%[p_matrix, p_vector] = calcPMatrix(neuronsWeights, neighbors, inputs(feats, :)', [dim2 dim1]); disp('p_matrix - ok') % Extracting P-Matrix
%[ustar_matrix, ustar_vector] = calcUStarMatrix(u_matrix, p_matrix); disp('ustar_matrix - ok')

%[~, i_vector] = calcImmersion(neighbors, u_vector, p_vector, [dim2 dim1]); disp('immersion - ok')
%[clusterCores, nClusters, sizeEachCluster, clusterCoresWithID] = calcClusterCores(neighbors, u_vector, p_vector, borderID); disp('cluster cores - ok')
%[watersheds, nWatersheds, sizeEachWatershed] = calcWatersheds(neighbors, u_vector, borderID); disp('watersheds - ok')
%[mergedClusterCores] = mergeCatchmentBasins(clusterCoresWithID, nClusters, watersheds, nWatersheds); disp('merging cluster cores - ok')

%% Plots
% SOM spaces
% figure, plotsomtop(net) % topology
% figure, plotsomnc(net)
% figure, plotsomnd(net) % neighborhood distance
% figure, plotsomplanes(net)
% figure, plotsomhits(net, inputs(feats, :)) % hits per neurons
% figure, plotsompos(net, inputs(feats, :)) % neurons and inputs positions

% Matrix spaces
figure, surf(u_matrix) 
figure, contour(u_matrix, 20)

%figure, surf(p_matrix); % figure, contour(p_matrix, 20)
%figure, surf(ustar_matrix); % % figure, contour(ustar_matrix, 20)
% colormap hsv, colorbar
% Specific positions: 
%h1 = figure; surf(u_matrix); h2 = figure; surf(p_matrix); movegui(h1, 'northwest'), movegui(h2, 'northeast')
%h1 = figure; contour(u_matrix, 20); h2 = figure; contour(p_matrix, 20); movegui(h1, 'northwest'), movegui(h2, 'northeast')

% Cluster Cores
% a1 = clusterCoresWithID;
% a1(logical(a1 == borderID)) = 0;
% a1 = transform(a1, 'vec2mat', [dim2 dim1]);
% rgb = label2rgb(a1, 'jet', [.5 .5 .5]);
% %subplot(3, 1, 1)
% h1 = figure; imshow(rgb, 'InitialMagnification', 'fit')
% title(['nClusters = ' num2str(nClusters)])
% 
% % Watersheds
% a1 = watersheds;
% a1(logical(a1 == borderID)) = 0;
% a1 = transform(a1, 'vec2mat', [dim2 dim1]);
% rgb = label2rgb(a1, 'jet', [.5 .5 .5]);
% %subplot(3, 1, 2)
% h2 = figure; imshow(rgb, 'InitialMagnification', 'fit')
% title(['Catchment Basins = ' num2str(nWatersheds)])
% 
% a1 = mergedClusterCores;
% a1(logical(a1 == borderID)) = 0;
% a1 = transform(a1, 'vec2mat', [dim2 dim1]);
% rgb = label2rgb(a1, 'jet', [.5 .5 .5]);
% %subplot(3, 1, 3)
% h3 = figure; imshow(rgb, 'InitialMagnification', 'fit')
% movegui(h1, 'northwest'), movegui(h2, 'northeast'), movegui(h3, 'south')

% Matlab's watershed
% L = watershed(ustar_matrix);
% rgb = label2rgb(L,'jet',[.5 .5 .5]);
% figure
% imshow(rgb,'InitialMagnification','fit')

%% Test
%outputs = net(inputs(feats, :)); % matlab best match
%classes = vec2ind(outputs)'; % matlab best match




