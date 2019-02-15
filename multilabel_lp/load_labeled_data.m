function data = load_labeled_data(dataName)
switch dataName
    case 'blog'
        data = load('../data/BlogCatalog/blog.mat');
        data.network = logical(data.network);
    case 'ppi'
        data = load('../data/PPI/Homo_sapiens.mat');
        data.network = logical(data.network);
    case 'wiki'
        data =load('../data/Wiki/POS.mat');
        data.network = logical(data.network);
end