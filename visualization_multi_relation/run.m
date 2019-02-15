%% set up environment
addpath('../methods');
addpath('../data/');
addpath('../methods/lbfgsb/Matlab/');    

%% compute A
computeA;
%% compute P
% rng(7);
% PG = compute_graph_prior('uniform', A);

rng(8);
PG = compute_graph_prior('degree', A);

%% compute embedding
dim = 2;
s1 = 1;
s2 = 15;
[X, postP] = train_embedding_cne(A, PG, n, dim, s1, s2, n, 1e-4, 2000, 'subsample', false);

%% plot
plotter(X, A, nodeLabels, nodeInfo, nodeTypes);
