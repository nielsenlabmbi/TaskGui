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
        A.dotSpeed=P.dotSpeed;
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
        A.dotSpeed = S.trialsList(A.listPerm(A.listIndex+1),4);
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
            A.dir = S.trialsList(A.sideIndex(A.listPerm(A.listIndex+1)),2);
            A.dotCoherence = S.trialsList(A.sideIndex(A.listPerm(A.listIndex+1)),3);
            A.dotSpeed = S.trialsList(A.sideIndex(A.listPerm(A.listIndex+1)),4);
            A.listIndex = mod(A.listIndex+1,length(A.sideIndex));
  
    
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
randpos(1,:)=(randpos(1,:)-0.5)*ScreenWidthPix; 
randpos(2,:)=(randpos(2,:)-0.5)*ScreenHeightPix;


%pick color for each dot
A.dotcolor=ones(3,P.nrDots)*255;
A.dotcolor(:,1:round(P.fractionBlack*P.nrDots))=0;
A.dotcolor=A.dotcolor(:,randperm(P.nrDots));

%initialize noise vector
nrSignal=round(P.nrDots*A.dotCoherence);
noisevec=zeros(P.nrDots,1);
noisevec(1:nrSignal)=1;

%initialize directions: correct displacement for signal, random for noise
%side is either 1 or 2; 1 should equal ori=0, 2 ori=180
randdir=zeros(P.nrDots,1);
randdir(1:end)=(A.side-1)*180;
idx=find(noisevec==0);
randdir(idx)=randi([0,359],length(idx),1);


%initialize lifetime vector
if P.dotLifetime>0
    lifetime=randi(P.dotLifetime,P.nrDots,1);
end

%compute nr frames
A.nrFrames=P.durStim*S.frameRate;

%compute speed
deltaF=A.dotSpeed*PixPerDeg;


%compute vectors for necessary frames
for f=1:A.nrFrames
    
    %move all dots according to their direction
    xproj=cos(randdir*pi/180);
    yproj=-sin(randdir*pi/180);
    
    randpos(1,:)=randpos(1,:)+deltaF*xproj';
    randpos(2,:)=randpos(2,:)+deltaF*yproj';
    
    %now deal with wrap around - we pick the axis on which to replot a dot
    %based on the dots direction
    idx=find(abs(randpos(1,:))>ScreenWidthPix/2 | abs(randpos(2,:))>ScreenHeightPix/2);
    
    rvec=rand(size(idx)); %btw 0 and 1
    for i=1:length(idx)
        if rvec(i)<=abs(xproj(idx(i)))/(abs(xproj(idx(i)))+abs(yproj(idx(i))))
            randpos(1,idx(i))=-1*sign(xproj(idx(i)))*ScreenWidthPix/2;
            randpos(2,idx(i))=(rand(1)-0.5)*ScreenHeightPix;
        else
            randpos(1,idx(i))=(rand(1)-0.5)*ScreenWidthPix;
            randpos(2,idx(i))=-1*sign(yproj(idx(i)))*ScreenHeightPix/2;
        end        
    end
    
            
    %if lifetime is expired, randomly assign new direction
    if P.dotLifetime>0
        idx=find(lifetime==0);
        %directions are drawn based on coherence level
        rvec=rand(size(idx));
        for i=1:length(idx)
            if rvec(i)<A.dotCoherence %these get moved with the signal
                randdir(idx(i))=(A.side-1)*180;
            else
                randdir(idx(i))=randi([0,359],1,1);
            end
        end
        
        lifetime=lifetime-1;
        lifetime(idx)=P.dotLifetime;
    end
    
    A.dotpos{f}=randpos;
   
end
