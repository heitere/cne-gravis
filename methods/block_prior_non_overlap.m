function P = block_prior_non_overlap(A, labels)
    [bunique, ~, c] = unique(labels);
%     n = length(partitions);
    nunique = length(bunique);
    P = zeros(nunique,nunique);
    for i = 1:nunique
        for j = i:nunique
            indsI = find(c == i);
            indsJ = find(c == j);
            if i == j
                prob = sum(sum(A(indsI,indsJ)))/(length(indsI)*(length(indsJ)-1));            
            else
                prob = sum(sum(A(indsI,indsJ)))/(length(indsI)*(length(indsJ)));            
            end
            
            P(indsI, indsJ) = prob;
            if i ~= j
                P(indsJ, indsI) = prob;
            end
        end
    end
    P = P - diag(diag(P));
end