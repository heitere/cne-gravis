function generate_edgelist(A, dataName, methodName)
    [I,J] = find(A==1); 
    edgeListName = [dataName, '.edgelist'];    
    if strcmp(methodName, 'LINE')
        dlmwrite(edgeListName, [I,J, ones(length(I),1)], 'delimiter', ' ');
    else
        dlmwrite(edgeListName, [I,J], 'delimiter', ' '); 
    end
    
end