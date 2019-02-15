%% node2vec path
node2vecPath = ['/Users/Klinux/anaconda/bin', pathsep];

%% deepwalk path
deepwalkPath = ['/Users/Klinux/anaconda/envs/py36/bin/', pathsep];

%% set path
setenv('PATH', [node2vecPath, deepwalkPath, getenv('PATH')]);