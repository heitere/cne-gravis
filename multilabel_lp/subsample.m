function result = subsample(y, portion)
n = size(y, 1);

randInds = randperm(n);
sampleSize = round(n*portion);

result = zeros(1, sampleSize);

count = 1;
idx = 1;
while (count <= sampleSize)
    tryIdx = randInds(idx);
    row = y(tryIdx, :);
    y(tryIdx, :) = 0;
    if sum(sum(y, 1) == 0) ~= 0
        y(tryIdx, :)  = row;
        idx = idx + 1;
        continue;
    else
        result(count) = tryIdx;
        idx = idx + 1;
        count = count +1;
    end    
end
end

