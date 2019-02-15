function eval_cne(A, n, d, k, priorName, networkName, name, seed)
    %% set up inital parameters
    s1 = 1;
    s2 = 2;

    embedName = [name, '_cne_', priorName, '_d=', num2str(d), '_k=', num2str(k), ...
        '_seed=', num2str(seed), '.emb'];

    %% compute graph prior
    P = compute_graph_prior(priorName, A);

    %% compute embedding
    [X, ~] = train_embedding_cne(A, P, n, d, s1, s2, k, 1e-2, 2500);

    %% output the embedding
    dlmwrite(embedName, size(X), 'delimiter', ' ');
    dlmwrite(embedName, [1:n;X']', 'delimiter', ' ', '-append');

    compute_score(embedName, networkName);
end
