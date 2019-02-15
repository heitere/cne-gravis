function [X, missInds] = train_embedding_node2vec(dim, p, q, n, input, output)
    if ~exist(input, 'file')
        system(sprintf('touch %s', input));
    end
    if ~exist(output, 'file')
        system(sprintf('touch %s', output));
    end
    inPar =  sprintf(' --input ./%s', input);
    outPar = sprintf(' --output ./%s', output);
    dim_par = sprintf(' --dimensions %d', dim);
    p_par = sprintf(' --p %f', p);
    q_par = sprintf(' --q %f', q);
    commandStr = ['python ../methods/node2vec/main.py', inPar, outPar, dim_par, p_par,...
              q_par];
    system(commandStr);
    Y = dlmread(output);
    
    missInds = true(1,n);
    missInds(Y(2:end, 1)) = false;
    missInds = find(missInds);
    
    X = zeros(n, dim);
    X(Y(2:end, 1),:) = Y(2:end, 2:end);
end