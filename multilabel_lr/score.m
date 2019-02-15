embedName = 'ppi_node2vec_full.emb';
networkName = '../data/PPI/Homo_sapiens.mat';
scoring = 'macro';

outputName = [embedName(1:end-4), '_', scoring, '.score'];

command = sprintf('python scoring.py --emb %s --network %s --num-shuffles 10 --scoring %s', embedName, networkName, scoring);
[~, pyOutput] = system(command);
fid = fopen(outputName,'w');
fprintf(fid, '%s', pyOutput);