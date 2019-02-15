function [y_pred, y_true] = predict_edges_cne(data, nVertex, nLabel, postP, teInds)
    top_k_list = sum(full(data.group(teInds,:)), 2);
    probs = postP(teInds, nVertex+1:end);
    [~, sortInds] = sort(probs,2,'descend');
    y_pred = zeros(length(teInds), nLabel);
    for i = 1:length(teInds)
        k = top_k_list(i);
        y_pred(i, sortInds(i, 1:k)) = 1;
    end
    y_true = full(data.group(teInds, :));
end