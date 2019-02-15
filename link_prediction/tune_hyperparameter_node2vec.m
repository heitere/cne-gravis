function aucs = tune_hyperparameter_node2vec(n, dataName, input, output, seed)
    %% prepair the files
    if ~exist(input, 'file')
        system(sprintf('touch %s', input));
    end
    if ~exist(output, 'file')
        system(sprintf('touch %s', output));
    end
    %% set up inital parameters
    % dims = [2,8,32,128];
    ps = [0.25, 0.5, 1, 2, 4];
    qs = [0.25, 0.5, 1, 2, 4];
%     ps = [p];
%     qs = [q];
    dims = [128];
    
    %% randomly removle 50% edges while remail connectivity.
    trE = csvread(sprintf('./train_test/%s_trE_%d.csv', dataName, seed-1))+1;
    negTrE = csvread(sprintf('./train_test/%s_negTrE_%d.csv', dataName, seed-1))+1;
    teE = csvread(sprintf('./train_test/%s_teE_%d.csv', dataName, seed-1))+1;
    negTeE = csvread(sprintf('./train_test/%s_negTeE_%d.csv', dataName, seed-1))+1;
    trA = sparse(trE(:,1), trE(:,2), 1, n, n);
    trA = trA | trA';
    
    %% generate edgelist for python
%     [I,J] = find(triu(trA,1)==1);
    [I,J] = find(trA == 1);
    dlmwrite(input, [I,J], 'delimiter', ' ');        
    %% compute aucs
    aucs = zeros(length(dims), length(ps), length(qs));
    for dimIdx = 1:length(dims)
        dim = dims(dimIdx);
        disp(['dim: ', num2str(dim)]);
        for pIdx = 1:length(ps)
            for qIdx = 1:length(qs)
                p = ps(pIdx);
                q = qs(qIdx);            
                [X, missInds] = train_embedding_node2vec(dim,p, q, n, input, output);
                [~,aucs(dimIdx, pIdx, qIdx)] = predict_edge_other(X, missInds, trE, negTrE, teE, negTeE);
            end
        end
    end   
end