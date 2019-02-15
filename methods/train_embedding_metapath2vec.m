function [X, missInds] = train_embedding_metapath2vec(dim, n, input, output)
    if ~exist(input, 'file')
        system(sprintf('touch %s', input));
    end
    if ~exist(output, 'file')
        system(sprintf('touch %s', output));
    end
    inPar =  sprintf(' -train ./%s', input);
    outPar = sprintf(' -output ./%s', output);
    dim_par = sprintf(' -size %d', dim);
    min_count_par = sprintf(' -min-count %d', 1);
    negative_par = ' -negative 10';
    iter_par = sprintf(' -iter %d', 500);
    threads_par = sprintf(' -threads %d', 1);
    commandStr = ['./../methods/metapath2vec/metapath2vec', inPar, outPar, dim_par, threads_par, min_count_par, negative_par, iter_par];
    system(commandStr);
    system(['mv ', output, '.txt ', output]);    
    Y = dlmread(output);
    
    missInds = true(1,n);
    missInds(Y(2:end, 1)) = false;
    missInds = find(missInds);
    
    X = zeros(n, dim);
    X(Y(2:end, 1),:) = Y(2:end, 2:end);
end