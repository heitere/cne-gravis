%% set up
if ~isdeployed
    addpath('../methods');
    addpath('../data/');
    addpath('../methods/lbfgsb/Matlab/');    
end
%% set the parameters
s1 = 1;
s2s = [1.05, 1.25, 1.75, 2];
dims = [4, 8, 16, 32, 48];
randSeed = 1;
nFold = 5;
gradTol = 1e-2;
maxIter = 500;
priorName = 'block';

%% block
dataName = 'blog';
memory_in_gb=16; 
write_tune_pbs(dataName, priorName, dims, s1, s2s, randSeed, nFold, gradTol, maxIter, memory_in_gb);

%% ppi
dataName = 'ppi';
memory_in_gb=2; 
write_tune_pbs(dataName, priorName, dims, s1, s2s, randSeed, nFold, gradTol, maxIter, memory_in_gb);

%% wiki
dataName = 'wiki';
memory_in_gb=2; 
write_tune_pbs(dataName, priorName, dims, s1, s2s, randSeed, nFold, gradTol, maxIter, memory_in_gb);

%% remove path
if ~isdeployed
    rmpath('../methods');
    rmpath('../data/');
    rmpath('../methods/lbfgsb/Matlab/');    
end
