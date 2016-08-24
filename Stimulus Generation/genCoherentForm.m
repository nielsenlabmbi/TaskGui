function [XY] = genCoherentForm(coherence,circleCenter)

% function [XY] = genCoherentForm(coherence,circleCenter)
%
% This function generates randomly distributed line segments of equal
% length within a rectangle that cohere, within the boundary of a circle,
% to a tangential orientation. Elsewhere line orientation is uniformly and
% randomly distributed.
%
% XY is a 2x2n array, where column vectors of each 2x2 section indicate the
% starting xy and ending xy coordinates of each line.
%
% Created on: 230113    Created by: Sam Nummela

rectPixels = [1920 1080];  % Screen dimensions in pixels

lineLength = 50;    % Length of each line segment in pixels
lineNumber = 1000;  % Number of line segments

% X and Y coordinates of line segment centers
Xc = round(rectPixels(1)*rand(1,lineNumber)-rectPixels(1)/2);
Yc = round(rectPixels(2)*rand(1,lineNumber)-rectPixels(2)/2);
% Random orientations of line segments in radians
R = pi*rand(1,lineNumber);

% Define the form aperture
if ~exist('circleCenter','var');
    circleCenter = [250;100];   % Circle center in pixels
end
circleRadius = 250;         % Circle radius in pixels

% Find all line segments within the circle boundary
circleX = Xc - circleCenter(1); % X coordinate relative to circle center
circleY = Yc - circleCenter(2); % Y coordinate relative to circle center
inCircle = circleX.^2 + circleY.^2 < circleRadius^2;

% AT THIS POINT WE USE THE COHERENCE INPUT ARGUMENT
% The idea is to take only the fraction of segments specified.
if coherence < 1
    nIn = sum(inCircle);
    nCoh = round(coherence*nIn);
    if nCoh > 0
        temp = find(inCircle,nCoh);
        lastCoh = temp(end);
        inCircle(lastCoh+1:end) = false;
    else
        inCircle(:) = false;
    end
end

% Change those line segments (inCircle) to be tangential to the circle
R(inCircle) = pi/2 - atan2(circleX(inCircle),circleY(inCircle)) + pi/2;

% Now generate the line segment end points for output
XY = nan(2,2*lineNumber);   % Array for line segment end points
X = lineLength*[-.5;.5]*cos(R) + [Xc;Xc];   % X line segment end points
Y = lineLength*[-.5;.5]*sin(R) + [Yc;Yc];   % Y line segment end points
for i = 1:lineNumber    % Put those end points in order for DrawLines
    XY(1,2*(i-1)+[1 2]) = X(:,i)';
    XY(2,2*(i-1)+[1 2]) = Y(:,i)';
end
