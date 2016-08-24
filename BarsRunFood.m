function [A handles] = BarsRunFood(S,P,A,hObject)

% function A = BarsRun(S,P,A)
%
% This is modified from BarsInit to allow use of syringe pumps to deliver a
% liquid food reward instead of water delivered via solenoid valves. Food
% durations are currently modified on a pc that controls the pumps
% (when using SlaveConfig2, in particular, the SlaveCallback2 function).
%
% This function runs a trial of the task. The whole function runs as a
% WHILE loop, checking for changes in data input (RESPONSEPixx in this
% case). When certain conditions are met, state variables are updated.
% 0 (wait for )
% 1 (display coherent form)
% 2 (button pressed, correct, reward)
% 3 (button pressed, incorrect, no reward)
% 4 (button pressed, invalid, no reward)
% 5 (no button pressed, no reward)
%
% Created by: Sam Nummela       Last modified: 310713


%%%%% Initialize trial %%%%%
% Blank screen
Screen('FillRect',A.overlay,0);
Screen('FillRect',A.window,S.background);
lastFrameTime = Screen('Flip',A.window,GetSecs);
frameTimeStep = 1/A.frameRate;          % time between frame flips
% Get task start time
Datapixx('RegWrRd');
A.startTime = GetSecs;                  % time of trial start
A.startTimeDP = Datapixx('GetTime');    % datapixx time of trial start
% LED on
dacCheck; ledStatus = switchLED(S.chLED,10);
% State starts at 0, waiting to initiate trial
state = 0;
% Update handles
pause(.001); handles = guidata(hObject);

% Making this communications variable global so I can use it
global DcomState

%%%%% Start trial loop %%%%%
while state < 5 && ~handles.abortTask
    
    % GET STATUS OF IR BEAMS
    brokenBeams = getBeamStatus([S.chBeam1 S.chBeam2 S.chBeam3]);
    
    % GET CURRENT TIME
    currentTime = GetSecs;
    
    if state == 0 && brokenBeams(3)
        % TRIAL IS INITIATED, UPDATE STATE
        state = A.stimSide;
        % TURN OFF LED
        dacCheck; ledStatus = switchLED(S.chLED,0);
        % DELIVER INITIATION REWARD
        dacCheck; giveWater(S.chValve3,P.durValve3);
        % ASSUME SUBJECT WILL BE CORRECT ON FIRST TRY
        A.firstTry = true;
        % SET CHOICE TIME, TIME FROM WHICH THE STIMULI APPEAR
        A.choiceTime = GetSecs;
    end
    
    %%%%%%%%% STIMULUS ON RIGHT, STATE 1 SCENARIOS %%%%%%%%%
    
    % IF THE FERRET BREAKS THE WRONG BEAM, PLAY A LOW TONE, ONLY FIRST TIME
    if state == 1 && brokenBeams(2) && A.firstTry
        % NOTE RESPONSE TIME
        A.firstTime = GetSecs;
        % TRIAL NOT CORRECT ON FIRST TRY
        A.firstTry = false;
        % START A LOW TONE
        playTone(15000,P.durTone,.50);
        % END THE TRIAL NOW IF THE ONE TRY FLAG IS ACTIVE
        if P.oneTry, state = 3; A.finishTime = A.firstTime; end
    end
    
    % IF FERRET BREAKS THE CORRECT BEAM, REWARD FERRET, PLAY A HIGH TONE
    if state == 1 && brokenBeams(1)
        % NOTE TIME
        A.finishTime = GetSecs;
        if A.firstTry, A.firstTime = A.finishTime; end
        % PLAY HIGH TONE
        playTone(50000,P.durTone,.10);
        % DELIVER REWARD TO THE RIGHT SIDE
        fwrite(DcomState.serialPortHandle,'R~');
        % TRIAL IS COMPLETE
        state = 3;
    end
    
    %%%%%%%%% STIMULUS ON LEFT, STATE 2 SCENARIOS %%%%%%%%%
    
    % IF THE FERRET BREAKS THE WRONG BEAM, PLAY A LOW TONE, ONLY FIRST TIME
    if state == 2 && brokenBeams(1) && A.firstTry
        % NOTE RESPONSE TIME
        A.firstTime = GetSecs;
        % TRIAL NOT CORRECT ON FIRST TRY
        A.firstTry = false;
        % START A LOW TONE
        playTone(15000,P.durTone,.50);
        % END THE TRIAL NOW IF THE ONE TRY FLAG IS ACTIVE
        if P.oneTry, state = 3; A.finishTime = A.firstTime; end
    end
    
    % IF FERRET BREAKS THE CORRECT BEAM, REWARD FERRET, PLAY A HIGH TONE
    if state == 2 && brokenBeams(2)
        % NOTE TIME
        A.finishTime = GetSecs;
        if A.firstTry, A.firstTime = A.finishTime; end
        % PLAY HIGH TONE
        playTone(50000,P.durTone,.10);
        % DELIVER REWARD TO THE RIGHT SIDE
        fwrite(DcomState.serialPortHandle,'L~');
        % TRIAL IS COMPLETE
        state = 3;
    end
    
    % FIND OUT WHEN FEEDBACK IS OVER
    if state == 3
        if lastFrameTime > A.finishTime + P.durTone
            state = 4;
        end
    end
    
    % CHECK IF IT'S TIME TO LEAVE THE RUN LOOP
    if state == 4
        if lastFrameTime > A.finishTime + P.durTone + P.durTimeOut + P.durITI
            state = 5;
        end
    end
    
    if currentTime > lastFrameTime + frameTimeStep - 0.006
        % ALWAYS DRAW (3 red, 4 green, 5 blue) UR [1720 0 1920 200]
        if ~brokenBeams(1)  % RIGHT BEAM
            Screen('FrameRect',A.overlay,4,[1700 50 1780 130]);
        elseif brokenBeams(1)
            Screen('FillRect',A.overlay,4,[1700 50 1780 130]);
        end
        if ~brokenBeams(2)  % LEFT BEAM
            Screen('FrameRect',A.overlay,4,[140 50 220 130]);
        elseif brokenBeams(2)
            Screen('FillRect',A.overlay,4,[140 50 220 130]);
        end
        if ~brokenBeams(3)  % REAR BEAM
            Screen('FrameRect',A.overlay,4,[920 50 1000 130]);
        elseif brokenBeams(3)
            Screen('FillRect',A.overlay,4,[920 50 1000 130]);
        end
        if ledStatus        % RED LED
            Screen('FillOval',A.overlay,3,[1010 60 1070 120]);
        else
            Screen('FrameOval',A.overlay,3,[1010 60 1070 120]);
        end
        
        % DRAW STIMULI DURING STATES 1 OR 2 (animal choice)
        if state == 1 || state == 2
            Screen('DrawTextures',A.window,A.distTex,[],A.distXY,P.distTheta);
            Screen('FillRect',A.window,S.background,A.stimXY);
            Screen('DrawTexture',A.window,A.stimTex,[],A.stimXY,P.stimTheta);
        end
        
        % SHOW ONLY THE STIMULUS DURING STATES 3 (feedback)
        if state == 3
            Screen('DrawTexture',A.window,A.stimTex,[],A.stimXY,P.stimTheta);
        end
        
        % FLIP THE FRAME
        lastFrameTime = Screen('Flip',A.window,GetSecs);
        
        % Reset display for next cycle
        Screen('FillRect',A.overlay,0);
        Screen('FillRect',A.window,S.background);
        
        % Pause and update handles
        pause(.001); handles = guidata(hObject);
    end
        
end

% CLEAR SCREEN
Screen('Flip',A.window);

% ENSURE DAC SCHEDULES HAVE ALL FINISHED
dacCheck;
% TURN OFF LED IF TRIAL IS ABORTED
if handles.abortTask
    switchLED(S.chLED,0);
end

% ANY PARAMETERS TO BE DIRECTLY SAVED SHOULD BE TRANSFERRED TO A HERE
A.lineColor = P.lineColor;
A.distTheta = P.distTheta;
end

% PLAY TONE
function playTone(freq,durTone,dB)
Datapixx('SetAudioVolume',[0.00 dB; 0.00 dB]); Datapixx('RegWrRd');
nSamples = ceil(freq*durTone);
Datapixx('StopAudioSchedule');
Datapixx('SetAudioSchedule',0,freq,nSamples,0,16e6,64);
Datapixx('StartAudioSchedule'); Datapixx('RegWrRd');
end

% LED SWITCH
function ledStatus = switchLED(chLED,volts)
% Turns LED on/off
Datapixx('WriteDacBuffer',volts,0,chLED);
Datapixx('SetDacSchedule',0,1000,1,chLED,0,1);
Datapixx('StartDacSchedule'); Datapixx('RegWrRd');
ledStatus = volts > 0;
end

% GIVE WATER
function giveWater(vch,vdur)
% Opens solenoid valve to deliver water for the duration in seconds
dacWave = [zeros(1,5) repmat(10,1,vdur) zeros(1,5)];
Datapixx('WriteDacBuffer',dacWave,0,vch);
Datapixx('SetDacSchedule',0,1000,vdur+10,vch,0,vdur+10);
Datapixx('StartDacSchedule'); Datapixx('RegWrRd');
end
        
% CHECK BEAM STATUS
function beamStatus = getBeamStatus(channels)
% Check if any of the IR beams have been occluded: this is indicated by a
% voltage shift from about 4.5 volts to about 0 volts.
Datapixx('RegWrRd');
voltages = Datapixx('getAdcVoltages');
beamStatus = voltages(channels+1) < 2;      % index 1 is channel 0
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
