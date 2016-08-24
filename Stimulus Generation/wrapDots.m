function [newX newY] = wrapDots(x,y,d,R)

% function [newX newY] = wrapDots(x,y,d,R)
%
% For dots located at [x y], moving in direction d, if the dot is outside
% of an aperture with radius, R, then the dot is wrapped around back into
% the aperture.

% Check that the dot is outside the aperture
if norm([x y],2) > R
    % Find the line describing dot aperture in 'y = mx + b' form
    m = -sin(d)/cos(d);
    b = y - m*x;
    % Solve for the intersection of the line with the aperture edges
    eX1 = -(b*m + (R^2*m^2 + R^2 - b^2)^(1/2))/(m^2 + 1);
    eX2 = -(b*m - (R^2*m^2 + R^2 - b^2)^(1/2))/(m^2 + 1);
    eY1 = m*eX1+b;
    eY2 = m*eX2+b;
    % Measure distances from the intersections
    diff1 = [x y] - [eX1 eY1];
    diff2 = [x y] - [eX2 eY2];
    dist1 = norm(diff1,2);
    dist2 = norm(diff2,2);
    % The dot is now moved from its location relative to the closer
    % intersection to the same location relative to the further
    % intersection
    switch dist1 <= dist2
        case 0
            newX = eX1 + diff2(1);
            newY = eY1 + diff2(2);
        case 1
            newX = eX2 + diff1(1);
            newY = eY2 + diff1(2);
    end
% If dot is within the aperture, nothing needs to be done
else
    newX = x;
    newY = y;
end