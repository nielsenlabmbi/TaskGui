function [A P] = AcuNext(S,P,A)

% function [A P] = AcuNext(S,P,A)
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
        A.stimSide = ceil(2*rand);
        A.cpd = P.cpd;
        A.angle = P.angle;
        A.range = P.range;
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
        A.stimSide = S.trialsList(A.listPerm(A.listIndex+1),1);
        A.cpd = S.trialsList(A.listPerm(A.listIndex+1),2);
        A.angle = S.trialsList(A.listPerm(A.listIndex+1),3);
        A.range = S.trialsList(A.listPerm(A.listIndex+1),4);
        % Update index
        A.listIndex = mod(A.listIndex+1,size(S.trialsList,1));
    case 2
        % If last trial was not blocking, then set up blocking
        if ~(A.runType == 2)
            A.stimSide = ceil(2*rand);
            A.blockIndex = 0;
        end
        A.cpd = P.cpd;
        A.angle = P.angle;
        A.range = P.range;
        % If block has finished, start a new block
        if ~A.blockIndex
            A.stimSide = mod(A.stimSide,2)+1;
            A.blockLength = P.blockLengthMin + floor((P.blockLengthRan+1)*rand);
        end
        % Update block index, reaching block length resets it to 0
        A.blockIndex = mod(A.blockIndex+1,A.blockLength);
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

% GET GRATING SPECIFICATIONS
CycPerDeg = A.cpd;
nCycles = 16*CycPerDeg;
DegPerCyc = 1/CycPerDeg;
ApertureDeg = nCycles*DegPerCyc;
AperturePix = round(PixPerDeg*ApertureDeg);

% CREATE A MESHGRID THE SIZE OF THE GRATING
GridLims = [-(AperturePix-1)/2 (AperturePix-1)/2];
[x y] = meshgrid(GridLims(1):GridLims(2));

% GRATING
s1 = sin(nCycles.*(x+GridLims(2))./((AperturePix-1)/(2*pi)));

% CREATE A GAUSSIAN TO SMOOTH THE OUTER 10% OF THE GRATING
r = sqrt(x.^2 + y.^2);
sigmaDeg = ApertureDeg/16.5;
MaskLimit = abs(x(1,round(.2*AperturePix)));
sigmaPix = sigmaDeg*PixPerDeg;
e1 = exp(-.5*(r-MaskLimit).^2/sigmaPix.^2);
e1(r<MaskLimit) = 1;

% SMOOTH THE GRATING
grating1 = s1.*e1;
grating2 = -grating1;

% TRANSFER THE GRATING INTO AN IMAGE
grating1 = round(grating1*A.range) + P.bkgd;
grating2 = round(grating2*A.range) + P.bkgd;

% FINALLY MAKE THE GRATING TEXTURE
A.gratTex(1) = Screen('MakeTexture',A.window,grating1);
A.gratTex(2) = Screen('MakeTexture',A.window,grating2);

% CALCULATE COORDINATE TO PLACE THE GRATING
A.gratPos = zeros(2,4);
A.gratPos(1,:) = [1040 200 1842 1002];
A.gratPos(2,:) = [78   200 880  1002];

end