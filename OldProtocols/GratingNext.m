function [A P] = GratingNext(S,P,A)

% function [A P] = GratingNext(S,P,A)
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
% Created by: Sam Nummela       Last modified: 300513

if ~isfield(A,'vidDir')
    A.vidDir = A.outputFile;
    global DcomState
    cmd = strcat(A.outputFile,'~');
    fwrite(DcomState.serialPortHandle,cmd);
    pause(0.001);
end

% Get task start time
Datapixx('RegWrRd');
A.startTime = GetSecs;                  % time of trial start
A.startTimeDP = Datapixx('GetTime');    % datapixx time of trial start

% LAST TRIAL TYPE, 0 random, 1 pseudorandom, 2 blocking
% If new output file, assume the last trial type was random
if A.newOutput, A.runType = 0; A.newOutput = 0; end

% GET STIMULUS SIDE AND BACKGROUND LINE COLOR
switch P.runType
    case 0
        % random stimulus side
        A.stimSide = ceil(2*rand);
        % random stimulus direction
        P.dir = 2*ceil(2*rand)-3;
    case 1
        % If last trial was not pseudo random, set up a trial list
        if ~(A.runType == 1)
            A.listIndex = 0;
        end
        % If list has finished start, start a new list
        if ~A.listIndex
            A.listPerm = randperm(size(S.trialsList,1));
        end
        % Get stimulus side
        A.stimSide = S.trialsList(A.listPerm(A.listIndex+1),1);
        % Get cycles per degree
        P.cpd = S.trialsList(A.listPerm(A.listIndex+1),2);
        % Get cycles per second
        P.cps = S.trialsList(A.listPerm(A.listIndex+1),3);
        % Get cycles per degree
        P.dir = S.trialsList(A.listPerm(A.listIndex+1),4);
        % Get grating angle
        P.angle = S.trialsList(A.listPerm(A.listIndex+1),5);
        % Update index
        A.listIndex = mod(A.listIndex+1,length(S.trialsList));
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
        % random stimulus direction
        P.dir = 2*ceil(2*rand)-3;  % direction
end

% Update the run type, this is tracked so when the run type changes, history
% dependent run types (blocking, trials list) will correctly start a new
% set of trials
A.runType = P.runType;

% GET SOME USEFUL VALUES
% cm per pixel
cmperpix = S.screenWidth/A.screenRect(3);
% angle subtended by stimulus
t1 = atan2(cmperpix*150,P.screenDistance);
t2 = atan2(cmperpix*650,P.screenDistance);
t = (t2-t1)*180/pi;
% number of cycles in that span
cycN = P.cpd * t;
% factor to multiply the meshgrid (x)
r = cycN*pi/250;
% speed in cycles per frame
cycperframe = P.cps/A.frameRate;
% radians to advance per frame
rpf = cycperframe*2*pi;
                
% STIMULUS GENERATION

% CREATE A MASK
[x y] = meshgrid(-250:250);
fade = round((x.^2 + y.^2-235^2).^.75);
fade(fade < 0) = 0; fade(fade > 255) = 255;
mask = zeros(501,501,2) + P.bkgd;
mask(:,:,2) = fade;
A.maskTex = Screen('MakeTexture',A.window,mask);

% CREATE THE GRATING TEXTURES
ra = 2*pi*rand;         % random starting phase
if rpf > 0
    A.gratTex = nan(ceil(A.frameRate*P.stimDur),1);
    for frame = 1:length(A.gratTex)
        grat = round(P.range*sin(P.dir*r*x+rpf*frame+ra))+127;
        A.gratTex(frame) = Screen('MakeTexture',A.window,grat);
    end
else
    grat = round(P.range*sin(P.dir*r*x+ra))+127;
    A.gratTex = Screen('MakeTexture',A.window,grat);
end

end
