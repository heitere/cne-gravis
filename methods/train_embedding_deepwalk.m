function [X, missInds] = train_embedding_deepwalk(dim, n, input, output)
    if ~exist(input, 'file')
        system(sprintf('touch %s', input));
    end
    if ~exist(output, 'file')
        system(sprintf('touch %s', output));
    end
    in_par =  sprintf(' --input ./%s', input);
    out_par = sprintf(' --output ./%s', output);
    dim_par = sprintf(' --representation-size %d', dim);   
    format_par = sprintf(' --format %s', 'edgelist');
    commandStr = ['deepwalk ', format_par, in_par, out_par, dim_par];
    system(commandStr);
    Y = dlmread(output);
    
    missInds = true(1,n);
    missInds(Y(2:end, 1)) = false;
    missInds = find(missInds);
    
    X = zeros(n, dim);
    X(Y(2:end, 1),:) = Y(2:end, 2:end);
end