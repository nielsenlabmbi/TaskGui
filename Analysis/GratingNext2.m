function [A P] = GratingNext2(S,P,A)

% function [A P] = GratingNext2(S,P,A)
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
%
% Created by: Sam Nummela       Last modified: 260813

% Get parameters
A.stimSide = P.stimSide;
A.cpd = P.cpd;

% PARAMETERS ARE SET DIFFERENTLY IF A NEW OUTPUT
if A.newOutput
    A.runType = 0;
    A.newOutput = 0;
    switch P.runType
        case 0
            % CHOOSE A STIM SIDE AND c/deg AT RANDOM
            P.stimSide = ceil(3*rand);
            cpds = [0.125 0.25 .5 1];
            P.cpd = cpds(ceil(length(cpds)*rand));
        case 1
            % If last trial was not pseudrandom, set up a trial list
            if ~(A.runType == 1); A.listIndex = 0; end
            % If list has finished start, start a new list
            if ~A.listIndex; A.listPerm = randperm(size(S.trialsList,1)); end
            % Get stimulus side and line color from trials list
            P.cpd = S.trialsList(A.listPerm(A.listIndex+1),1);
            P.stimSide = S.trialsList(A.listPerm(A.listIndex+1),2);
            % Update index
            A.listIndex = mod(A.listIndex+1,size(S.trialsList,1));
    end
    A.runType = P.runType;
    A.stimSide = P.stimSide;
    A.cpd = P.cpd;
end

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

% CREATE A GAUSSIAN TO SMOOTH THE GRATING
r = sqrt(x.^2 + y.^2);
sigmaDeg = ApertureDeg/16.5;
MaskLimit = abs(x(1,round(.2*AperturePix)));
sigmaPix = sigmaDeg*PixPerDeg;
e1 = exp(-.5*(r-MaskLimit).^2/sigmaPix.^2);
e1(r<MaskLimit) = 1;
% e1(r<x(1,end)) = 1;

% SMOOTH THE GRATING
grating = s1.*e1;

% TRANSFER THE GRATING INTO AN IMAGE
gratDir = 2*ceil(2*rand)-3;
grating = gratDir*round(grating*P.range) + P.bkgd;

% FINALLY MAKE THE GRATING TEXTURE
A.gratTex = Screen('MakeTexture',A.window,grating);

% CALCULATE COORDINATE TO PLACE THE GRATING
A.gratPos = zeros(3,4);
% CenterDeg = [8 4];
% AbsCenterDeg = [ScreenWidthDeg/2 ScreenHeightDeg/2] + CenterDeg;
% StartPix = round((AbsCenterDeg-ApertureDeg/2)*PixPerDeg);
A.gratPos(1,:) = [1361 521 1920 1080];
A.gratPos(2,:) = [0   521 559  1080];
A.gratPos(3,:) = [684 521 1235 1080];
end
