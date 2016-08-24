function [A P] = OriNext(S,P,A)

% function [A P] = OriNext(S,P,A)
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
    A.ranges = S.ranges;
end

% GET STIMULUS PROPERTIES
switch P.runType
    case 0
        % random stimulus side
        A.side = ceil(2*rand);
        A.angle = 90*(A.side-1);
        A.cpd = P.cpd;
        A.range = P.range;
        A.phase = round(rand)*180;
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
        A.angle = S.trialsList(A.listPerm(A.listIndex+1),2);
        A.range = S.trialsList(A.listPerm(A.listIndex+1),3);
        A.cpd = S.trialsList(A.listPerm(A.listIndex+1),4);
        A.phase = S.trialsList(A.listPerm(A.listIndex+1),5);
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
        A.angle = 90*(A.side-1)+45; %this runs 45 on 1, 135 on 2
        A.range = P.range;
        A.cpd = P.cpd;
        A.phase = (rand>.5)*180;
    case 3
        % If last trial was not pseudo random, set up a trials list
        if ~(A.runType == 3)
            A.listIndex = 0;
        end
        % If list has finished start, start a new list
        if ~A.listIndex
            A.listPerm = randperm(size(S.trialsList,1));
        end
        % Get stimulus side and line color from trials list
        A.side = S.trialsList(A.listPerm(A.listIndex+1),1);
        A.angle = S.trialsList(A.listPerm(A.listIndex+1),2);
        A.cpd = S.trialsList(A.listPerm(A.listIndex+1),4);
        A.range = A.ranges(S.cpds == A.cpd);
        if A.range > 121; A.range = 121; A.ranges(S.cpds == A.cpd) = A.range; end;
        if A.range < 0; A.range = 0; A.ranges(S.cpds == A.cpd) = A.range; end;
        % Update index
        A.listIndex = mod(A.listIndex+1,size(S.trialsList,1));
    case 4
        %this is blocking of angles
        % If last trial was not blocking, then set up blocking
        if ~(A.runType == 4)           
            A.blockIndex = -1;
            A.listIndex = 0;
        end
        % If list has finished, start over
        if ~A.listIndex
            A.listPerm = randperm(size(S.withinList,1));
            A.blockIndex = mod(A.blockIndex+1,size(S.blockList,1)); 
        end
        
        
        A.side = S.withinList(A.listPerm(A.listIndex+1),1);
        A.range = S.withinList(A.listPerm(A.listIndex+1),2);
        A.cpd = S.withinList(A.listPerm(A.listIndex+1),3);
        A.phase = S.withinList(A.listPerm(A.listIndex+1),4);
        
        A.angle = S.blockList(A.blockIndex+1,A.side);
        
        % Update index
        A.listIndex = mod(A.listIndex+1,size(S.withinList,1));
        
        
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
nCycles = 24*A.cpd;
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
grating = s1.*e1;
if A.phase==180
    grating = -grating;
end

% TRANSFER THE GRATING INTO AN IMAGE
grating = round(grating*A.range) + P.bkgd;


% FINALLY MAKE THE GRATING TEXTURE
A.gratTex = Screen('MakeTexture',A.window,grating);


% CALCULATE COORDINATE TO PLACE THE GRATING

A.gratPos = round([1920-AperturePix 1080-AperturePix 1920+AperturePix 1080+AperturePix]/2);

end