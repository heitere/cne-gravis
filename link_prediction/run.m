function run(method, dataName, numRandSeed, varargin)
%% parse arguments
par = inputParser;
addOptional(par, 'p', 1.0);
addOptional(par, 'q', 1.0);
addOptional(par, 'dim', 32);
addOptional(par, 'k', 50);
addOptional(par, 'prior', 'other');
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
[~, ~, n] = load_data(dataName);
scores = zeros(numRandSeed, 1);
format('long');
for seed = 1:numRandSeed
    rng(seed);
    disp(seed);
    switch method
        case 'cne'
            [scores(seed, 1), scores(seed, 2)] = eval_cne(n, dim, ...
                k, par.Results.prior, dataName, seed);
        case 'node2vec'
            [scores(seed, 1), scores(seed, 2)] = eval_other(n, 128, dataName, ... 
                method, seed, 'p', p, 'q', q);
        otherwise 
            [scores(seed, 1), scores(seed, 2)] = eval_other(n, 125, dataName, ...
                method, seed);
    end        
    disp(scores(seed, :));
    save(['hpc_',method,'_',dataName,'_',par.Results.prior], 'scores');
end

%% clean up
if ~isdeployed
    rmpath('../methods');
    rmpath('../data/');
    rmpath('../methods/lbfgsb/Matlab/');
end
end