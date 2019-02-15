function [v, gd] = obj_grad(flatX, n, d, s1, s2, inInds, outInds, inP, outP, inE, outE)
    X = reshape(flatX, d,n)';
    D = pdist(X).^2;
    
    inD = D(inInds);
    outD = D(outInds);
    invZ1 = 1/(2*pi*s1^2)^(d/2);
    invZ2 = 1/(2*pi*s2^2)^(d/2);

    pdfInS1P = invZ1*exp(-inD/2/s1^2).*inP;
    pdfInS2P =  invZ2*exp(-inD/2/s2^2).*(1-inP);

    pdfOutS1P = invZ1*exp(-outD/2/s1^2).*outP;
    pdfOutS2P =  invZ2*exp(-outD/2/s2^2).*(1-outP);

    inPe =  pdfInS1P./(pdfInS1P + pdfInS2P);
    outPe = pdfOutS1P./(pdfOutS1P + pdfOutS2P);
    v = (sum(log(inPe)) + sum(log(1-outPe)));
    
    gradCoeff = zeros(n);
    gradCoeff(inE) = (1-inPe)*(1/s2^2 - 1/s1^2);
    gradCoeff(outE) = outPe*(1/s1^2 - 1/s2^2);
    gradCoeff = gradCoeff + gradCoeff';
    gd = (sum(gradCoeff,2).*X - gradCoeff*X);    
    gd = reshape(gd', n*d, 1);
    
    v = -v;
    gd = -gd;
end