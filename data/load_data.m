function [A, E, n] = load_data(dataName)
    switch dataName
        case 'facebook'
            data = load('../data/Facebook/facebook.mat');
            A = data.A;
            E = data.E;
            n = data.n;
        case 'ppi'
            data = load('../data/PPI/Homo_sapiens.mat');
            A = data.network;
            n = size(A, 1);
            [I, J] = find(triu(A,1));
            E = [I, J];
        case 'arxiv'
            data = load('../data/Astro-PH/CA-AstroPh.mat');            
            A = data.A;
            E = data.E;
            n = data.n;
        case 'wiki'
            data = load('../data/Wiki/POS.mat');
            A = data.network;
            [I, J] = find(triu(A,1));
            E = [I, J];
            n = size(A,1);
        case 'blog'
            data = load('../data/BlogCatalog/blog.mat');
            A = data.network;
            [I, J] = find(triu(A,1));
            E = [I, J];
            n = size(A,1);
        case 'studentdb'
            data = load('../data/studentdb/studentdb.mat');
            A = data.A;
            E = data.E;
            n = data.n;
        case 'email'
            data = load('../data/email/email.mat');
            A = data.A;
            E = data.E;
            n = data.n;
        case 'gowalla'
            data = load('../data/gowalla/gowalla.mat');
            A = data.A;
            E = data.E;
            n = data.n;
        otherwise
            warning('Non-existing dataset.');
    end 
    A = A' | A;
    A = A - diag(diag(A));
end