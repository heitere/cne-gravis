%% set up
if ~isdeployed
    addpath('../methods');
    addpath('../data/');
    addpath('../methods/lbfgsb/Matlab/');    
end
%% set the parameters
randSeed = 1;
maxIter = 2000;
priorName = 'block';

%% block
dataName = 'blog';
memory_in_gb=16; 
write_test_pbs(dataName, priorName, randSeed, maxIter, memory_in_gb);

%% ppi
dataName = 'ppi';
memory_in_gb=2; 
write_test_pbs(dataName, priorName, randSeed, maxIter, memory_in_gb);

%% wiki
dataName = 'wiki';
memory_in_gb=2; 
write_test_pbs(dataName, priorName, randSeed, maxIter, memory_in_gb);
%% remove path
if ~isdeployed
    rmpath('../methods');
    rmpath('../data/');
    rmpath('../methods/lbfgsb/Matlab/');    
end
