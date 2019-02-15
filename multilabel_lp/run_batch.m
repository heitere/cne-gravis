%% set up
if ~isdeployed
    addpath('../methods');
    addpath('../data/');
    addpath('../methods/lbfgsb/Matlab/');    
end

%% train test CNE
s1 = 1;
s2s = [1.05, 1.25, 1.75, 2];
dims = [4, 8, 16, 32, 48];
randSeed = 1;
nFold = 10;
gradTol = 1e-2;
maxIter = 500;
priorName = 'block';
dataName = 'blog';
% dataName = 'ppi';
% dataName = 'wiki';

for fold_idx = 1:nFold
    for s2_idx = 1:length(s2s)
        s2 = s2s(s2_idx);
        for dim_idx = 1:length(dims)
            dim = dims(dim_idx);
            tune_cne(dataName, priorName, dim, s1, s2, randSeed, fold_idx, gradTol, maxIter)
        end
    end
end
test_cne(dataName, priorName, randSeed, maxIter, s1, s2s, dims, nFold, gradTol)
%%
test_emb_methods('blog', 'node2vec', 10)
test_emb_methods('ppi', 'node2vec', 10)
test_emb_methods('wiki', 'node2vec', 10)

test_emb_methods('blog', 'LINE', 10)
test_emb_methods('ppi', 'LINE', 10)
test_emb_methods('wiki', 'LINE', 10)

test_emb_methods('blog', 'deepwalk', 10)
test_emb_methods('ppi', 'deepwalk', 10)
test_emb_methods('wiki', 'deepwalk', 10)

test_emb_methods('blog', 'metapath2vec', 10)
test_emb_methods('ppi', 'metapath2vec', 10)
test_emb_methods('wiki', 'metapath2vec', 10)

test_heuristics('blog', 'common_neighbor', 10)
test_heuristics('ppi', 'common_neighbor', 10)
test_heuristics('wiki', 'common_neighbor', 10)

test_heuristics('blog', 'jarcard_similarity', 10)
test_heuristics('ppi', 'jarcard_similarity', 10)
test_heuristics('wiki', 'jarcard_similarity', 10)

test_heuristics('blog', 'adamic_adar', 10)
test_heuristics('ppi', 'adamic_adar', 10)
test_heuristics('wiki', 'adamic_adar', 10)

test_heuristics('blog', 'preferential_attachement', 10)
test_heuristics('ppi', 'preferential_attachement', 10)
test_heuristics('wiki', 'preferential_attachement', 10)