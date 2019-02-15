function [la,errors,ps,gla]=maxent_graph_degree_block_Newton(D,labels,nit,tol)
n = size(D,1);
lunique = unique(labels);
nlabels = length(lunique);
prows = full(sum(D,2));
blockMask = arrayfun(@(x) ones(1, x), histcounts(labels), 'UniformOutput', false);
blockMask = blkdiag(blockMask{:});
pblocks = blockMask*D*blockMask';
la=zeros(n + nlabels*nlabels,1);

lb=-5;
for k=1:nit-1
    E = exp(ones(n,1)*la(1:n)'/2 + la(1:n)*ones(1,n)/2 + ...
        blockMask'*reshape(la(n+1:end), nlabels, nlabels)'*blockMask);   
    ps=E./(1+E);
    ps = ps - diag(diag(ps));
    gla=[sum(ps,2) - prows; ...
        reshape((blockMask*ps*blockMask' - pblocks)', nlabels*nlabels, 1)];
    errors(k,1)=norm(gla);
    
    H=1/2*ps./(1+E);
    laRowBlock = 2*blockMask*H;
    subLaRowBlocks = arrayfun(@(x) laRowBlock(:, blockMask(x,:)==1), 1:nlabels, 'UniformOutput', false);
    rB = blkdiag(subLaRowBlocks{:});
    H = [H + diag(sum(H)) rB'; rB diag(reshape((2*blockMask*H*blockMask')', nlabels*nlabels, 1))];
%     H = H + trace(H)/n*1e-10;
    H = H + eye(length(la))*1e-10;
    
    deltala=-H\[gla];
    
    for f = logspace(0,-5,20)
        latry=la+f*deltala;
        Etry = exp(ones(n,1)*latry(1:n)'/2 + latry(1:n)*ones(1,n)/2 + ...
            blockMask'*reshape(latry(n+1:end), nlabels, nlabels)'*blockMask);   
        ytry = sum(sum(log(1+Etry))) - latry(1:n)'*prows - latry(n+1:end)'*reshape(pblocks, nlabels*nlabels, 1);
        
        y = sum(sum(log(1+E))) - la(1:n)'*prows - la(n+1:end)'*reshape(pblocks, nlabels*nlabels, 1);
        if ytry <= y + 1e-1*f*deltala'*gla
            la = la + f*deltala;
            break
        end        
    end    
end

E = exp(ones(n,1)*la(1:n)'/2 + la(1:n)*ones(1,n)/2 + ...
        blockMask'*reshape(la(n+1:end), nlabels, nlabels)'*blockMask);   
ps=E./(1+E);
ps = ps - diag(diag(ps));
gla=[sum(ps,2) - prows; ...
    reshape((blockMask*ps*blockMask' - pblocks)', nlabels*nlabels, 1)];
errors(end+1,1)=norm(gla);
end
