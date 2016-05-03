clear all; clc;

%% Load previous database
rng(10)
load('databases_benchmarking/lsun.mat');
database = lsun;
% load databasez24.mat
% database = databasez24.data;
% database = database(1:3312, :);

%% Creating SOM
dim1 = 80; % columns 80
dim2 = 50; % lines 50
net = selforgmap([dim1 dim2], 'coverSteps', 150,...
                 'initNeighbor', 100, 'topologyFcn', 'gridtop',...
                 'distanceFcn', 'dist'); disp('SOM created - ok')
%% Additional configurations
feats = 1:2;
inputs = database(:, 1 : end - 1)'; % samples per colunms
inputs = normalize_data(inputs, 0, 1, 2, 'zscore'); % Normalizing data (2) - samples per column
borderID = -1;

%% Train
net = train(net, inputs(feats, :)); disp('SOM trained - ok')
neuronsWeights = net.IW{1, 1};
neighbors = sparse((net.layers{1}.distances <= 1.5) - eye(net.layers{1}.size)); % 4 (1.001) - conectivity

% ESOM - U*C Algorithm
[u_matrix, u_vector] = calcUMatrix(neuronsWeights, neighbors, [dim2 dim1]); disp('u_matrix - ok') % Extracting U-Matrix
[p_matrix, p_vector] = calcPMatrix(neuronsWeights, neighbors, inputs(feats, :)', [dim2 dim1]); disp('p_matrix - ok') % Extracting P-Matrix
[ustar_matrix, ustar_vector] = calcUStarMatrix(u_matrix, p_matrix); disp('ustar_matrix - ok')

[i_matrix, i_vector] = calcImmersion(neighbors, u_vector, p_vector, [dim2 dim1]); disp('immersion - ok')
[clusterCores, nClusters, sizeEachCluster, clusterCoresWithID] = calcClusterCores(neighbors, u_vector, p_vector, borderID); disp('cluster cores - ok')
[watersheds, nWatersheds, sizeEachWatershed] = calcWatersheds(neighbors, u_vector, borderID); disp('watersheds - ok')
[mergedClusterCores] = mergeCatchmentBasins(clusterCoresWithID, nClusters, watersheds, nWatersheds); disp('merging cluster cores - ok')

%% Plots
% figure, surf(u_matrix); 
figure, contour(u_matrix, 20);
% figure, surf(ustar_matrix); figure, contour(ustar_matrix, 20);
% figure, surf(p_matrix); figure, contour(p_matrix, 20);
% colormap hsv, colorbar

%% Plots clusters
% Cluster Cores
a1 = clusterCoresWithID;
a1(logical(a1 == borderID)) = 0;
a1 = transform(a1, 'vec2mat', [dim2 dim1]);
rgb = label2rgb(a1, 'jet', [.5 .5 .5]);
%subplot(3, 1, 1)
h1 = figure; imshow(rgb, 'InitialMagnification', 'fit')
title(['Clusters cores = ' num2str(nClusters)])

% Watersheds
a1 = watersheds;
a1(logical(a1 == borderID)) = 0;
a1 = transform(a1, 'vec2mat', [dim2 dim1]);
rgb = label2rgb(a1, 'jet', [.5 .5 .5]);
%subplot(3, 1, 2)
h2 = figure; imshow(rgb, 'InitialMagnification', 'fit')
title(['Watershed || Catchment Basins = ' num2str(nWatersheds)])

a1 = mergedClusterCores;
a1(logical(a1 == borderID)) = 0;
a1 = transform(a1, 'vec2mat', [dim2 dim1]);
rgb = label2rgb(a1, 'jet', [.5 .5 .5]);
%subplot(3, 1, 3)
h3 = figure; imshow(rgb, 'InitialMagnification', 'fit')
title('Merge = Cluster cores + Watersheds')
movegui(h1, 'northwest'), movegui(h2, 'northeast'), movegui(h3, 'south')

% Matlab's watershed
% L = watershed(u_matrix);
% rgb = label2rgb(L,'jet',[.5 .5 .5]);
% figure
% imshow(rgb,'InitialMagnification','fit')
