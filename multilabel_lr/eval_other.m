function eval_other(n, networkName, name, method, seed, varargin)
    %% parse arguments
    par = inputParser;
    addOptional(par, 'p', 1.0);
    addOptional(par, 'q', 1.0);
    parse(par, varargin{:});
    %% prepair the files
    embedName = [name, '_', method, '_', num2str(seed), '.emb'];
    edgeListName = [name, '.edgelist'];
    if ~exist(embedName, 'file')
        system(sprintf('touch %s', embedName));
    end
    %% set up inital parameters
    dim = 128;
    %% compute embedding
    switch method
        case 'node2vec'
            train_embedding_node2vec(dim, par.Results.p, par.Results.q,  n, edgeListName, embedName);
        case 'deepwalk'
            train_embedding_deepwalk(dim, n, edgeListName, embedName);
        case 'LINE'
            train_embedding_LINE(dim, n, edgeListName, embedName);
        case 'metapath2vec'
            train_embedding_metapath2vec(dim, n, edgeListName, embedName);
        otherwise
            error('no such method');
    end

    %% post processing
    postprocess_embedding(embedName, n);

    %% compute F1 scores
    compute_score(embedName, networkName);

end
