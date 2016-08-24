function fc = byColor(D)

colors = unique(D.lineColor);
fc = [colors nan(size(colors)) nan(size(colors)) nan(size(colors))];

for i = 1:length(colors)
    color = colors(i);
    ind = D.lineColor == color;
    fc(i,2) = sum(ind & D.firstTry)/sum(ind);
    fc(i,3) = sum(D.lineColor == color);
    fc(i,4) = (255-color)/(255-8);
end

