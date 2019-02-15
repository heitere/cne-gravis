n = 196591;
E = 1 + dlmread('./Gowalla_edges.txt', '\t');
A = sparse(E(:,1), E(:,2), 1, n, n);            
A = A' | A;
save('gowalla.mat');