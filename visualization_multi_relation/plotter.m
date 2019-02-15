function plotter(X, A, labels, info, types)
    colorScheme = loadColorScheme(7);   
    fig = figure; 
    gplot(A,[X(:,1) X(:,2)]);
    hold on;
    h=findobj(fig, 'type','line');
    set(h,'Color', [0.75 0.75 0.75 0.1]);
    [lunique, ~,~] = unique(labels);
    handles = zeros(length(lunique),1);
    degrees = sum(full(A));
    order = [1,3,5,6,7,2,4];
    types = types(order);
    for i = 1:length(lunique)
        idx = order(i);
        inds = find(labels == lunique(idx));
        handles(i) = scatter(X(inds,1), X(inds,2), log(degrees(inds)+1)*16, repmat(colorScheme(idx,:), length(inds), 1), 'filled');
%         handles(i) = scatter(X(inds,1), X(inds,2), 30, repmat(colorScheme(i,:), length(inds), 1), 'filled');
    end
    
    
    legend(handles, types, 'Location', 'best');
%     text(X(:,1), X(:,2), sprintfc('%d', 1:size(X,1)));
    
    % https://stackoverflow.com/questions/15488810/
    % how-to-find-the-index-from-a-large-scatter-plot-in-matlab
    dcm_obj = datacursormode(fig);
    set(dcm_obj,'UpdateFcn',@myupdatefcn)
    function output_txt = myupdatefcn(obj, event_obj)
        pos = get(event_obj,'Position');

        % Import x and y
        x = get(get(event_obj,'Target'),'XData');
        y = get(get(event_obj,'Target'),'YData');

        % Find index
        index_x = find(X(:,1) == pos(1));
        index_y = find(X(:,2) == pos(2));
        index = intersect(index_x,index_y);
        
        % Set output text
        output_txt = {['Index: ', num2str(index)], ...                      
                      ['Descr.: ', info{index}]};
    end
end