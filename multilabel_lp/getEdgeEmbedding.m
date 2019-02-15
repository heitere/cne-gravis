function [edgeEmb, labels] = getEdgeEmbedding(embedX, missInds, posE, negE, d)
    nEdgeEmb = size(posE, 1) + size(negE, 1);
    edgeEmb = zeros(nEdgeEmb, d);
    mask = false(nEdgeEmb, 1);
    count = 0;
    posCount = 0;    
    for idxEdge = 1:size(posE, 1)
        count = count + 1;
        
        if ismember(posE(idxEdge,1), missInds) || ismember(posE(idxEdge,2), missInds)
            mask(count) = true;
        else
            posCount = posCount+1;
            edgeEmb(count,:)  = embedX(posE(idxEdge,1),:).*embedX(posE(idxEdge,2),:);       
        end
    end 
    negCount = 0;
    for idxEdge = 1:size(negE, 1)        
        count = count + 1;        
        if ismember(negE(idxEdge,1), missInds) || ismember(negE(idxEdge,2), missInds)
            mask(count) = true;
        else
            negCount = negCount+1;
            edgeEmb(count,:)  = embedX(negE(idxEdge,1),:).*embedX(negE(idxEdge,2),:);       
        end
    end
    edgeEmb(mask,:) = [];
    labels = ones(posCount+negCount, 1);
    labels(posCount+1: end) = 0;
end