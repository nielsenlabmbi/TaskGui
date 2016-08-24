function [A P] = MotNext(S,P,A)

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
        % other params
        A.cpd = S.cpd;
        A.tF = S.tF;
        A.range = S.range;
    case 1
        % If last trial was not pseudo random, set up a trials list
        if ~(A.runType == 1)
            A.listIndex = 0;
        end
        % If list has finished start, start a new list
        if ~A.listIndex
            A.listPerm = randperm(size(S.trialsList,1));
        end
        % Get stimulus side and movie to play from trials list
        A.side = S.trialsList(A.listPerm(A.listIndex+1),1);
        A.mov = S.trialsList(A.listPerm(A.listIndex+1),2);
        A.cpd = S.cpds(A.mov);
        A.tF = S.tFs(A.mov);
        A.range = S.range;
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
        % other params
        A.cpd = S.cpd;
        A.tF = S.tF;
        A.range = S.range;
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
%nCycles = 24*S.cpd;
nCycles=15*S.cpd;
DegPerCyc = 1/S.cpd;
ApertureDeg = DegPerCyc*nCycles;
AperturePix = round(PixPerDeg*ApertureDeg);

% CALCULATE COORDINATE TO PLACE THE GRATING
A.gratPos = round([1920-AperturePix 1080-AperturePix 1920+AperturePix 1080+AperturePix]/2);

end