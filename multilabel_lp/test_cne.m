function test_cne(dataName, priorName, randSeed, maxIter, s1, s2s, dims, nFold, gradTol)
if isdeployed
    randSeed = str2double(randSeed);
    maxIter = str2double(maxIter);
else 
    addpath('../methods');
    addpath('../data/');
    addpath('../methods/lbfgsb/Matlab/');    
end
rng(randSeed);



%% find the opt dim and s2
[optDim, optS2, micro_f1s, macro_f1s] = find_best_parameters_from_cv(dataName, priorName, dims, s2s, randSeed, nFold);
disp(micro_f1s);
disp(macro_f1s);
%% preprocess
% load data
data = load_labeled_data(dataName);
nVertex = size(data.network, 1);
nLabel = size(data.group, 2);
n = nVertex + nLabel;

% compute labels
labels = [ones(1,nVertex), ones(1,nLabel)*2];

% split test - train
test_portion = 0.5;
rng(randSeed);
teInds = subsample(data.group, test_portion);
teMask = zeros(1, nVertex); teMask(teInds) = 1;
trMask = ~teMask;
trInds = find(trMask);

% compute training graph
trA = sparse(n,n);
trA(1:nVertex,1:nVertex) = data.network;
trA(1:nVertex, nVertex+1:end) = data.group;
trA(teInds, nVertex+1:end) = zeros(length(teInds), nLabel);
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

if strcmp(dataName, 'blog')
    k = 2000;
    isSubsample = true;
else
    k = n;
    isSubsample = false;
end

[~, postP] = train_embedding_cne(trA, trP, n, optDim, s1, optS2, k, gradTol, maxIter, 'subsample', isSubsample);

%% predict edges
[y_tr_pred, y_tr_true] = predict_edges_cne(data, nVertex, nLabel, postP, trInds);
[y_te_pred, y_te_true] = predict_edges_cne(data, nVertex, nLabel, postP, teInds);

[micro_f1_tr, macro_f1_tr] = micro_macro_f1(y_tr_pred, y_tr_true);
[micro_f1_te, macro_f1_te] = micro_macro_f1(y_te_pred, y_te_true);

disp([micro_f1_tr, macro_f1_tr, micro_f1_te, macro_f1_te])

save(sprintf('f1_score_%s_%s_randSeed=%d', dataName, priorName,randSeed), 'micro_f1_tr', 'macro_f1_tr', 'micro_f1_te', 'macro_f1_te');

if ~isdeployed
    rmpath('../methods');
    rmpath('../data/');
    rmpath('../methods/lbfgsb/Matlab/');    
end

function [optDim, optS2, micro_f1s, macro_f1s] = find_best_parameters_from_cv(dataName, priorName, dims, s2s, randSeed, nFold)
        micro_f1s = zeros(length(dims), length(s2s));
        macro_f1s = zeros(length(dims), length(s2s));
        for dimIdx = 1:length(dims)
            dim = dims(dimIdx);
            for s2Idx = 1:length(s2s)
                s2 = s2s(s2Idx);
                y_pred_temp = [];
                y_true_temp = [];
                for foldIdx = 1:nFold                                            
                    load_result = load(sprintf('data=%s_prior=%s_dim=%d_s2=%.2f_randSeed=%d_foldIdx=%d.mat', ...
                        dataName, priorName, dim, s2, randSeed, foldIdx));
                    y_pred_fold = load_result.y_pred;
                    y_test_fold = load_result.y_true;
                    y_pred_temp = [y_pred_temp; y_pred_fold];
                    y_true_temp = [y_true_temp; y_test_fold];
                end
                
                [micro_f1, macro_f1] = micro_macro_f1(y_pred_temp, y_true_temp);
                micro_f1s(dimIdx, s2Idx) = micro_f1;
                macro_f1s(dimIdx, s2Idx) = macro_f1;        
            end
        end
        [optDimIdx,optS2Idx] = find(micro_f1s == max(max(micro_f1s)));
        optDim = dims(optDimIdx);
        optS2 = s2s(optS2Idx);
    end
end