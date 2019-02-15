function tune_cne(dataName, priorName, dim, s1, s2, randSeed, foldIdx, gradTol, maxIter)
if isdeployed
    dim = str2double(dim);
    s1 = str2double(s1);
    s2 = str2double(s2);
    randSeed = str2double(randSeed);
    foldIdx = str2double(foldIdx);
    gradTol = str2double(gradTol);
    maxIter = str2double(maxIter);
else 
    addpath('../methods');
    addpath('../data/');
    addpath('../methods/lbfgsb/Matlab/');    
end
%% preprocess
% load data
data = load_labeled_data(dataName);
nVertex = size(data.network, 1);
nLabel = size(data.group, 2);
n = nVertex + nLabel;

% compute labels
labels = [ones(1,nVertex), ones(1,nLabel)*2];

% split test - train_valid
test_portion = 0.5;
rng(randSeed);
teInds = subsample(data.group, test_portion);
teMask = zeros(1, nVertex); teMask(teInds) = 1;
trValMask = ~teMask;
trValInds = find(trValMask);

% split train - valid
nFold = 5;
nTrVal = length(trValInds);
nVal = floor(nTrVal/nFold);
fold_sizes = ones(1, nFold) * nVal; fold_sizes(end) = fold_sizes(end) + mod(nTrVal, nVal);
cvInds = mat2cell(trValInds, 1, fold_sizes);

% compute training graph
valInds = cell2mat(cvInds(foldIdx));
trA = sparse(n,n);
trA(1:nVertex,1:nVertex) = data.network;
trA(1:nVertex, nVertex+1:end) = data.group;
trA(teInds, nVertex+1:end) = zeros(length(teInds), nLabel);
trA(valInds, nVertex+1:end) = zeros(length(valInds), nLabel);
trA = trA | trA';

%% compute prior
switch priorName    
    case 'block'
        trP = block_prior_non_overlap(trA, labels);
    case 'block_and_degree'
        [~,~,trP] = maxent_graph_degree_block_Newton(trA, labels, 100, 1e-10);
    otherwise
        trP = compute_graph_prior(priorName, trA);   
end

%% run embedding
if strcmp(dataName, 'blog')
    k = 2000;
    isSubsample = true;
else
    k = n;
    isSubsample = false;
end
[~, postP] = train_embedding_cne(trA, trP, n, dim, s1, s2, k, gradTol, maxIter, 'subsample', isSubsample);

%% predict edges
[y_pred, y_true] = predict_edges(data, nVertex, nLabel, postP, valInds);

% save the result
save(sprintf('data=%s_prior=%s_dim=%d_s2=%.2f_randSeed=%d_foldIdx=%d.mat', ...
    dataName, priorName, dim, s2, randSeed, foldIdx), 'y_pred', 'y_true');
if ~isdeployed
    rmpath('../methods');
    rmpath('../data/');
    rmpath('../methods/lbfgsb/Matlab/');    
end
end