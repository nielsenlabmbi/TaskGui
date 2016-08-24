function [x y sig d l] = updateDots(x,y,sig,d,l,R,L,V,S)

% x -- x coordinates of dots (pixels)
% y -- y coordinates of dots (pixels)
% sig -- logical array of which dots are signal
% d -- directions of dots (radians)
% l -- lifetime of dots (frames)
%
% R -- radius of patch
% L -- lifetime of newly spawned dot
% V -- dot velocity (pixels per frame)
% S -- object for making random numbers

% Logical array of new dots
new = l == 1;
l(l > 0) = l(l > 0) - 1;

if sum(new)
    % Reset lifetime of new dots
    l(new) = L;
    % Set positions of new dots
    r = R*rand(S,sum(new),1);
    t = 2*pi*rand(S,sum(new),1);
    x(new) = r.*cos(t);
    y(new) = r.*sin(t);
end

% Set directions of noisy new dots (coherent new dots stay the same)
if sum((~sig)&new); d((~sig)&new) = 2*pi*rand(S,sum((~sig)&new),1); end

% Move the dots
x = x+V*cos(d);
y = y-V*sin(d);

% Wrap dots outside the window
for i = find((x.^2 + y.^2) > (R.^2))'
    [x(i) y(i)] = wrapDots(x(i),y(i),d(i),R);
end

end