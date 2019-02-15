function [v, post] = obj_postP(X, s1, s2, d, A, P)
    inE = logical(triu(A, 1))';
    outE = logical(triu(~A, 1))';

    inP = P(inE);
    outP = P(outE);
    
    n = size(X,1);
    r = sum(X.*X, 2);
    D = repmat(r,1, n)  - 2*(X*X') + repmat(r', n, 1);

    inD = D(inE);
    outD = D(outE);

    S1DivS2 = s1/s2;
    S2DivS1 = s2/s1;

    coeff1 = (S2DivS1^2-1)/(2*s2^2);
    coeff2 = (S1DivS2^2-1)/(2*s1^2);

    sum1 = sum(log(1+(1-inP)./inP/S2DivS1^d.*exp(coeff1*inD)));
    sum2 = sum(log(1+(outP)./(1-outP)/S1DivS2^d.*exp(coeff2*outD)));
    
%     sum1e = sum(-log(1/(2*pi*s1^2)^.5*exp(-inD/2/s1^2).*inP./(1/(2*pi*s1^2)^.5*exp(-inD/2/s1^2).*inP + 1/(2*pi*s2^2)^.5*exp(-inD/2/s2^2).*(1-inP))));
%     sum2e = sum(-log(1/(2*pi*s2^2)^.5*exp(-outD/2/s2^2).*(1-outP)./(1/(2*pi*s1^2)^.5*exp(-outD/2/s1^2).*outP + 1/(2*pi*s2^2)^.5*exp(-outD/2/s2^2).*(1-outP))));

    sum1e = sum(-log(1/(2*pi*s1^2)^(d/2)*exp(-inD/2/s1^2).*inP./(1/(2*pi*s1^2)^(d/2)*exp(-inD/2/s1^2).*inP + 1/(2*pi*s2^2)^(d/2)*exp(-inD/2/s2^2).*(1-inP))));
    sum2e = sum(-log(1/(2*pi*s2^2)^(d/2)*exp(-outD/2/s2^2).*(1-outP)./(1/(2*pi*s1^2)^(d/2)*exp(-outD/2/s1^2).*outP + 1/(2*pi*s2^2)^(d/2)*exp(-outD/2/s2^2).*(1-outP))));
        
    coeff1 = (s2^2-s1^2)/(2*s1^2*s2^2);
    coeff2 = -coeff1;
    
    sum1p = sum(log(1+(1-inP)./inP*S1DivS2^d.*exp(coeff1*inD)));
    sum2p = sum(log(1+(outP)./(1-outP)*S2DivS1^d.*exp(coeff2*outD)));
    
    vp = sum1p + sum2p;
    ve = sum1e + sum2e;
    v = sum1 + sum2;
%     disp([vp, ve, v]);
    post = zeros(size(P));
%     post(inE) = 1./(1+(1-inP)./inP/S2DivS1^d.*exp(coeff1*inD));
%     post(outE) = 1./(1+(outP)./(1-outP)/S1DivS2^d.*exp(coeff2*outD));    
    post(inE) = 1/(2*pi*s1^2)^(d/2)*exp(-inD/2/s1^2).*inP./(1/(2*pi*s1^2)^(d/2)*exp(-inD/2/s1^2).*inP + 1/(2*pi*s2^2)^(d/2)*exp(-inD/2/s2^2).*(1-inP));
    post(outE) = 1 - 1/(2*pi*s2^2)^(d/2)*exp(-outD/2/s2^2).*(1-outP)./(1/(2*pi*s1^2)^(d/2)*exp(-outD/2/s1^2).*outP + 1/(2*pi*s2^2)^(d/2)*exp(-outD/2/s2^2).*(1-outP));
    post = post+post';
end