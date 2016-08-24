function [A P] = TestNext(S,P,A)

% function [A P] = MotNext(S,P,A)
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
% Created by: Sam Nummela       Last modified: 190514

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
end
A.runType = P.runType; % NOTE LATEST RUN TYPE

% GET SOME CRUCIAL CONVERSION VALUES
DistanceCM = S.screenDistance;
ScreenWidthCM = S.screenWidth;
ScreenWidthDeg = 2*atan2((ScreenWidthCM/2),DistanceCM)*180/pi;
ScreenWidthPix = A.screenRect(3);
DegPerPix = ScreenWidthDeg/ScreenWidthPix;
PixPerDeg = 1/DegPerPix;

% GET GRATING SPECIFICATIONS
AperturePix = 500;

% CALCULATE COORDINATE TO PLACE THE GRATING
A.gratPos = round([1920-AperturePix 1080-AperturePix 1920+AperturePix 1080+AperturePix]/2);

end