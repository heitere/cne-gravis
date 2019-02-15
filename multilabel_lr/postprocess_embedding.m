function postprocess_embedding(embedName, n)
    %% post process node2vec result.
    X = dlmread(embedName, ' ');      
    if X(1,1) < n
        fprintf('Post processing for %d missing points.\n', n-X(1,1));
    end
    while size(X, 2) ~= X(1,2) + 1
        disp(X(2,end));
        X(:,end) = [];
    end
    tempX = zeros(n, 128);    
    X(1,:) = [];    
    missingInds = true(1, n);
    missingInds(X(:,1)) = false;
    tempX(X(:,1), :) = X(:,2:end);
    tempX(missingInds, :) = X(randsample(size(X, 1), sum(missingInds)), 2:end);

    dlmwrite(embedName, size(tempX), 'delimiter', ' ');
    dlmwrite(embedName, [1:n;tempX']', 'delimiter', ' ', '-append');
end