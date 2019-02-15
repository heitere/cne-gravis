function compute_score(embedName, networkName)
    scorings = {'micro', 'macro'};
    for i = 1:length(scorings)
        outputName = [embedName(1:end-4), '_', scorings{i}, '.score'];
        command = sprintf('python scoring.py --emb %s --network %s --num-shuffles 5 --scoring %s', embedName, networkName, scorings{i});
        [~, pyOutput] = system(command);
        fid = fopen(outputName,'w');
        fprintf(fid, '%s', pyOutput);    
        fclose(fid);
    end
end