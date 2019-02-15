function test_emb_methods(dataName, methodName, randSeed)
if isdeployed
    randSeed = str2double(randSeed);   
else 
    addpath('../methods');
    addpath('../data/');
    addpath('../methods/lbfgsb/Matlab/');    
%     init;
end
rng(randSeed);

%% preprocess
% load data
data = load_labeled_data(dataName);
nVertex = size(data.network, 1);
nLabel = size(data.group, 2);
n = nVertex + nLabel;

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

[I, J] = find(trA == 1);
trE = [I, J];
%% output train test edges
input = [dataName, '.edgelist'];
output = [dataName, '.', methodName, '.emb'];
if strcmp(methodName, 'LINE')
    dlmwrite(input, [trE, ones(size(trE,1),1)], 'delimiter', ' ');
else
    dlmwrite(input, trE, 'delimiter', ' ');
end



%% set parameters for node2vec
p = 1;
q = 1;
if strcmp(dataName, 'blog')
    p = 0.25;
    q = 0.25;
end
if strcmp(dataName, 'ppi')
    p = 4;
    q = 1;
end
if strcmp(dataName, 'wiki')
    p = 4;
    q = 0.5;
end
%% compute embedding
d = 128;
switch methodName
    case 'node2vec'
        [X, ~] = train_embedding_node2vec(d, p, q, n, input, output);
    case 'LINE'
        [X, ~] = train_embedding_LINE(d, n, input, output);
    case 'deepwalk'
        [X, ~] = train_embedding_deepwalk(d, n, input, output);
    case 'metapath2vec'
        [X, ~] = train_embedding_metapath2vec(d, n, input, output);
    otherwise 
        error('no such method.');
end      
%% predict edges
[trEdgeEmb, trY] = compute_X_y(X, data.group, trInds, nVertex);
[teEdgeEmb, ~] = compute_X_y(X, data.group, teInds, nVertex);
CVMdl = fitclinear(trEdgeEmb,trY,'Learner','logistic', 'Regularization', 'ridge');

nLabels = size(data.group, 2);
nTr = length(trInds);
nTe = length(teInds);

[~,trP] = predict(CVMdl,trEdgeEmb);
[~,teP] = predict(CVMdl,teEdgeEmb);

trP = reshape(trP(:,2),nLabels, nTr)';

top_k_list = sum(full(data.group(trInds,:)), 2);
[~, sortInds] = sort(trP,2,'descend');
y_pred = zeros(length(trInds), nLabel);
for idx = 1:length(trInds)
    k = top_k_list(idx);
    y_pred(idx, sortInds(idx, 1:k)) = 1;
end
y_true = full(data.group(trInds, :));
[micro_f1_tr, macro_f1_tr] = micro_macro_f1(y_pred, y_true);

teP = reshape(teP(:,2),nLabels, nTe)';
top_k_list = sum(full(data.group(teInds,:)), 2);
[~, sortInds] = sort(teP,2,'descend');
y_pred = zeros(length(teInds), nLabel);
for idx = 1:length(teInds)
    k = top_k_list(idx);
    y_pred(idx, sortInds(idx, 1:k)) = 1;
end
y_true = full(data.group(teInds, :));
[micro_f1_te, macro_f1_te] = micro_macro_f1(y_pred, y_true);

disp([micro_f1_tr, macro_f1_tr, micro_f1_te, macro_f1_te])

save(sprintf('f1_score_%s_%s_randSeed=%d\n', dataName, methodName,randSeed), 'micro_f1_tr', 'macro_f1_tr', 'micro_f1_te', 'macro_f1_te');

if ~isdeployed
    rmpath('../methods');
    rmpath('../data/');
    rmpath('../methods/lbfgsb/Matlab/');    
end
    
function [X, y] = compute_X_y(emb, labels, inds, nVertex)
    X = zeros(length(inds)*size(labels,2), size(emb, 2));    
    y = reshape(labels(inds,:)', length(inds)*size(labels,2), 1);
    lEmb = emb(nVertex+1:end, :);
    for i = 1:length(inds)
        vEmb = emb(inds(i), :);        
        X((i-1)*size(labels, 2)+1 : i*size(labels, 2), :) = repmat(vEmb, size(labels,2), 1).*lEmb;
    end
end


end