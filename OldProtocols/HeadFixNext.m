function [A P] = HeadFixNext(S,P,A)

% function [A P] = HeadFixNext(S,P,A)
%
% This function performs tasks required before the start of each trial 
% such as generating stimulus related variables or setting up data 
% acquisition schedules.
%
% Any sub-functions used to generate stimuli should be located within this 
% function!
%
% THINKING IN TERMS OF LOOPS LOGIC, THE MAIN REASON FOR RUNNING THIS IS TO
% CONVERT ALL PARAMETERS, AND SETTINGS THAT DEFINE THE SCOPE OF PARAMETERS
%
% Created by: Sam Nummela       Last modified: 070414

% Draw a stimulus, while this stimulus is shown, animal can earn reward by
% occluding an IR beam with its paw.

% GET SOME CRUCIAL CONVERSION VALUES
DistanceCM = P.screenDistance;
ScreenWidthCM = S.screenWidth;
ScreenWidthDeg = 2*atan2((ScreenWidthCM/2),DistanceCM)*180/pi;
ScreenWidthPix = A.screenRect(3);
DegPerPix = ScreenWidthDeg/ScreenWidthPix;
PixPerDeg = 1/DegPerPix;

% GET GRATING SPECIFICATIONS
A.cpd = P.cpd; A.range = P.range; A.angle = P.angle;
nCycles = 30*A.cpd;
DegPerCyc = 1/A.cpd;
ApertureDeg = DegPerCyc*nCycles;
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
grating2 = -grating1;   % This is just a reverse grating, controls for strategies like picking the white area

% TRANSFER THE GRATING INTO AN IMAGE
grating1 = round(grating1*A.range) + P.bkgd;
grating2 = round(grating2*A.range) + P.bkgd;

% FINALLY MAKE THE GRATING TEXTURE
A.gratTex(1) = Screen('MakeTexture',A.window,grating1);
A.gratTex(2) = Screen('MakeTexture',A.window,grating2);

% CALCULATE COORDINATE TO PLACE THE GRATING

A.gratPos = round([1920-AperturePix 1090-AperturePix 1920+AperturePix 1080+AperturePix]/2);