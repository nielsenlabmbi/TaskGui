function [A handles] = GratingRun2(S,P,A,hObject)

% function [A handles] = GratingRun2(S,P,A,hObject)
%
% This function runs a trial of the task. The whole function runs as a
% WHILE loop, checking for changes in data input (RESPONSEPixx in this
% case). When certain conditions are met, state variables are updated.
%
% Created by: Sam Nummela       Last modified: 300913


%%%%% Initialize trial %%%%%
% Blank screen
Screen('FillRect',A.window,P.bkgd/255);
lastFrameTime = Screen('Flip',A.window,GetSecs);
frameTimeStep = 1/A.frameRate;          % time between frame flips
% State starts at 0
state = 0;
% Update handles
pause(.001); handles = guidata(hObject);

%%%%% Start trial loop %%%%%
while state < 2 && ~handles.abortTask
    
    % GET CURRENT TIME
    currentTime = GetSecs;
    
    % GET STATUS OF IR BEAM
    brokenBeam = getBeamStatus(S.chBeam);
    
    % START SHOWING STIMULUS WHEN BEAM IS BROKEN (OR NOT TRIGGERING)
    if state == 0
        % DECIDE WHETHER TO START STIMULUS PRESENTATION (STATE 1)
        if brokenBeam || ~P.trigger
            state = 1;
            % Get task start time
            Datapixx('RegWrRd');
            A.startTime = GetSecs;                  % time of trial start
            A.startTimeDP = Datapixx('GetTime');    % datapixx time of trial start
            % LED on
            dacCheck; switchLED(S.chLED1,10);
        end
    end
    
    % DETERMINE WHEN TO TURN STIMULUS OFF
    if state == 1
        if currentTime > A.startTime + P.stimDur
            state = 2;
            % Turn OFF the start LED
            dacCheck; switchLED(S.chLED1,0);
        end
    end
    
    if currentTime > lastFrameTime + frameTimeStep - 0.006
        % UPDATE BEAM STATUS
        if ~brokenBeam  % MIDWAY BEAM
            Screen('FrameRect',A.overlay,5,[920 50 1000 130]);
        elseif brokenBeam
            Screen('FillRect',A.overlay,5,[920 50 1000 130]);
        end
        
        % SHOW GRATING WHEN STATE IS 1
        if state == 1
            Screen('DrawTexture',A.window,A.gratTex,[],A.gratPos(A.stimSide,:),P.angle);
        end
        
        % FLIP FRAME
        lastFrameTime = Screen('Flip',A.window,GetSecs);
        
        % CLEAR THE SCREEN
        Screen('FillRect',A.overlay,0);
        Screen('FillRect',A.window,P.bkgd/255);
        
        % Pause and update handles
        pause(.001); handles = guidata(hObject);
    end
end

% CLEAR SCREEN
Screen('FillRect',A.window,P.bkgd/255);
Screen('Flip',A.window);

% SETTING stopTask TO TRUE WILL STOP THE TASK AFTER THIS TRIAL
handles.stopTask = true;

% HERE I AM SETTING UP PARAMETERS FOR THE NEXT TRIAL
switch P.runType
    case 0
        % CHOOSE A STIM SIDE AND c/deg AT RANDOM
        handles.P.stimSide = ceil(3*rand);
        cpds = [0.125 0.25 .5];
        handles.P.cpd = cpds(ceil(length(cpds)*rand));
    case 1
        % If last trial was not pseudrandom, set up a trial list
        if ~(A.runType == 1); A.listIndex = 0; end
        % If list has finished start, start a new list
        if ~A.listIndex; A.listPerm = randperm(size(S.trialsList,1)); end
        % Get stimulus side and line color from trials list
        handles.P.cpd = S.trialsList(A.listPerm(A.listIndex+1),1);
        handles.P.stimSide = S.trialsList(A.listPerm(A.listIndex+1),2);
        % Update index
        A.listIndex = mod(A.listIndex+1,size(S.trialsList,1));
end
A.runType = P.runType;

end

% DAC CHECK
function dacReady = dacCheck
% Waits until DAC schedule is finished, run before starting a DAC schedule 
Datapixx('RegWrRd');
dacStatus = Datapixx('GetDacStatus');
while dacStatus.scheduleRunning == 1;
    Datapixx('RegWrRd');
    dacStatus = Datapixx('GetDacStatus');
end
dacReady = 1;
end

% LED SWITCH
function ledStatus = switchLED(chLED,volts)
% Turns LED on/off
Datapixx('WriteDacBuffer',volts,0,chLED);
Datapixx('SetDacSchedule',0,1000,1,chLED,0,1);
Datapixx('StartDacSchedule'); Datapixx('RegWrRd');
ledStatus = volts > 0;
end
        
% CHECK BEAM STATUS
function beamStatus = getBeamStatus(channels)
% Check if any of the IR beams have been occluded: this is indicated by a
% voltage shift from about 4.5 volts to about 0 volts.
Datapixx('RegWrRd');
voltages = Datapixx('getAdcVoltages');
beamStatus = voltages(channels+1) < 2;      % index 1 is channel 0
end
