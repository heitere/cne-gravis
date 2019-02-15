function [aucTr, aucTe] = eval_other(n, dim, dataName, methodName, seed, varargin)
    %% parse arguments
    par = inputParser;
    addOptional(par, 'p', 1.0);
    addOptional(par, 'q', 1.0);
    parse(par, varargin{:});
    
    %% prepair the files
    input = sprintf('%s.edgelist', dataName);
    output = sprintf('%s.emb', dataName);
    if ~exist(input, 'file')
        system(sprintf('touch %s', input));
    end
    if ~exist(output, 'file')
        system(sprintf('touch %s', output));
    end    
          
    %% randomly removle 50% edges while remail connectivity.
    trE = csvread(sprintf('./train_test/%s_trE_%d.csv', dataName, seed-1))+1;            
    negTrE = csvread(sprintf('./train_test/%s_negTrE_%d.csv', dataName, seed-1))+1;
    teE = csvread(sprintf('./train_test/%s_teE_%d.csv', dataName, seed-1))+1;
    negTeE = csvread(sprintf('./train_test/%s_negTeE_%d.csv', dataName, seed-1))+1;    
    trA = sparse(trE(:,1), trE(:,2), 1, n, n);
    trA = trA | trA';
    
    %% generate edgelist for python
    [I,J] = find(trA == 1);
    dlmwrite(input, [I,J], 'delimiter', ' ');            
    %% compute aucs
    predictionMethod = 'logistic_regression';
    switch methodName
        case 'node2vec'
            [X, missInds] = train_embedding_node2vec(dim, par.Results.p, par.Results.q,n, input, output);
        case 'LINE'
            dlmwrite(input, [trE, ones(size(trE,1),1)], 'delimiter', ' ');
            [X, missInds] = train_embedding_LINE(dim, n, input, output);
        case 'deepwalk'
            [X, missInds] = train_embedding_deepwalk(dim, n, input, output);
        case 'metapath2vec'
            [X, missInds] = train_embedding_metapath2vec(dim, n, input, output);
        case 'common_neighbor'
            predictionMethod = 'common_neighbor';
            X = []; missInds = [];            
        case 'jarcard_similarity'
            predictionMethod = 'jarcard_similarity';            
            X = []; missInds = [];            
        case 'adamic_adar'
            predictionMethod = 'adamic_adar';            
            X = []; missInds = [];            
        case 'preferential_attachement'
            predictionMethod = 'preferential_attachement';
            X = []; missInds = [];            
        otherwise 
            error('no such method.');
    end
    
    [aucTr, aucTe] = predict_edge_other(X, missInds, n, trE, negTrE, teE, negTeE, predictionMethod);

    %% clean up
    delete(input);
    delete(output);
end