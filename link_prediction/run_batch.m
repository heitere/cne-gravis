addpath('../methods');
init;

run('cne', 'arxiv', 10, 'dim', 16, 'k', 50, 'prior', 'degree');
run('cne', 'facebook', 10, 'dim', 8, 'k', 50, 'prior', 'degree');
run('cne', 'ppi', 10, 'dim', 8, 'k', 50, 'prior', 'degree');
run('cne', 'studentdb', 10, 'dim', 8, 'k', 50, 'prior', 'degree');
run('cne', 'wiki', 10, 'dim', 8, 'k', 50, 'prior', 'degree');
run('cne', 'blog', 10, 'dim', 8, 'k', 50, 'prior', 'degree');
run('cne', 'gowalla', 10, 'dim', 16, 'k', 50, 'prior', 'degree');

run('cne', 'arxiv', 10, 'dim', 16, 'k', 50, 'prior', 'uniform');
run('cne', 'facebook', 10, 'dim', 8, 'k', 50, 'prior', 'uniform');
run('cne', 'ppi', 10, 'dim', 8, 'k', 50, 'prior', 'uniform');
run('cne', 'studentdb', 10, 'dim', 8, 'k', 50, 'prior', 'uniform');
run('cne', 'wiki', 10, 'dim', 8, 'k', 50, 'prior', 'uniform');
run('cne', 'blog', 10, 'dim', 8, 'k', 50, 'prior', 'uniform');

% CNE with block prior, need to adapt the eval_cne function accordingly. 
% run('cne', 'studentdb', 10, 'dim', 8, 'k', 50, 'prior', 'block');

run('node2vec', 'arxiv', 10, 'p', 0.5, 'q', 4)
run('node2vec', 'facebook', 10, 'p', 4, 'q', 2)
run('node2vec', 'ppi', 10, 'p', 4, 'q', 1)
run('node2vec', 'studentdb', 10, 'p', 0.5, 'q', 4)
run('node2vec', 'wiki', 10, 'p', 4, 'q', 0.5)
run('node2vec', 'blog', 10, 'p', 0.25, 'q', 0.25)

run('deepwalk', 'arxiv', 10); 
run('deepwalk', 'facebook', 10);
run('deepwalk', 'ppi', 10);
run('deepwalk', 'studentdb', 10);
run('deepwalk', 'wiki', 10);
run('deepwalk', 'blog', 10);


run('LINE', 'arxiv', 10); 
run('LINE', 'facebook', 10);
run('LINE', 'ppi', 10);
run('LINE', 'studentdb', 10);
run('LINE', 'wiki', 10);
run('LINE', 'blog', 10);

run('metapath2vec', 'arxiv', 10); 
run('metapath2vec', 'facebook', 10);
run('metapath2vec', 'ppi', 10);
run('metapath2vec', 'studentdb', 10);
run('metapath2vec', 'wiki', 10);
run('metapath2vec', 'blog', 10);

run('common_neighbor', 'arxiv', 10); 
run('common_neighbor', 'facebook', 10);
run('common_neighbor', 'ppi', 10);
run('common_neighbor', 'studentdb', 10);
run('common_neighbor', 'wiki', 10);
run('common_neighbor', 'blog', 10);

run('jarcard_similarity', 'arxiv', 10); 
run('jarcard_similarity', 'facebook', 10);
run('jarcard_similarity', 'ppi', 10);
run('jarcard_similarity', 'studentdb', 10);
run('jarcard_similarity', 'wiki', 10);
run('jarcard_similarity', 'blog', 10);

run('adamic_adar', 'arxiv', 10); 
run('adamic_adar', 'facebook', 10);
run('adamic_adar', 'ppi', 10);
run('adamic_adar', 'studentdb', 10);
run('adamic_adar', 'wiki', 10);
run('adamic_adar', 'blog', 10);

run('preferential_attachement', 'arxiv', 10); 
run('preferential_attachement', 'facebook', 10);
run('preferential_attachement', 'ppi', 10);
run('preferential_attachement', 'studentdb', 10);
run('preferential_attachement', 'wiki', 10);
run('preferential_attachement', 'blog', 10);
