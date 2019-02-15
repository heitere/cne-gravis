addpath('../methods');
X = -10:0.1:10;

fontSize = 10;
fig = figure('Name','KNN Subject','Units','centimeters',...
        'OuterPosition',[3 3 30 14],'Resize','off',...
        'PaperOrientation','landscape','Renderer','painters');
    
% fig = figure('Name','KNN Subject','Units','centimeters',...
%      'OuterPosition',[3 3 30 14],'Resize','off');

ax1 = plotSubFigure(0.04, 0.01, 0.05, 0.06, 0.01, 0.01, 1, 2, fontSize, 1, true);
p = 0.1;
s1 = 1;
s2 = 2;
plot(ax1, X, normpdf(X,0,s1)*p./(normpdf(X,0,s1)*p + normpdf(X,0,s2)*(1-p)), '-');
plot(ax1, X, normpdf(X,0,s2)*(1-p)./(normpdf(X,0,s1)*p + normpdf(X,0,s2)*(1-p)), '--');

s2 = 10;
plot(ax1, X, normpdf(X,0,s1)*p./(normpdf(X,0,s1)*p + normpdf(X,0,s2)*(1-p)), '-');
plot(ax1, X, normpdf(X,0,s2)*(1-p)./(normpdf(X,0,s1)*p + normpdf(X,0,s2)*(1-p)), '--');

lgd = legend(ax1, 'a_{ij} = 1 ( p=0.1, \sigma_2=2 )', 'a_{ij} = 0 (p=0.1, \sigma_2=2)',...
    'a_{ij} = 1 (p=0.1, \sigma_2=10)', 'a_{ij} = 0 (p=0.1, \sigma_2=10)', ...
    'Location', 'east');
lgd.FontSize = 12;


ax2 = plotSubFigure(0.1, 0.01, 0.01, 0.06, 0.01, 0.01, 1, 2, fontSize, 2, true);
p = 0.9;
s1 = 1;
s2 = 2;
plot(ax2, X, normpdf(X,0,s1)*p./(normpdf(X,0,s1)*p + normpdf(X,0,s2)*(1-p)), '-');
plot(ax2, X, normpdf(X,0,s2)*(1-p)./(normpdf(X,0,s1)*p + normpdf(X,0,s2)*(1-p)), '--');

s2 = 10;
plot(ax2, X, normpdf(X,0,s1)*p./(normpdf(X,0,s1)*p + normpdf(X,0,s2)*(1-p)), '-');
plot(ax2, X, normpdf(X,0,s2)*(1-p)./(normpdf(X,0,s1)*p + normpdf(X,0,s2)*(1-p)), '--');

lgd = legend(ax2, 'a_{ij} = 1 ( p=0.9, \sigma_2=2 )', 'a_{ij} = 0 (p=0.9, \sigma_2=2)',...
    'a_{ij} = 1 (p=0.9, \sigma_2=10)', 'a_{ij} = 0 (p=0.9, \sigma_2=10)', ...
    'Location', 'east');
lgd.FontSize = 12;

print('-depsc', 'objective');
