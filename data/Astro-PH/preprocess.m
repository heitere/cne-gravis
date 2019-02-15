clear;
E = dlmread('CA-AstroPh.txt', '\t');
n = 18772;
[~,~, E(:,1)] = unique(E(:,1));
[~,~, E(:,2)] = unique(E(:,2));
A = sparse(E(:,1), E(:,2), 1, n, n); 
A = A' | A;
A = A - diag(diag(A));
save('CA-AstroPh.mat');