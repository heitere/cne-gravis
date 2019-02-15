function [aucTr, aucTe] = predict_edge_other(X, missInds, n, trE, negTrE, teE, negTeE, predictionMethod)
    d = size(X, 2);      
    switch predictionMethod
        case 'logistic_regression'
            [trEdgeEmb, trY] = getEdgeEmbedding(X, missInds, trE, negTrE, d);    
            [teEdgeEmb, teY] = getEdgeEmbedding(X, missInds, teE, negTeE, d); 
            CVMdl = fitclinear(trEdgeEmb,trY,'Learner','logistic', 'Regularization', 'ridge');

            [~,posterior] = predict(CVMdl,trEdgeEmb);
            [~,~,~,aucTr] = perfcurve(trY,posterior(:,2),1, ...
                    'XVals', 0:0.05:1);  

            [~,posterior] = predict(CVMdl,teEdgeEmb);
            [~,~,~,aucTe] = perfcurve(teY,posterior(:,2),1, ...
                    'XVals', 0:0.05:1);        
        case 'common_neighbor'
            sim = common_neighbor(trE, n);
            [scoresTr,trY] = predict_heuristic(sim, trE, negTrE);
            [~,~,~,aucTr] = perfcurve(trY,scoresTr,1, ...
                    'XVals', 0:0.05:1);  
            [scoresTe,teY] = predict_heuristic(sim, teE, negTeE);
            [~,~,~,aucTe] = perfcurve(teY,scoresTe,1, ...
                    'XVals', 0:0.05:1);
        case 'jarcard_similarity'   
            sim = jarcard_similarity(trE, n);
            [scoresTr,trY] = predict_heuristic(sim, trE, negTrE);
            [~,~,~,aucTr] = perfcurve(trY,scoresTr,1, ...
                    'XVals', 0:0.05:1);  
            [scoresTe,teY] = predict_heuristic(sim, teE, negTeE);
            [~,~,~,aucTe] = perfcurve(teY,scoresTe,1, ...
                    'XVals', 0:0.05:1);
        case 'adamic_adar'   
            sim = adamic_adar(trE, n);
            [scoresTr,trY] = predict_heuristic(sim, trE, negTrE);
            [~,~,~,aucTr] = perfcurve(trY,scoresTr,1, ...
                    'XVals', 0:0.05:1);  
            [scoresTe,teY] = predict_heuristic(sim, teE, negTeE);
            [~,~,~,aucTe] = perfcurve(teY,scoresTe,1, ...
                    'XVals', 0:0.05:1);            
        case 'preferential_attachement'   
            sim = preferential_attachement(trE, n);
            [scoresTr,trY] = predict_heuristic(sim, trE, negTrE);
            [~,~,~,aucTr] = perfcurve(trY,scoresTr,1, ...
                    'XVals', 0:0.05:1);  
            [scoresTe,teY] = predict_heuristic(sim, teE, negTeE);
            [~,~,~,aucTe] = perfcurve(teY,scoresTe,1, ...
                    'XVals', 0:0.05:1);            
        otherwise
    end
    function sim = common_neighbor(E, n)
        A = sparse(E(:,1), E(:,2), 1,n,n);
        A = double(A | A');
        sim = A * A;
    end
    function sim = jarcard_similarity(E, n)
        A = sparse(E(:,1), E(:,2), 1,n,n);
        A = double(A | A');
        sim = A * A;
        deg_row = repmat(sum(A,1), [size(A,1),1]);
        deg_row = deg_row .* spones(sim);                               
        deg_row = triu(deg_row) + triu(deg_row');                      
        sim = sim./(deg_row.*spones(sim)-sim); 
        sim(isnan(sim)) = 0; sim(isinf(sim)) = 0;
    end
    function sim = adamic_adar(E, n)
        A = sparse(E(:,1), E(:,2), 1,n,n);
        A = double(A | A');
        A1 = A ./ repmat(log(sum(A,2)),1,size(A,1));         
        A1(isnan(A1)) = 0; 
        A1(isinf(A1)) = 0;          
        sim = A * A1;
    end
    function sim = preferential_attachement(E, n)
        A = sparse(E(:,1), E(:,2), 1,n,n);
        A = double(A | A');
        deg_row = sum(A,2);               
        sim = deg_row * deg_row'; 
    end
    function [scores, targets] = predict_heuristic(sim, posE, negE)
        nEdgeEmb = size(posE, 1) + size(negE, 1);
        scores = zeros(nEdgeEmb, 1);
        count = 0;
        posCount = 0;
        for idxEdge = 1:size(posE, 1)
            count = count + 1;
            posCount = posCount+1;
            scores(count) = sim(posE(idxEdge, 1), posE(idxEdge, 2));
        end 
        negCount = 0;
        for idxEdge = 1:size(negE, 1)
            count = count + 1;
            negCount = negCount+1;
            scores(count) = sim(negE(idxEdge, 1), negE(idxEdge, 2));
        end 
        targets = ones(posCount+negCount, 1);
        targets(posCount+1: end) = 0;
    end
end