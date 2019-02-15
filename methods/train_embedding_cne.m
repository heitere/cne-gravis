function [X, postP] = train_embedding_cne(A, PG, n, d, s1, s2, k, pgtol, maxIter, varargin)
    %% parse arguments
    par = inputParser;
    addOptional(par, 'subsample', true);
    parse(par, varargin{:});
%     invS1p2 = 1/s1^2;
%     invS2p2 = 1/s2^2;
% 
%     invZ1 = 1/(2*pi)^(d/2)/s1^d;
%     invZ2 = 1/(2*pi)^(d/2)/s2^d;

    S1DivS2 = s1/s2;
    S2DivS1 = s2/s1;
    coeff1 = (s2^2-s1^2)/(2*s1^2*s2^2);
    coeff2 = -coeff1;
    if par.Results.subsample
        [sampleInds, sampleMask] = subSample(A, n, k);
    else
        [sampleInds, sampleMask] = noSample(A, n, k);
    end
%     [sampleInds, sampleMask] = subSampleWeighted(A, n, k);
    samplePG = zeros(n, 2*k);
    for i = 1:n
        samplePG(i,:) = PG(i,sampleInds(i,:));
    end
    X0 = 1 * randn(n*d,1);

    l  = -inf(n*d,1);    % lower bound
    u  = inf(n*d,1);      % there is no upper bound

    opts = struct( 'factr', 1e4, 'pgtol', pgtol, 'm', 20, 'x0', ...
    X0, 'printEvery', 1, 'maxIts', maxIter);

    [X, ~, ~] = lbfgsb(@(x) single_obj_grad(x, n, d, S1DivS2, S2DivS1, ...
        coeff1, coeff2, sampleInds, samplePG, sampleMask), l, u, opts );
    X = reshape(X, d, n)';

    [~, postP] = obj_postP(X, s1, s2, d, A, PG);

    function [v, grad] = single_obj_grad(testX, n, d, S1DivS2, S2DivS1, coeff1, coeff2, sampleInds, samplePG, sampleMask)
        testX = reshape(testX, d,n)';
        v = 0;
        grad = zeros(n,d);
        for idx = 1:n
            posMask = sampleMask(idx,:);
            negMask = ~sampleMask(idx,:);
            posInds = sampleInds(idx, posMask);
            negInds = sampleInds(idx, negMask);

            distSqr = sum((testX(idx,:) - testX(sampleInds(idx,:),:)).^2, 2)';

            Z1 = 1+(1-samplePG(idx, posMask))./samplePG(idx, posMask).*exp(coeff1*distSqr(posMask))*S1DivS2^d;
            Z2 = 1+(samplePG(idx, negMask))./(1-samplePG(idx, negMask)).*exp(coeff2*distSqr(negMask))*S2DivS1^d;

            v = v + sum(log(Z1)) + sum(log(Z2));

            posGrad = bsxfun(@times, (1 - 1./Z1')*coeff1*2, testX(idx,:) - testX(posInds, :));
            negGrad = bsxfun(@times, (1 - 1./Z2')*coeff2*2, testX(idx,:) - testX(negInds, :));
            grad(idx,:) = grad(idx,:) + sum(posGrad,1) + sum(negGrad,1);
            grad(posInds, :) = grad(posInds, :) - posGrad;
            grad(negInds, :) = grad(negInds, :) - negGrad;
        end

        %   compute grad w.r.t target
        grad = reshape(grad', n*d, 1);
    end

%     function [v, grad] = single_obj_grad(testX, n, d, invZ1, invZ2, invS1p2, invS2p2, sampleInds, samplePG, sampleMask)
%         testX = reshape(testX, d,n)';
%         v = 0;
%         grad = zeros(n,d);
%         for idx = 1:n
%             posMask = sampleMask(idx,:);
%             negMask = ~sampleMask(idx,:);
%             posInds = sampleInds(idx, posMask);
%             negInds = sampleInds(idx, negMask);
% 
%             distSqr = sum((testX(idx,:) - testX(sampleInds(idx,:),:)).^2, 2)';
% 
%             pgxs1 = invZ1*exp(-distSqr*invS1p2/2).*samplePG(idx, :);
%             pgxs2 = invZ2*exp(-distSqr*invS2p2/2).*(1-samplePG(idx, :));
%             pgx = pgxs1./(pgxs1 + pgxs2);
%             v = v + sum(log(pgx(posMask))) + sum(log(1-pgx(negMask)));
% 
%             posGrad = (invS2p2 - invS1p2)*bsxfun(@times, 1-pgx(posMask)', testX(idx,:) - testX(posInds, :));
%             negGrad = (invS1p2 - invS2p2)*bsxfun(@times, pgx(negMask)', testX(idx,:) - testX(negInds, :));
% 
%             grad(idx,:) = grad(idx,:) + sum(posGrad,1) + sum(negGrad,1);
%             grad(posInds, :) = grad(posInds, :) -posGrad;
%             grad(negInds, :) = grad(negInds, :) -negGrad;
%         end
% 
%         % compute grad w.r.t target
%         grad = reshape(grad', n*d, 1);
% 
%         v = -v;
%         grad = -grad;
%     end

    function [inds, mask] = subSample(A, n, k)
        inds = zeros(n, 2*k);
        mask = false(n, 2*k);
        for idx = 1:n
            Ai = logical(A(idx,:));
            nPosEdges = sum(Ai);
            nPosSample = min(k, nPosEdges);
            posInds = find(Ai);
            inds(idx, 1:nPosSample) = posInds(randsample(nPosEdges, nPosSample));
            mask(idx, 1:nPosSample) = true;

            nNegEdges = n - nPosEdges - 1;
            nNegSample = 2*k - nPosSample;
            Ai = ~Ai;
            Ai(idx) = false;
            negInds = find(Ai);
            inds(idx, nPosSample + (1:nNegSample)) = negInds(randsample(nNegEdges, nNegSample));
        end
    end

    function [inds, mask] = noSample(A, n, k)
        inds = zeros(n, 2*k);
        mask = false(n, 2*k);
        for idx = 1:n            
            inds(idx, :) = 1:n;
            mask(idx, :) = logical(A(idx,:));
        end
    end
end
