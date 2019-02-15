function [aucTr, aucTe] = eval_cne(n, dim, k, priorName, dataName, seed)
    %% set up inital parameters
    s1 = 1;
    s2 = 2;
    lineSep = 0:0.05:1;
    %% randomly removle 50% edges while remail connectivity.
    trE = csvread(sprintf('./train_test/%s_trE_%d.csv', dataName, seed-1))+1;
    negTrE = csvread(sprintf('./train_test/%s_negTrE_%d.csv', dataName, seed-1))+1;
    teE = csvread(sprintf('./train_test/%s_teE_%d.csv', dataName, seed-1))+1;
    negTeE = csvread(sprintf('./train_test/%s_negTeE_%d.csv', dataName, seed-1))+1;
    trA = sparse(trE(:,1), trE(:,2), 1, n, n);
    trA = trA | trA';

    %% compute graph prior
%     data = load('../data/smurfig/studentdb.mat');
%     trP = block_prior_non_overlap(trA, data.nodeLabels);
    trP = compute_graph_prior(priorName, trA);

    %% compute aucs
    [~, postP] = train_embedding_cne(trA, trP, n, dim, s1, s2, k, 1e-2, 1500);

    %% auc in training data
    [scores, targets] = predict_edge_cne(postP, trE, negTrE);
    [~,~, ~, aucTr] = perfcurve(targets, scores, 1, ...
        'XVals', lineSep);

    %% auc in test data
    [scores, targets] = predict_edge_cne(postP, teE, negTeE);
    [~,~, ~, aucTe] = perfcurve(targets, scores, 1, ...
        'XVals', lineSep);
end
