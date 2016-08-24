function [A handles] = OriRun(S,P,A,hObject)

% function A = OriRun(S,P,A)
%
% This function runs a trial of the task. The whole function runs as a
% WHILE loop, checking for changes in data input (RESPONSEPixx in this
% case). When certain conditions are met, state variables are updated.
%
% Created by: Sam Nummela       Last modified: 300913


%%%%% Initialize trial %%%%%
% Blank screen
Screen('FillRect',A.overlay,0);
Screen('FillRect',A.window,.5);
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
% Control of stimulus by midpoint
showStim = 0;
midTime = 0;
% Assume animal will be correct
A.correct = 1;
% texture to use
tex = 1+round(rand);
% frame counter
frameI = 0;
% Update handles
pause(.001); handles = guidata(hObject);

%%%%% Start trial loop %%%%%
while state < 5 && ~handles.abortTask
    
    % GET STATUS OF IR BEAMS
    brokenBeams = getBeamStatus([S.chBeam1 S.chBeam2 S.chBeam3 S.chBeam4]);
        
    % GET CURRENT TIME
    currentTime = GetSecs;
   
    if state == 0 && brokenBeams(3)
        % TRIAL IS INITIATED, UPDATE STATE
        state = A.side;
        showStim = 1;
        % TURN OFF LED
        dacCheck; ledStatus = switchLED(S.chLED,0);
        % DELIVER INITIATION REWARD
        dacCheck; giveWater(S.chValve3,P.durValve3);
        % SET CHOICE TIME, TIME FROM WHICH THE STIMULI APPEAR
        A.choiceTime = GetSecs;
    end
    
    % CONTROL STIMULUS PRESENTATION WITH MIDWAY BEAM
    if P.durStim >= 0   % I CAN LEAVE STIMULI ON BY MAKING durStim NEGATIVE
    if state == 1 || state == 2
        if brokenBeams(4) && ~midTime
            midTime = GetSecs;
        end
        if midTime
            if currentTime > midTime + P.durStim
                showStim = 0;
            end
        end
    end
    end
    
    %%%%%%%%% STIMULUS ON RIGHT, STATE 1 SCENARIOS %%%%%%%%%
    
    % IF THE FERRET BREAKS THE WRONG BEAM, PLAY A LOW TONE, ONLY FIRST TIME
    if state == 1 && brokenBeams(2) && A.correct
        % NOTE RESPONSE TIME
        A.responseTime = GetSecs;
        % TRIAL NOT CORRECT
        A.correct = 0;
        % START A LOW TONE
        playTone(15000,P.durTone,.60);
        if ~P.forceCorrect
            % END THE TRIAL
            state = 3;
            showStim = 1;
        end
    end
    
    % IF FERRET BREAKS THE CORRECT BEAM, REWARD FERRET, PLAY A HIGH TONE
    if state == 1 && brokenBeams(1)
        if A.correct
            % NOTE RESPONSE TIME
            A.responseTime = GetSecs;
            % PLAY HIGH TONE
            playTone(50000,P.durTone,.12);
            % DELIVER REWARD
            dacCheck;
            giveWater(S.chValve1,P.durValve1);
        end
        if P.alwaysWater && ~A.correct
            % DELIVER REWARD
            dacCheck;
            giveWater(S.chValve1,round(P.alwaysWater*P.durValve1));
        end
        % TRIAL IS COMPLETE
        state = 3;
        showStim = 1;
    end
    
    %%%%%%%%% STIMULUS ON LEFT, STATE 2 SCENARIOS %%%%%%%%%
    
    % IF THE FERRET BREAKS THE WRONG BEAM, PLAY A LOW TONE, ONLY FIRST TIME
    if state == 2 && brokenBeams(1) && A.correct
        % NOTE RESPONSE TIME
        A.responseTime = GetSecs;
        % TRIAL NOT CORRECT
        A.correct = 0;
        % START A LOW TONE
        playTone(15000,P.durTone,.60);
        if ~P.forceCorrect
            % END THE TRIAL
            state = 3;
            showStim = 1;
        end
    end
    
    % IF FERRET BREAKS THE CORRECT BEAM, REWARD FERRET, PLAY A HIGH TONE
    if state == 2 && brokenBeams(2)
        if A.correct
            % NOTE RESPONSE TIME
            A.responseTime = GetSecs;
            % PLAY HIGH TONE
            playTone(50000,P.durTone,.12);
            % DELIVER REWARD
            dacCheck;
            giveWater(S.chValve2,P.durValve2);
        end
        if P.alwaysWater && ~A.correct
            % DELIVER REWARD
            dacCheck;
            giveWater(S.chValve2,round(P.alwaysWater*P.durValve2));
        end
        % TRIAL IS COMPLETE
        state = 3;
        showStim = 1;
    end
    
    % FIND OUT WHEN FEEDBACK IS OVER
    if state == 3
        if currentTime > A.responseTime + P.durTone
            state = 4;
            showStim = 0;
        end
    end
    
    % FIND OUT WHEN TO END TRIAL
    if state == 4 
        if currentTime > A.responseTime + P.durTone + P.durITI
            state = 5;
        end
    end
    
    if currentTime > lastFrameTime + frameTimeStep - 0.006
        % ALWAYS DRAW (3 red, 4 green, 5 blue) UR [1720 0 1920 200]
        drawBeams(brokenBeams,A.overlay,ledStatus)
        
        % DRAW STIMULUS IF showStim IS ON
        if showStim
            % These commands counterphase the stimulus
            if P.counterPhase > 0
            frameI = mod(frameI+1,30);
            if ~frameI
                switch tex
                    case 1
                        tex = 2;
                    case 2
                        tex = 1;
                end
            end
            end
            % Draw the texture
            Screen('DrawTexture',A.window,A.gratTex(tex),[],A.gratPos,A.angle);
        end
        
        % FLIP THE FRAME
        lastFrameTime = Screen('Flip',A.window,GetSecs);
        
        % Reset display for next cycle
        Screen('FillRect',A.overlay,0);
        Screen('FillRect',A.window,0.5);
        
        % Pause and update handles
        pause(.001); handles = guidata(hObject);
    end
        
end

if P.runType == 3
if A.correct
    A.ranges(S.cpds == A.cpd) = A.ranges(S.cpds == A.cpd) - 1;
else
    A.ranges(S.cpds == A.cpd) = A.ranges(S.cpds == A.cpd) + 2;
end
end

% Note initial phase
A.phase = tex;
    
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
Datapixx('StopAudioSchedule');
Datapixx('SetAudioVolume',[0.00 dB; 0.00 dB]); Datapixx('RegWrRd');
nSamples = ceil(freq*durTone);
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

% DRAW BEAM STATUS
function drawBeams(brokenBeams,win,ledStatus)
if ~brokenBeams(1)  % RIGHT BEAM
    Screen('FrameRect',win,4,[1700 50 1780 130]);
elseif brokenBeams(1)
    Screen('FillRect',win,4,[1700 50 1780 130]);
end
if ~brokenBeams(2)  % LEFT BEAM
    Screen('FrameRect',win,4,[140 50 220 130]);
elseif brokenBeams(2)
    Screen('FillRect',win,4,[140 50 220 130]);
end
if ~brokenBeams(3)  % REAR BEAM
    Screen('FrameRect',win,4,[1450 50 1530 130]);
elseif brokenBeams(3)
    Screen('FillRect',win,4,[1450 50 1530 130]);
end
if ~brokenBeams(4)  % MIDWAY BEAM
    Screen('FrameRect',win,5,[320 50 400 130]);
elseif brokenBeams(4)
    Screen('FillRect',win,5,[320 50 400 130]);
end
if nargin == 3
    if ledStatus        % RED LED
        Screen('FillOval',win,3,[1540 60 1600 120]);
    else
        Screen('FrameOval',win,3,[1540 60 1600 120]);
    end
end
end