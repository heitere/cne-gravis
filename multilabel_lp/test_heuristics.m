function test_heuristics(dataName, methodName, randSeed)
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

%% compute embedding
d = 128;
switch methodName
    case 'common_neighbor'
        sim = common_neighbor(trE, n);
    case 'jarcard_similarity'   
        sim = jarcard_similarity(trE, n);
    case 'adamic_adar'   
        sim = adamic_adar(trE, n);
    case 'preferential_attachement'   
        sim = preferential_attachement(trE, n);
    otherwise 
        error('no such method.');
end      
%% predict edges

trP = sim(trInds, nVertex+1:end);
top_k_list = sum(full(data.group(trInds,:)), 2);
[~, sortInds] = sort(trP,2,'descend');
y_pred = zeros(length(trInds), nLabel);
for idx = 1:length(trInds)
    k = top_k_list(idx);
    y_pred(idx, sortInds(idx, 1:k)) = 1;
end
y_true = full(data.group(trInds, :));
[micro_f1_tr, macro_f1_tr] = micro_macro_f1(y_pred, y_true);

teP = sim(teInds, nVertex+1:end);
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

function sim = common_neighbor(E, n)
        A = sparse(E(:,1), E(:,2), 1,n,n);
        A = double(A | A');
        sim = A * A;
    end
    function sim = jarcard_similarity(E, n)
        A = sparse(E(:,1), E(:,2), 1,n,n);
        A = double(A | A');
        sim = A * A;
        deg_row = repmat(sum(A,1), [size(A,1),1]);
        deg_row = deg_row .* spones(sim);                               
        deg_row = triu(deg_row) + triu(deg_row');                      
        sim = sim./(deg_row.*spones(sim)-sim); 
        sim(isnan(sim)) = 0; sim(isinf(sim)) = 0;
    end
    function sim = adamic_adar(E, n)
        A = sparse(E(:,1), E(:,2), 1,n,n);
        A = double(A | A');
        A1 = A ./ repmat(log(sum(A,2)),1,size(A,1));         
        A1(isnan(A1)) = 0; 
        A1(isinf(A1)) = 0;          
        sim = A * A1;
    end
    function sim = preferential_attachement(E, n)
        A = sparse(E(:,1), E(:,2), 1,n,n);
        A = double(A | A');
        deg_row = sum(A,2);               
        sim = deg_row * deg_row'; 
    end
    function [scores, targets] = predict_heuristic(sim, posE, negE)
        nEdgeEmb = size(posE, 1) + size(negE, 1);
        scores = zeros(nEdgeEmb, 1);
        count = 0;
        posCount = 0;
        for idxEdge = 1:size(posE, 1)
            count = count + 1;
            posCount = posCount+1;
            scores(count) = sim(posE(idxEdge, 1), posE(idxEdge, 2));
        end 
        negCount = 0;
        for idxEdge = 1:size(negE, 1)
            count = count + 1;
            negCount = negCount+1;
            scores(count) = sim(negE(idxEdge, 1), negE(idxEdge, 2));
        end 
        targets = ones(posCount+negCount, 1);
        targets(posCount+1: end) = 0;
    end
end