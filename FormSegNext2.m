function [A P] = FormSegNext2(S,P,A)

% function [A P] = FormSegNext2(S,P,A)
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
% Created by: Sam Nummela       Last modified: 060613

% LAST TRIAL TYPE, 0 random, 1 pseudorandom, 2 blocking
% If new output file, assume the last trial type was random
if A.newOutput, A.runType = 0; A.newOutput = 0; end

% GET STIMULUS SIDE AND BACKGROUND LINE COLOR
switch P.runType
    case 0
        % random stimulus side
        A.stimSide = ceil(2*rand);
        % get line color from the line color parameter
        A.lineColor = P.lineColor;
    case 1
        % If last trial was not pseudo random, set up a trial list
        if ~(A.runType == 1)
            A.listIndex = 0;
        end
        % If list has finished start, start a new list
        if ~A.listIndex
            A.listPerm = randperm(size(S.trialsList,1));
        end
        % Get stimulus side and line color from trials list
        A.stimSide = S.trialsList(A.listPerm(A.listIndex+1),1);
        A.lineColor = S.trialsList(A.listPerm(A.listIndex+1),2);
        % Update index
        A.listIndex = mod(A.listIndex+1,size(S.trialsList,1));
    case 2
        % If last trial was not blocking, then set up blocking
        if ~(A.runType == 2)
            A.stimSide = ceil(2*rand);
            A.blockIndex = 0;
        end
        % If block has finished, start a new block
        if ~A.blockIndex
            A.stimSide = mod(A.stimSide,2)+1;
            A.blockLength = P.blockLengthMin + floor((P.blockLengthRan+1)*rand);
        end
        % Update block index, reaching block length resets it to 0
        A.blockIndex = mod(A.blockIndex+1,A.blockLength);
        % get line color from the line color parameter
        A.lineColor = P.lineColor;
end

% Update the run type, this is tracked so when the run type changes, history
% dependent run types (blocking, trials list) will correctly start a new
% set of trials
A.runType = P.runType;

% MAKE A LINE TEXTURE WITH A TRANSPARENCY LAYER
line = zeros(P.lineWidth+2,P.lineLength+2,4);
line(2:end-1,2:end-1,4) = 255;
line(:,:,1:3) = 255;
A.lineTex = Screen('MakeTexture',A.window,line);

% MAKE A DISTRACTER LINE WITH A DIFFERENT COLOR
line(:,:,1:3) = P.lineColor;
A.distTex = Screen('MakeTexture',A.window,line);

% Get visual stimuli, right stim is c.XY.form1, left is c.XY.form2

centers = [P.stimH P.stimV; -P.stimH P.stimV];
XY = genCoherentForm(centers,P.stimCoherence,P.stimRadius,P.lineNumber);
A.rectForm1 = [XY.form1(:,1:2) XY.form1(:,1)+P.lineLength+2 XY.form1(:,2)+P.lineWidth+2]';
A.thetaForm1 = 180*XY.form1(:,3)'./pi;
A.rectRand1 = [XY.rand1(:,1:2) XY.rand1(:,1)+P.lineLength+2 XY.rand1(:,2)+P.lineWidth+2]';
A.thetaRand1 = 180*XY.rand1(:,3)'./pi;
A.rectForm2 = [XY.form2(:,1:2) XY.form2(:,1)+P.lineLength+2 XY.form2(:,2)+P.lineWidth+2]';
A.thetaForm2 = 180*XY.form2(:,3)'./pi;
A.rectRand2 = [XY.rand2(:,1:2) XY.rand2(:,1)+P.lineLength+2 XY.rand2(:,2)+P.lineWidth+2]';
A.thetaRand2 = 180*XY.rand2(:,3)'./pi;
A.rectBkgd = [XY.background(:,1:2) XY.background(:,1)+P.lineLength+2 XY.background(:,2)+P.lineWidth+2]';
A.thetaBkgd = 180*XY.background(:,3)'./pi;
end

% STIMULI GENERATION
function [XY] = genCoherentForm(centers,coh,rad,N)

% function [XY] = genCoherentForm(centers,coh,rad,lineLength,lineNumber)
%
% This function generates randomly distributed line segments of equal
% length within a rectangle that cohere, within the boundary of a circle,
% to a tangential orientation. Elsewhere line orientation is uniformly and
% randomly distributed.
%
% XY is a 2x2n array, where column vectors of each 2x2 section indicate the
% starting xy and ending xy coordinates of each line.
%
% Created on: 150413    Created by: Sam Nummela

% Adjust centers because now changing reference
centers = centers + [960 510; 960 510];

% NOTE THAT COHERENCE OF 1 IS ASSUMED TO BE 100%, NOT 1%!!!!
% Transform coherence from percent to a fraction if > 1
if coh > 1, coh = coh/100; end
% Screen dimensions (pixels)
rectPixels = [1920 1080];

% X and Y coordinates of line segment centers
Xc = floor(rectPixels(1)*rand(1,N));
Yc = floor(rectPixels(2)*rand(1,N));
% Random orientations of line segments in radians
% R = pi*rand(1,lineNumber);
%%%%% MAKING LINE ORIENTATIONS NOT RANDOM!!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R = 0.5*pi*ones(1,N);

% TRUNCATES ALL LINES WHOSE CENTERS ARE ABOVE 380 PIXELS FROM SCREEN CENTER
iT = Yc > 380; R = R(iT); Xc = Xc(iT); Yc = Yc(iT); N = sum(iT);

% Index for points in stimuli
inAny = false(N,1);
% Cycle through form centers
for i = 1:size(centers,1)
    % Get center
    center = centers(i,:);
    
    % Find all line segments within the circle boundary
    circleX = Xc - center(1);   % X coordinate relative to circle center
    circleY = Yc - center(2);   % Y coordinate relative to circle center
    circleY = circleY - 150;    % SHIFTS CIRCLE DOWN FOR TRUNCATED SCREEN
    inCirc = circleX.^2 + circleY.^2 < rad^2;
    nIn = sum(inCirc);
    
    % Add those segments to inAny
    inAny(inCirc) = true;
    
    % GENERATE LINE ENDPOINTS FOR THE INCOHERENT FORM
    randname = sprintf('rand%s',num2str(i));
    XY.(randname) = [Xc(inCirc)' Yc(inCirc)' R(inCirc)'];
    
    % AT THIS POINT WE USE THE COHERENCE INPUT ARGUMENT
    % The idea is to take only the fraction of segments specified and
    % change them to cohere tangentially
    if coh < 1
        nCoh = round(coh*nIn);
        if nCoh > 0
            temp = find(inCirc,nCoh);
            R(temp) = pi/2 - atan2(circleX(temp),circleY(temp)) + pi/2;
        end
    else
        R(inCirc) = pi/2 - atan2(circleX(inCirc),circleY(inCirc)) + pi/2;
    end
    
    % GENERATE LINE ENDPOINTS FOR THE COHERENT FORM
    formname = sprintf('form%s',num2str(i));
    XY.(formname) = [Xc(inCirc)' Yc(inCirc)' R(inCirc)'];
end

% GENERATE LINE ENDPOINTS FOR THE BACKGROUND
XY.background = [Xc(~inAny)' Yc(~inAny)' R(~inAny)'];

end
