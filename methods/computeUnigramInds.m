function unigramInds = computeUnigramInds(A, n)
    degree = sum(A, 1);
    freq = degree / sum(degree);
    sampProb = freq.^.75 / sum(freq.^.75);
    unigramInds = repelem(1:n, round(sampProb*10^(ceil(log10(n))+2)));
end