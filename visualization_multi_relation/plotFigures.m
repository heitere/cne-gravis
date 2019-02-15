%% set up environment
addpath('../methods');
addpath('../data/');

clear;
data = load('X_degree');
X_degree = data.X;

data = load('X_uniform');
X_uniform = data.X;

computeA;

fontSize = 16;
fig = figure('Name','KNN Subject','Units','centimeters',...
        'OuterPosition',[3 3 30 14],'Resize','off',...
        'PaperOrientation','landscape','Renderer','painters');

ax1 = plotSubFigure(0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 1, 2, fontSize, 1, true);
plotter_static(ax1, X_uniform, A, nodeLabels, nodeInfo, nodeTypes, true);
axis([-20 20 -13 13]);
axis(ax1,'off');
text(-20, 12, '(a)', 'FontSize', fontSize)

ax2 = plotSubFigure(0.01, 0.01, 0.01, 0.01, 0.0, 0.01, 1, 2, fontSize, 2, true);
plotter_static(ax2, X_degree, A, nodeLabels, nodeInfo, nodeTypes, false);
axis([-10 11 -8 8]);
axis(ax2,'off');
text(-10, 7.2, '(b)', 'FontSize', fontSize)
print(fig, '-depsc', 'studentdb');