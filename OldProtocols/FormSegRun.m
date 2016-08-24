function [A handles] = FormSegRun(S,P,A,hObject)

% function A = FormSegRun(S,P,A)
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
% Created by: Sam Nummela       Last modified: 210513


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

%%%%% Start trial loop %%%%%
while state < 3 && ~handles.abortTask
    
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
    end
    
    %%%%%%%%% STIMULUS ON RIGHT, STATE 1 SCENARIOS %%%%%%%%%
    
    % IF THE FERRET BREAKS THE WRONG BEAM, PLAY A LOW TONE, ONLY FIRST TIME
    if state == 1 && brokenBeams(2) && A.firstTry
        % PLAY LOW TONE
        playTone(15000,P.durTone,.25);
        % TRIAL NOT CORRECT ON FIRST TRY
        A.firstTry = false;
        % NOTE FIRST RESPONSE TIME
        A.firstTime = GetSecs;
        
        % END THE TRIAL NOW IF THE ONE TRY FLAG IS ACTIVE
        if P.oneTry, state = 3; end
    end
    
    % IF FERRET BREAKS THE CORRECT BEAM, REWARD FERRET, PLAY A HIGH TONE
    if state == 1 && brokenBeams(1)
        % TRIAL IS COMPLETE
        state = 3;
        % PLAY HIGH TONE
        playTone(50000,P.durTone,.10);
        % DELIVER REWARD
        dacCheck; giveWater(S.chValve1,P.durValve1);
    end
    
    %%%%%%%%% STIMULUS ON LEFT, STATE 2 SCENARIOS %%%%%%%%%
    
    % IF THE FERRET BREAKS THE WRONG BEAM, PLAY A LOW TONE, ONLY FIRST TIME
    if state == 2 && brokenBeams(1) && A.firstTry
        % PLAY LOW TONE
        playTone(15000,P.durTone,.25);
        % TRIAL NOT CORRECT ON FIRST TRY
        A.firstTry = false;
        % NOTE FIRST RESPONSE TIME
        A.firstTime = GetSecs;
        
        % END THE TRIAL NOW IF THE ONE TRY FLAG IS ACTIVE
        if P.oneTry, state = 3; end
    end
    
    % IF FERRET BREAKS THE CORRECT BEAM, REWARD FERRET, PLAY A HIGH TONE
    if state == 2 && brokenBeams(2)
        % TRIAL IS COMPLETE
        state = 3;
        % PLAY HIGH TONE
        playTone(50000,P.durTone,.10);
        % DELIVER REWARD
        dacCheck; giveWater(S.chValve2,P.durValve2);
    end
    
    % NOTE COMPLETION TIME
    if state == 3
        A.finishTime = GetSecs;
        if A.firstTry, A.firstTime = A.finishTime; end
    end
    
    if currentTime > lastFrameTime + frameTimeStep - 0.006
        % Show broken beams 3-red, 4-green, 5-blue  UR[1720 0 1920 200]
        if ~brokenBeams(1)  % RIGHT BEAM
            Screen('FrameRect',A.overlay,4,[1700 50 1780 250]);
        elseif brokenBeams(1)
            Screen('FillRect',A.overlay,4,[1700 50 1780 250]);
        end
        if ~brokenBeams(2)  % LEFT BEAM
            Screen('FrameRect',A.overlay,4,[140 50 220 250]);
        elseif brokenBeams(2)
            Screen('FillRect',A.overlay,4,[140 50 220 250]);
        end
        if ~brokenBeams(3)  % REAR BEAM
            Screen('FrameRect',A.overlay,4,[920 50 1000 250]);
        elseif brokenBeams(3)
            Screen('FillRect',A.overlay,4,[920 50 1000 250]);
        end
        if ledStatus        % RED LED
            Screen('FillOval',A.overlay,3,[930 280 990 340]);
        else
            Screen('FrameOval',A.overlay,3,[930 280 990 340]);
        end
        
        % If trial has started, show stimuli
        switch state
            case 1
                Screen('DrawLines',A.overlay,A.XY.background,P.stimLineWidth,A.lineColor,[960 510]);
                Screen('DrawLines',A.overlay,A.XY.rand2,P.stimLineWidth,A.lineColor,[960 510]);
                Screen('DrawLines',A.overlay,A.XY.form1,P.stimLineWidth,1,[960 510]);
            case 2
                Screen('DrawLines',A.overlay,A.XY.background,P.stimLineWidth,A.lineColor,[960 510]);
                Screen('DrawLines',A.overlay,A.XY.rand1,P.stimLineWidth,A.lineColor,[960 510]);
                Screen('DrawLines',A.overlay,A.XY.form2,P.stimLineWidth,1,[960 510]);
        end
        
        lastFrameTime = Screen('Flip',A.window,GetSecs);
        
        % Reset display for next cycle
        Screen('FillRect',A.overlay,0);
        Screen('FillRect',A.window,S.background);
        
        % Pause and update handles
        pause(.001); handles = guidata(hObject);
    end
end

if ~handles.abortTask
    % LEAVE STIMULUS ON FOR THE TONE DURATION
    WaitSecs(P.durTone);
    WaitSecs(.5);   % INTER TRIAL INTERVAL, MAKE THIS A PARAMETER
end

% CLEAR SCREEN
Screen('Flip',A.window);

% ENSURE DAC SCHEDULES HAVE ALL FINISHED
dacCheck;
% TURN OFF LED IF TRIAL IS ABORTED
if handles.abortTask
    switchLED(S.chLED,0);
end
end

% PLAY TONE
function playTone(freq,durTone,dB)
Datapixx('SetAudioVolume',[0.00 dB; 0.00 dB]);
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
