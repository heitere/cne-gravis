addpath('../methods');
init;

run('cne', 'blog', '../data/BlogCatalog/blog_less.mat', 10, 'dim', 8, 'k', 50, 'prior', 'degree');
run('cne', 'blog', '../data/BlogCatalog/blog_less.mat', 10, 'dim', 8, 'k', 50, 'prior', 'uniform');
run('cne', 'ppi', '../data/PPI/Homo_sapiens.mat', 10, 'dim', 8, 'k', 50, 'prior', 'degree');
run('cne', 'ppi', '../data/PPI/Homo_sapiens.mat', 10, 'dim', 8, 'k', 50, 'prior', 'uniform');
run('cne', 'wiki', '../data/Wiki/POS_less.mat', 10, 'dim', 8, 'k', 50, 'prior', 'degree');
run('cne', 'wiki', '../data/Wiki/POS_less.mat', 10, 'dim', 8, 'k', 50, 'prior', 'uniform');

run('node2vec', 'blog', '../data/BlogCatalog/blog_less.mat', 10, 'p', 0.25, 'q', 0.25)
run('node2vec', 'ppi', '../data/PPI/Homo_sapiens.mat', 10, 'p', 4, 'q', 1)
run('node2vec', 'wiki', '../data/Wiki/POS_less.mat', 10, 'p', 4, 'q', 0.5)

run('deepwalk', 'blog', '../data/BlogCatalog/blog_less.mat', 10); 
run('deepwalk', 'ppi', '../data/PPI/Homo_sapiens.mat', 10);
run('deepwalk', 'wiki', '../data/Wiki/POS_less.mat', 10);

run('LINE', 'blog', '../data/BlogCatalog/blog_less.mat', 10); 
run('LINE', 'ppi', '../data/PPI/Homo_sapiens.mat', 10);
run('LINE', 'wiki', '../data/Wiki/POS_less.mat', 10);

run('metapath2vec', 'blog', '../data/BlogCatalog/blog_less.mat', 10); 
run('metapath2vec', 'ppi', '../data/PPI/Homo_sapiens.mat', 10);
run('metapath2vec', 'wiki', '../data/Wiki/POS_less.mat', 10);
