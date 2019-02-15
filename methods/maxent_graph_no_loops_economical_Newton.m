function [la,jrows,errors,ps,gla]=maxent_graph_no_loops_economical_Newton(D,nit,tol)

%function [la,jrows,errors,ps,gla]=maxent_graph_no_loops_economical_Newton(D,nit,tol)
%function [la,jrows,errors,ps,gla]=maxent_graph_no_loops_economical_Newton(degrees,nit,tol)

[n,m]=size(D);
if m==n
    prows=full(sum(D,2))/n;
elseif n>m
    degrees = D;
    prows = degrees/n;
else
    degrees = D;
    n=m;
    prows = degrees'/n;
end
clear m

% This method is a Newton, with determination of step length.
% The fact that rows with same prows and columns with same pcols values
% will result in the same la and mu values is exploited.

[prowsunique,irows,jrows]=unique(prows);
nunique=length(prowsunique);

la=zeros(nunique,1);
h=zeros(nunique,1);

vrows=zeros(nunique,1);
for i=1:nunique
    vrows(i)=length(find(jrows==i));
end

lb=-5;
for k=1:nit-1
    E=(ones(nunique,1)*exp(la/2)').*(exp(la/2)*ones(1,nunique));
    ps=E./(1+E);
    gla=(-n*prowsunique+ps*vrows -diag(ps)).*vrows; % The -diag(ps) term is to account for the fact that the diagonals will be zero in the model!
    errors(k,1)=norm(gla);
    
    H=1/2*diag(vrows)*(E./(1+E).^2)*diag(vrows);
    H=H+diag(sum(H))-2*diag(diag(H)./vrows);
    H = H + trace(H)/nunique*1e-10;
    
    deltala=-H\[gla];
    
    fbest=0;
    errorbest=errors(k);
    for f=logspace(lb,1,20)
        latry=la+f*deltala;
        Etry=(ones(nunique,1)*exp(latry/2)').*(exp(latry/2)*ones(1,nunique));
        pstry=Etry./(1+Etry);
        glatry=(-n*prowsunique+pstry*vrows -diag(pstry)).*vrows; % The -diag(pstry) term is to account for the fact that the diagonals will be zero in the model!
        errortry=norm(glatry);
        if errortry<errorbest
            fbest=f;
            errorbest=errortry;
        end
    end
    if fbest==0
        lb=lb*2;
    end
    
    la=la+fbest*deltala;
    
    if errors(k)/n<tol
        break
    end
end

E=(ones(nunique,1)*exp(la/2)').*(exp(la/2)*ones(1,nunique));
ps=E./(1+E);
gla=(-n*prowsunique+ps*vrows -diag(ps)).*vrows;
errors(end+1,1)=norm(gla);

%figure,imagesc(log(ps)),colorbar
%figure,imagesc(log(ps(jrows,jcols))),colorbar
%figure,plot(log(errors))

% P = ps(jrows,jrows);
% P = P - diag(diag(P));

