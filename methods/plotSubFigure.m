function h = plotSubFigure(lm, rm, horm, bm, tm, verm, nrows, ...
    ncols, fs, nsubfig, rowsfirst)
% Usage: first create figure with preferred size as in
%        figure('Position',[400 500 280 120]);
% lm: left margin
% rm: right margin (usually you want this equivalent to rm)
% horm: horizontal margin between subfigures
% bm: bottom margin
% tm: top margin
% verm: vertical margin between subfigures
% nrows: number of rows of subfigures
% ncols: number of columns of subfigures
% fs: font size
% nsubfig: the number of the current axes to create
% rowsfirst: true/false fill by row, otherwise use column first order

width = (1-lm-rm-horm*(ncols-1))/ncols;
height = (1-bm-tm-verm*(nrows-1))/nrows;

if(rowsfirst)
    nfigsleft = mod(nsubfig-1,ncols);
    nfigsbelow = nrows-floor((nsubfig-1)/ncols)-1;
else
    nfigsleft = floor((nsubfig-1)/nrows);
    nfigsbelow = nrows-mod(nsubfig-1,nrows)-1;
end

alm = lm + nfigsleft*(width+horm);
abm = bm + nfigsbelow*(height+verm);

h = axes('Position',[alm abm width height],'FontSize',fs);
hold on;
set(gca,'TickDir','out');

end