function run(method, dataName, matFileName, numRandSeed, varargin)
%% parse arguments
par = inputParser;
addOptional(par, 'p', 1.0);
addOptional(par, 'q', 1.0);
addOptional(par, 'dim', 8);
addOptional(par, 'k', 50);
addOptional(par, 'prior', 'degree');
parse(par, varargin{:});

p = par.Results.p;
q = par.Results.q;
dim = par.Results.dim;
k = par.Results.k;
%% set up
if ~isdeployed
    addpath('../methods');
    addpath('../data/');
    addpath('../methods/lbfgsb/Matlab/');    
    init;
else    
    numRandSeed = str2double(numRandSeed);
    p = str2double(p);
    q = str2double(q);
    dim = str2double(dim);
    k = str2double(k);    
end
%% 
[A, ~, n] = load_data(dataName);
for seed = 1:numRandSeed
    rng(seed);
    switch method
        case 'cne'
            eval_cne(A, n, dim, k, par.Results.prior, matFileName, dataName, seed);
        case 'node2vec'
            generate_edgelist(A, dataName, method);
            eval_other(n, matFileName, dataName, method, seed, p, q);
        otherwise 
            generate_edgelist(A, dataName, method);
            eval_other(n, matFileName, dataName, method, seed);   
    end    
end

%% clean up
if ~isdeployed
    rmpath('../methods');
    rmpath('../data/');
    rmpath('../methods/lbfgsb/Matlab/');
end
end