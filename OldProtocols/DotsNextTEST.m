function [A P] = DotsNextTEST(S,P,A)

% function [A P] = DotsNext(S,P,A)
%
% This function performs tasks required before the start of each trial 
% such as generating stimulus related variables or setting up data 
% acquisition schedules.
%
% Any sub-functions used to generate stimuli should be located within this 
% function!
%
% THINKING IN TERMS OF LOOPS LOGIC, THE MAIN REASON FOR RUNNING THIS IS TO
% CONVERT ALL PARAMETERS, AND SETTINGS THAT DEFINE THE SCOPE OF PARAMETERS,
%
% Created by: Sam Nummela       Last modified: 280813

% LAST TRIAL TYPE, 0 random, 1 pseudorandom, 2 blocking
% If new output file
% GET STIMULUS SIDE AND BACKGROUND LINE COLOR
if A.newOutput
    A.runType = 0;
    A.newOutput = 0;
end

% GET STIMULUS PROPERTIES
switch P.runType
    case 0
        % random stimulus side
        A.side = ceil(2*rand);
        A.dir = 90*(A.side-1);
        A.coh = P.coh;
    case 1
        % If last trial was not pseudo random, set up a trials list
        if ~(A.runType == 1)
            A.listIndex = 0;
        end
        % If list has finished start, start a new list
        if ~A.listIndex
            A.listPerm = randperm(size(S.trialsList,1));
        end
        % Get stimulus side and line color from trials list
        A.side = S.trialsList(A.listPerm(A.listIndex+1),1);
        A.dir = S.trialsList(A.listPerm(A.listIndex+1),2);
        A.coh = S.trialsList(A.listPerm(A.listIndex+1),3);
        % Update index
        A.listIndex = mod(A.listIndex+1,size(S.trialsList,1));
    case 2
        % If last trial was not blocking, then set up blocking
        if ~(A.runType == 2)
            A.side = ceil(2*rand);
            A.blockIndex = 0;
        end
        % If block has finished, start a new block
        if ~A.blockIndex
            A.side = mod(A.side,2)+1;
            A.blockLength = P.blockLengthMin + floor((P.blockLengthRan+1)*rand);
        end
        % Update block index, reaching block length resets it to 0
        A.blockIndex = mod(A.blockIndex+1,A.blockLength);
        % GET OTHER VARIABLES
        A.dir = 90*(A.side-1);
        A.coh = P.coh;
end
A.runType = P.runType; % NOTE LATEST RUN TYPE

% TAKE THE SPATIAL FREQUENCY (cpd) AND GENERATE A STIMULUS

% GET SOME CRUCIAL CONVERSION VALUES
DistanceCM = P.screenDistance;
ScreenWidthCM = S.screenWidth;
ScreenWidthDeg = 2*atan2((ScreenWidthCM/2),DistanceCM)*180/pi;
ScreenWidthPix = A.screenRect(3);
DegPerPix = ScreenWidthDeg/ScreenWidthPix;
PixPerDeg = 1/DegPerPix;

% GET APERTURE RADIUS IN PIXELS
ApertureDeg = 26;    %size of circle in which dots are presented JL

% ASSIGN MOTION DOTS PROPERTIES
N = 10;     %number of dots JL
R = round(PixPerDeg*ApertureDeg/2);
L = 8;    %length of life of dots JL
V = 5;      %speed of dots JL
A.dotSize = 64; % NOTE THAT 64 IS THE MAXIMUM VALUE ALLOWED FOR DRAWDOTS!! size of the dots JL
frames = round(50*P.durStim);

x = nan(N,frames); %x coordinate of dot JL
y = nan(N,frames); %y coordinate of dot JL
sig = false(N,frames); %is the dot moving in the coherent direction JL
d = nan(N,frames);  %degree of movement for the dot JL
l = nan(N,frames); %how many frames did the dot last on the screen JL

[x(:,1) y(:,1) sig(:,1) d(:,1) l(:,1)] = genDots(N,R,A.dir,A.coh,L); %creates large matrix JL


%for each frame (generated above by multiplying the length of the stimulus
%by 120), places **a number** the specified column and row.  JL
    %generates information for each dot (column=N), in each frame 
    %(row=frames) JL
    
for i = 2:frames
    [x(:,i) y(:,i) sig(:,i) d(:,i) l(:,i)] = updateDots(x(:,i-1),y(:,i-1),sig(:,i-1),d(:,i-1),l(:,i-1),R,L,V);
end

A.x = x;
A.y = y;
x1=x
y1=y
% WHERE TO PLACE THE APERTURE (where is the center of the grouping of the dots) JL
A.apPos = [960 560];

end

%%%%%%%%%%%%%%%%%%% FUNCTIONS TO CONSTRUCT GLOBAL MOTION %%%%%%%%%%%%%%%%%

function [x y sig d l] = genDots(N,R,D,C,L)
%Generates the x and y coordinates for all dots in one frame.  Checks to 
%sure the dots are inside the circle (if not inside the circle generates 
%new x and y coordinates, and generates a direction for the dots and the 
%lifetime (how many frames the dot will last on the screen)of the dot. JL

%%% ID dots as signal or noise
% Assume all dots are noise
sig = false(N,1);
% If coherence is > 1 assume percentage, otherwise assume fraction
if C > 1; C = C/100; end        %if C=1, all the dots are coherence????JL
% Get number of coherent dots
M = round(C*N);
% Assign the coherent dots
if M > 0; sig(1:M,1) = true; end
%%% Generate the positions of dots (for one frame JL)
x = floor((2*R+1)*rand(N,1))-R;
y = floor((2*R+1)*rand(N,1))-R;
% If dots were spawned outside of the circle, respawn
    %(if the square of the x + y coordinate is greater than the square of
    %the number of pixels in the grouping circle, then it respawns the x
    %and y coordinates JL)
for i = find((x.^2 + y.^2) > R^2)'
    while x(i)^2 + y(i)^2 > R^2
        x(i) = floor((2*R+1)*rand)-R;
        y(i) = floor((2*R+1)*rand)-R;
    end
end

%%% Generate directions of dots (in radians JL)
    %when d=0, dots are moving right, when d=1.5708 dots are moving upwards JL
d = 2*pi*rand(N,1);
d(sig) = D*pi/180;
% Generate lifetimes of dots
if L > 0; l = mod((1:N)',L)+1; else l = zeros(N,1); end
end

function [x y sig d l] = updateDots(x,y,sig,d,l,R,L,V)

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
    for i = find(new)'
        x(i) = floor((2*R+1)*rand)-R;
        y(i) = floor((2*R+1)*rand)-R;
        while x(i)^2 + y(i)^2 > R^2
            x(i) = floor((2*R+1)*rand)-R;
            y(i) = floor((2*R+1)*rand)-R;
        end
    end
end

% Set directions of noisy new dots (coherent new dots stay the same)
if sum((~sig)&new); d((~sig)&new) = 2*pi*rand(sum((~sig)&new),1); end

% Move the dots
x = x+V*cos(d);
y = y-V*sin(d);
% Wrap dots outside the window
for i = find((x.^2 + y.^2) > (R.^2))'
    [x(i) y(i)] = wrapDots(x(i),y(i),d(i),R);
end

end

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
end