function [scores, targets] = predict_edge_cne(postP, teE, negTeE)
    nTeX = size(teE, 1) + size(negTeE, 1);
    scores = zeros(nTeX, 1);
    idx = 1;
    for i = 1:size(teE, 1)
       scores(idx)  = postP(teE(i,1), teE(i,2));
       idx = idx+1;
    end
    for i = 1:size(negTeE, 1)
       scores(idx)  = postP(negTeE(i,1), negTeE(i,2));
       idx = idx+1;
    end
    targets = ones(nTeX, 1);
    targets(size(teE, 1) +1 : end) = 0;
end
