function plotter_static(ax, X, A, labels, info, types, hasLegend)
    colorScheme = loadColorScheme(7);   
%     fig = figure; 
    gplot(A,[X(:,1) X(:,2)]);
    hold on;
    h=findobj(ax, 'type','line');
    set(h,'Color', [0.75 0.75 0.75 0.5]);
%     set(h,'Color', [0.75 0.75 0.75 0.1]);
    [lunique, ~,~] = unique(labels);
    handles = zeros(length(lunique),1);
    degrees = sum(full(A));
    order = [1,3,5,6,7,2,4];
    types = types(order);
    for i = 1:length(lunique)
        idx = order(i);
        inds = find(labels == lunique(idx));
        handles(i) = scatter(ax, X(inds,1), X(inds,2), log(degrees(inds)+1)*16, repmat(colorScheme(idx,:), length(inds), 1), 'filled','MarkerEdgeColor', [0.75 0.75 0.75]);
    end
    
    if hasLegend
        legend(handles, types, 'Location', 'southwest');
    end
end