function PG = compute_graph_prior(priorName, A)
    switch priorName
        case 'degree'
            [~,jrows,~,ps] = maxent_graph_no_loops_economical_Newton(A'|A,1000,1e-10);
            PG = ps(jrows,jrows);
            PG = PG - diag(diag(PG));
        case 'uniform'
            density = mean(mean(triu(A, 1)))*2;
            PG = ones(size(A))*density;
            PG = PG - diag(diag(PG));
        otherwise
            warning('un-identified prior name');
    end
end