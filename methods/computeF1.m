function [meanMacroF1, meanMicroF1] = computeF1(X, group, trainPortion)
% partially refer to:
% https://github.com/phanein/deepwalk/blob/master/example_graphs/scoring.py
    n = size(X,1);
    numRandom = 10;
    nLabels = size(group, 2);

    microF1s = zeros(1, numRandom);
    macroF1s = zeros(1, numRandom);

    numTrain = round(n*trainPortion);
    for i = 1:numRandom    
        permInds = randperm(n);    
        permX = X(permInds, :);
        permLabels = group(permInds, :);
        trX = permX(1:numTrain, :);
        teX = permX(numTrain+1:end, :);
        trY = full(permLabels(1:numTrain, :));
        teY = full(permLabels((numTrain+1):end, :));
        predProb = zeros(n-numTrain, nLabels);
        for j = 1:nLabels                                    
            Mdl = fitclinear(trX,trY(:,j), 'Learner','logistic','Solver','lbfgs', 'Regularization', 'ridge');
            [~,posterior] = predict(Mdl, teX);
            predProb(:,j) = posterior(:,2);
        end    
        predY = zeros(size(teY));
        for k = 1:(n-numTrain)
            teYInds = find(teY(k,:) == 1);
            [~, sortedInds] = sort(predProb(k,:), 'descend');
            predYInds = sortedInds(1:length(teYInds));
            predY(k, predYInds) = 1;
        end
        tpSum = sum(predY.*teY, 1);
        predSum = sum(predY, 1);
        teSum = sum(teY, 1);

        microPrecision = sum(tpSum)/sum(predSum);
        microRecall = sum(tpSum)/sum(teSum);
        microF1s(i) = 2*microPrecision*microRecall/(microPrecision + microRecall);

        validInds = ~(predSum == 0 | teSum == 0);
%         validInds = true(1, nLabels);

        macroPrecision = tpSum./predSum;
        macroPrecision = mean(macroPrecision(validInds));    
        macroRecall = tpSum./teSum;
        macroRecall = mean(macroRecall(validInds));

        macroF1s(i) = 2*macroPrecision*microRecall/(macroPrecision + macroRecall);

    end

    meanMicroF1 = mean(microF1s(~isnan(microF1s)));
    meanMacroF1 = mean(macroF1s(~isnan(macroF1s)));
end