function [X, missInds] = train_embedding_LINE(dim, n, input, output)
    if ~exist(input, 'file')
        system(sprintf('touch %s', input));
    end
    if ~exist(output, 'file')
        system(sprintf('touch %s', output));
    end
    inPar =  sprintf(' -train ./%s', input);
    outPar = sprintf(' -output ./%s', output);
    dim_par = sprintf(' -size %d', dim);
    sample_par = sprintf(' -samples %d', 100);
    commandStr = ['./../methods/LINE/linux/line', inPar, outPar, dim_par, sample_par];
    system(commandStr);
    Y = dlmread(output);
    
    missInds = true(1,n);
    missInds(Y(2:end, 1)) = false;
    missInds = find(missInds);
    
    X = zeros(n, dim);
    X(Y(2:end, 1),:) = Y(2:end, 2:end);
end