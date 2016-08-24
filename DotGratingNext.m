function [A P] = DotGratingNext(S,P,A)

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
        A.ori = 90*(A.side-1);
        %A.dotCoherence = P.dotCoherence;
        %A.deltaDot = P.deltaDot;
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
        %A.dotCoherence = S.trialsList(A.listPerm(A.listIndex+1),3);
        %A.deltaDot = S.trialsList(A.listPerm(A.listIndex+1),4);
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

%dot and stimulus size
A.dotSize = round(P.dotSize*PixPerDeg);
A.distRow = round(P.distRow*PixPerDeg);
A.dotSep = round(P.dotSep*PixPerDeg);
A.pairSep = round(P.pairSep*PixPerDeg);
A.distNoise = round(P.distNoise*PixPerDeg);
%A.stimRadius = round(P.stimRadius*PixPerDeg);
%A.deltaDot = round(A.deltaDot*PixPerDeg);


%get base coordinates for disk center
if A.side==2 %horizontal grating
    
    nlines=floor(0.5*(ScreenWidthPix-200)/(A.dotSep+A.pairSep));
    xvec1=[-nlines:nlines]*(A.dotSep+A.pairSep);
    
    nlines=floor(0.5*(ScreenHeightPix-200)/A.distRow);
    yvec=[-nlines:nlines]*A.distRow;
    
    [xloc1,yloc1]=meshgrid(xvec1,yvec);
    xloc2=xloc1+A.dotSep;
    yloc2=yloc1;
    
    if P.dotColor==1 %alternating b/w rows
        color1=zeros(size(xloc1));
        color1([1:2:size(color1,1)],:)=1;
        color2=color1;
    else
        color1=ones(size(xloc1));
        color2=color1;
    end
    
    
    xloc1=xloc1(:);
    xloc2=xloc2(:);
    yloc1=yloc1(:);
    yloc2=yloc2(:);
    color1=color1(:);
    color2=color2(:);
    
    %add position noise
    randpos=round(rand(length(xloc1),2)*A.distNoise);
    xloc1=xloc1+randpos(:,1);
    xloc2=xloc2+randpos(:,1);
    yloc1=yloc1+randpos(:,2);
    yloc2=yloc2+randpos(:,2);
      
    %determine which points to remove
    Nkeep=round(P.dotFraction*length(xloc1));    
    dotIdx=randperm(length(xloc1),Nkeep);
    
    xloc1=xloc1(dotIdx);
    xloc2=xloc2(dotIdx);
    yloc1=yloc1(dotIdx);
    yloc2=yloc2(dotIdx);
    color1=color1(dotIdx);
    color2=color2(dotIdx);
    
else
    nlines=floor(0.5*(ScreenWidthPix-200)/A.distRow);
    xvec=[-nlines:nlines]*A.distRow;
    
    nlines=floor(0.5*(ScreenHeightPix-100)/(A.dotSep+A.pairSep));
    yvec1=[-nlines:nlines]*(A.dotSep+A.pairSep);
    
    [xloc1,yloc1]=meshgrid(xvec,yvec1);
    yloc2=yloc1+A.dotSep;
    xloc2=xloc1;
    
    
    if P.dotColor==1
        color1=zeros(size(xloc1));
        color1(:,[1:2:size(color1,2)])=1;
        color2=color1;
    else
        color1=ones(size(xloc1));
        color2=color1;
    end
    
    xloc1=xloc1(:);
    xloc2=xloc2(:);
    yloc1=yloc1(:);
    yloc2=yloc2(:);
    color1=color1(:);
    color2=color2(:);
    
    %add position noise
    randpos=round(rand(length(yloc1),2)*A.distNoise);
    xloc1=xloc1+randpos(:,1);
    xloc2=xloc2+randpos(:,1);
    yloc1=yloc1+randpos(:,2);
    yloc2=yloc2+randpos(:,2);
    
    
    %determine which points to remove
    Nkeep=round(P.dotFraction*length(yloc1));    
    dotIdx=randperm(length(yloc1),Nkeep);
    
    xloc1=xloc1(dotIdx);
    xloc2=xloc2(dotIdx);
    yloc1=yloc1(dotIdx);
    yloc2=yloc2(dotIdx);
    color1=color1(dotIdx);
    color2=color2(dotIdx);
    
end

   
A.dotpos=[];
A.dotpos(1,:)=[xloc1;xloc2]';
A.dotpos(2,:)=[yloc1;yloc2]';
A.dotcolor=repmat([color1;color2]'*255,3,1);

