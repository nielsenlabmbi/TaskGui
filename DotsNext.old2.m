function [A P] = DotsNext(S,P,A)

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
        A.dotCoherence = P.dotCoherence;
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
        A.dotCoherence = S.trialsList(A.listPerm(A.listIndex+1),3);
        % Update index
        A.listIndex = mod(A.listIndex+1,size(S.trialsList,1));
    
end
A.runType = P.runType; % NOTE LATEST RUN TYPE

% TAKE THE SPATIAL FREQUENCY (cpd) AND GENERATE A STIMULUS

% GET SOME CRUCIAL CONVERSION VALUES
DistanceCM = P.screenDistance;
ScreenWidthCM = S.screenWidth;
ScreenWidthDeg = 2*atan2((ScreenWidthCM/2),DistanceCM)*180/pi;
ScreenWidthPix = A.screenRect(3);
ScreenHeightPix = A.screenRect(4);
DegPerPix = ScreenWidthDeg/ScreenWidthPix;
PixPerDeg = 1/DegPerPix;

%dot size
A.dotSize = round(P.dotSize*PixPerDeg);


%initialize dot positions - these need to be in pixels from center
randpos=rand(2,P.nrDots); %this gives numbers between 0 and 1
randpos(1,:)=(randpos(1,:)-0.5)*ScreenWidthPix; %now we have between -stimsize/2 and +stimsize/2
randpos(2,:)=(randpos(2,:)-0.5)*ScreenHeightPix;


%pick color for each dot
A.dotcolor=ones(3,P.nrDots)*255;
A.dotcolor(:,1:round(P.fractionBlack*P.nrDots))=0;
A.dotcolor=A.dotcolor(:,randperm(P.nrDots));

%initialize noise vector
nrSignal=round(P.nrDots*A.dotCoherence);
noisevec=zeros(P.nrDots,1);
noisevec(1:nrSignal)=1;

%initialize lifetime vector
if P.dotLifetime>0
    lifetime=randi(P.dotLifetime,P.nrDots,1);
end

%compute nr frames
A.nrFrames=P.durStim*S.frameRate;

%compute vectors for necessary frames
for f=1:A.nrFrames
    %first move everybody according to displacement, and check
    %for wrap around
    if A.side == 1 % Draw textures in order if side == 1
        randpos(1,:)=randpos(1,:)+P.dotSpeed;
        randpos(1,randpos(1,:)>A.screenRect(3)/2)=-A.screenRect(3)/2;
    end
    if A.side == 2 % Draw textures in reverse if side == 2
        randpos(1,:)=randpos(1,:)-P.dotSpeed;
        randpos(1,randpos(1,:)<-A.screenRect(3)/2)=A.screenRect(3)/2;
    end
            
    %then find new positions for noise dots
    noiseid=noisevec(randperm(P.nrDots)); %noisevec has the right nr of 1 and 0
    idx=find(noiseid==0); %1 is signal dot
    temppos=rand(2,length(idx));
    temppos(1,:)=(temppos(1,:)-0.5)*A.screenRect(3);
    temppos(2,:)=(temppos(2,:)-0.5)*A.screenRect(4);
    randpos(:,idx)=temppos;
            
    %remove and replace dots based on lifetime
    if P.dotLifetime>0
        idx=find(lifetime==0);
        temppos=rand(2,length(idx));
        temppos(1,:)=(temppos(1,:)-0.5)*A.screenRect(3);
        temppos(2,:)=(temppos(2,:)-0.5)*A.screenRect(4);
        randpos(:,idx)=temppos;
        
        lifetime=lifetime-1;
        lifetime(idx)=P.dotLifetime;
    end
    
    A.dotpos{f}=randpos;
   
end
