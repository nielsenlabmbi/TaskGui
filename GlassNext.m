function [A P] = GlassNext(S,P,A)

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
% Created by: Kristina Nielsen       Last modified: 200815

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
        A.ori = 90*mod(A.side,2);
        A.dotCoherence = P.dotCoherence;
        A.deltaDot = P.deltaDot;
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
        A.ori = S.trialsList(A.listPerm(A.listIndex+1),2);
        A.dotCoherence = S.trialsList(A.listPerm(A.listIndex+1),3);
        A.deltaDot = S.trialsList(A.listPerm(A.listIndex+1),4);
%         A.dotCoherence = P.dotCoherence;
%         A.deltaDot = P.deltaDot;
        % Update index
        A.listIndex = mod(A.listIndex+1,size(S.trialsList,1));
     case 2
        % If last trial was not forced side, then set up forced side       
            A.side = P.forceSide;
            A.sideIndex = find(S.trialsList(:,1)==A.side);
            
        if ~(A.runType == 2)
            A.listIndex = 0;
        end
        % If list has finished start, start a new list
        if ~A.listIndex
            A.listPerm = randperm(length(A.sideIndex));
        end  
            A.ori = S.trialsList(A.sideIndex(A.listPerm(A.listIndex+1)),2);
            A.dotCoherence = S.trialsList(A.sideIndex(A.listPerm(A.listIndex+1)),3);
            A.deltaDot = S.trialsList(A.sideIndex(A.listPerm(A.listIndex+1)),4);
            A.listIndex = mod(A.listIndex+1,length(A.sideIndex));
    
end
A.runType = P.runType; % NOTE LATEST RUN TYPE


% GET SOME CRUCIAL CONVERSION VALUES
DistanceCM = P.screenDistance;
ScreenWidthCM = S.screenWidth;
ScreenWidthDeg = 2*atan2((ScreenWidthCM/2),DistanceCM)*180/pi;
ScreenWidthPix = A.screenRect(3);
ScreenHeightPix = A.screenRect(4);
DegPerPix = ScreenWidthDeg/ScreenWidthPix;
PixPerDeg = 1/DegPerPix;

%dot and stimulus size
A.dotSize = round(P.dotSize*PixPerDeg);
A.deltaDot = round(A.deltaDot*PixPerDeg);




%initialize dot positions - these need to be in pixels from center
randpos=rand(2,P.nrDots); %this gives numbers between 0 and 1
randpos(1,:)=(randpos(1,:)-0.5)*ScreenWidthPix; 
randpos(2,:)=(randpos(2,:)-0.5)*ScreenHeightPix;


%copy dot positions to generate pairs 
xproj=cos(A.ori*pi/180);
yproj=-sin(A.ori*pi/180);

randpos2(1,:)=randpos(1,:)+A.deltaDot*xproj;
randpos2(2,:)=randpos(2,:)+A.deltaDot*yproj;

%pick noise dots
nrSignal=round(P.nrDots*A.dotCoherence);
nrNoise=P.nrDots-nrSignal;

%generate random locations for the noise dots - we change the orientation
%of the pair
if nrNoise>0
    noiseori=rand(1,nrNoise)*360;
    xproj=cos(noiseori*pi/180);
    yproj=-sin(noiseori*pi/180);
       
    randpos2(1,1:nrNoise)=randpos(1,1:nrNoise)+A.deltaDot*xproj; 
    randpos2(2,1:nrNoise)=randpos(2,1:nrNoise)+A.deltaDot*yproj;
end


randpos=[randpos randpos2];


%save positions
A.dotpos=randpos;

%dot color
A.dotcolor=ones(3,size(randpos,2))*255;
   
end
