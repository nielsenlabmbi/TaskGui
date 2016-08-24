function [A, P] = SearchNext(S,P,A)

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
        A.targetType = S.trialsList(A.listPerm(A.listIndex+1),2);
        % Update index
        A.listIndex = mod(A.listIndex+1,size(S.trialsList,1));
        
end
A.runType = P.runType; % NOTE LATEST RUN TYPE

% GET SOME CRUCIAL CONVERSION VALUES
DistanceCM = S.screenDistance;
ScreenWidthCM = S.screenWidth;
ScreenWidthDeg = 2*atan2((ScreenWidthCM/2),DistanceCM)*180/pi;
ScreenWidthPix = A.screenRect(3);
ScreenHeightPix = A.screenRect(4);
DegPerPix = ScreenWidthDeg/ScreenWidthPix;
PixPerDeg = 1/DegPerPix;




%Color is the color of the distractors color 2 is the target color
A.colorDist=(1-.5)*P.contrast/100+.5;

% if P.stimType==1
%    A.colorDist=(1-.5)+.5; 
% end

%disable following line to sync colors
A.colorTarget=[1 1 1];

% Circle sizes
% \/ makes circles have the same area as the triangle
dotArea=PixPerDeg^2*P.area;
A.dotRadius = sqrt(dotArea/pi);

%compute triangle side length
tSide=sqrt((4*dotArea)/sqrt(3));
tR=tSide*sqrt(3)/3;

%Spacing between shapes
Sx=round(A.dotRadius*2.5);


%Creates a matrix of X and Y values for the screen (these are the center of
%the stimuli)
XLimit=ScreenWidthPix-Sx;
YLimit=ScreenHeightPix-Sx;
[X, Y] = meshgrid (-XLimit/2:Sx:XLimit/2,-YLimit/2:Sx:(YLimit/2-200));
X=X(:);
Y=-Y(:);

%pick one location to put the triangle
if A.side==1 %right trial
    idx=find(X>P.protectZone);
    targetID=idx(randi(length(idx),1));
    targetX=X(targetID);
    targetY=Y(targetID);
else
    idx=find(X<-P.protectZone);
    targetID=idx(randi(length(idx),1));
    targetX=X(targetID);
    targetY=Y(targetID);
end




A.trianglePos=[];
A.dotPos=[];

% Creating the distractors for the other stim type
if P.stimType==1;
    if A.side==2 %right trial
        idx=find(X>P.protectZone);
        ridx=randperm(length(idx));
        distID=idx(ridx(1:P.nrDist));
        distX=X(distID);
        distY=Y(distID);
    else
        idx=find(X<-P.protectZone);
        ridx=randperm(length(idx));
        distID=idx(ridx(1:P.nrDist));
        distX=X(distID);
        distY=Y(distID);
    end
    A.dotPos=[distX distY];
    
     tX=targetX+ScreenWidthPix/2;
        tY=targetY+ScreenHeightPix/2;
        A.trianglePos{1}(1,:)=[tX-tSide/2 tY-tR/2]; %row: x,y of a vertex
        A.trianglePos{1}(2,:)=[tX+tSide/2 tY-tR/2];
        A.trianglePos{1}(3,:)=[tX tY+tR];
else
    
    %pick the distractor locations, avoiding the target location
    Xtemp=X(:);
    Ytemp=Y(:);
    Xtemp(targetID)=[];
    Ytemp(targetID)=[];
    randIdx=randperm(length(Xtemp));
    distID=randIdx(1:P.nrDist);
    distX=Xtemp(distID);
    distY=Ytemp(distID);
    
    if A.targetType==1 %target is a triangle
        tX=targetX+ScreenWidthPix/2;
        tY=targetY+ScreenHeightPix/2;
        A.trianglePos{1}(1,:)=[tX-tSide/2 tY-tR/2]; %row: x,y of a vertex
        A.trianglePos{1}(2,:)=[tX+tSide/2 tY-tR/2];
        A.trianglePos{1}(3,:)=[tX tY+tR];
        
        A.dotPos=[distX distY];
        
    else %target is a circle
        A.dotPos=[targetX targetY];
        
        for i=1:P.nrDist
            A.trianglePos{i}(1,:)=[targetX(i)-tSide/2 targetY(i)-tR/2]; %row: x,y of a vertex
            A.trianglePos{i}(2,:)=[targetX(i)+tSide/2 targetY(i)-tR/2];
            A.trianglePos{i}(3,:)=[targetX(i) targetY(i)+tR];
        end
    end
end