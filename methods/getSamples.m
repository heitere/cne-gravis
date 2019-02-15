function inds = getSamples(tarIdx, K, n, unigramInds)
    sampIndLen = length(unigramInds);        
    inds = zeros(1, K);
    mask = false(1,n);
    mask(tarIdx) = true;
    for k = 1:K
        newIdx = unigramInds(randi(sampIndLen));
        while mask(newIdx)
            newIdx = unigramInds(randi(sampIndLen));
        end
        mask(newIdx) = true;
        inds(k) = newIdx;
    end
end