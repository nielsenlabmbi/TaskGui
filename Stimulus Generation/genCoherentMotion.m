function [XY] = genCoherentMotion(frames)

% function [XY] = genCoherentMotion(frames)
%
% This function generates line segments of equal length and random 
% orientation within a rectangle move in random directions, except for line
% segments within a circle which move coherently in one particular
% direction.
%
% XY is a 2 x 2n x frames array, where column vectors of each 2x2 section 
% indicates the starting xy and ending xy coordinates of each line.
%
% Created on: 230113    Created by: Sam Nummela

rectPixels = [1920 1080];   % Screen dimensions in pixels

lineLength = 40;    % Length of each line segment in pixels
lineNumber = 2000;  % Number of line segments
lineTheta = 45;     % Direction of coherent motion in degrees
lineSpeed = 2;      % Speed of lines in pixels per frame
lineLifetime = 10;   % Lifetime of lines (frames)

% Initial X and Y coordinates of line segment centers
Xc = round(rectPixels(1)*rand(1,lineNumber)-rectPixels(1)/2);
Yc = round(rectPixels(2)*rand(1,lineNumber)-rectPixels(2)/2);
% Orientations of line segments in radians
R = pi*rand(1,lineNumber);
% Initial lifetimes of line segments
A = randi(lineLifetime,[lineNumber 1]);

% Define the motion aperture
circleCenter = [250;100];   % Circle center in pixels
circleRadius = 250;         % Circle radius in pixels

% Assign array for output
XY = nan(2,2*lineNumber,frames);
f = 1;
while f <= frames
    % Find the lines within the circular aperture% Find all line segments within the circle boundary
    circleX = Xc - circleCenter(1); % X coordinate relative to circle center
    circleY = Yc - circleCenter(2); % Y coordinate relative to circle center
    inCircle = circleX.^2 + circleY.^2 < circleRadius^2;
    
    % Move the lines
    dir = ceil(360*rand(1,lineNumber)); dir(inCircle) = lineTheta;
    [dX dY] = pol2cart(dir*pi/180,ones(1,lineNumber)*lineSpeed);
    Xc = Xc+dX; Yc = Yc+dY;
    %%%%% SHOULD DO A WRAP CHECK HERE, COULD USE THE MOD FUNCTION IF I PUT
    %%%%% ZERO AT A CORNER OF THE SCREEN INSTEAD OF THE CENTER
    
    % Get the line segment endpoints and place them in the output
    X = lineLength*[-.5;.5]*cos(R) + [Xc;Xc];   % X line segment end points
    Y = lineLength*[-.5;.5]*sin(R) + [Yc;Yc];   % Y line segment end points
    for i = 1:lineNumber    % Put those end points in order for DrawLines
        XY(1,2*(i-1)+[1 2],f) = X(:,i)';
        XY(2,2*(i-1)+[1 2],f) = Y(:,i)';
    end
    
    % Update the frames
    f = f+1;
    
    % Update line segment ages
    A = A+1;
    old = find(A > lineLifetime);
    % Generate fresh line segments
    A(old) = 1;
    Xc(old) = round(rectPixels(1)*rand(1,length(old))-rectPixels(1)/2);
    Yc(old) = round(rectPixels(2)*rand(1,length(old))-rectPixels(2)/2);
    R(old) = pi*rand(1,length(old));
end
