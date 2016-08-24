function [A handles] = HeadFixRun(S,P,A,hObject)

% function [A handles] = HeadFixRun(S,P,A,hObject)
%
% This function runs a trial of the task. The whole function runs as a
% WHILE loop, checking for changes in data input (RESPONSEPixx in this
% case). When certain conditions are met, state variables are updated.
%
% Created by: Sam Nummela       Last modified: 070414


%%%%% Initialize trial %%%%%
Screen('FillRect',A.overlay,0);
Screen('FillRect',A.window,0.5);
lastFrameTime = Screen('Flip',A.window,GetSecs);
frameTimeStep = 1/A.frameRate;          % time between frame flips
% Get task start time
Datapixx('RegWrRd');
A.startTime = GetSecs;                  % time of trial start
A.startTimeDP = Datapixx('GetTime');    % datapixx time of trial start
% State starts at 0
state = 0;
tex = ceil(2*rand); % texture is randomized, this is the phase of the grating
showStim = 1;       % showStim is a proxy for states 0 and 1, indicating the stimulus should be shown
% Make counters for beam breaks
A.RBBs = 0; % Beam breaks during reward period
A.WBBs = 0; % Beam breaks during wait period
cbs = 0;    % current beam status --    
% LED off
dacCheck; ledStatus = switchLED(S.chLED,0);
% Update handles
pause(.001); handles = guidata(hObject);

%%%%% Start trial loop %%%%%
while state < 4 && ~handles.abortTask
    
    % GET STATUS OF IR BEAMS
    brokenBeams = getBeamStatus([S.chBeam1 S.chBeam2 S.chBeam3 S.chBeam4]);
    
    % GET BUTTONS PRESSED
    buttonPressed = getButtonStatus;
    
    % GET CURRENT TIME
    currentTime = GetSecs;
    
    if P.useBeam
        % IF BEAM IS BROKEN AND STATE IS 0
        if state == 0 && brokenBeams(4)
            revertTime = currentTime + P.durIRI;
            dacCheck; giveWater(S.chValve3,P.durValve3);
            state = 1;
        end
        
        % REVERT TO STATE 0, IF INTER REWARD INTERVAL IS UP
        if state == 1 && revertTime < currentTime && ~brokenBeams(4)
            state = 0;
        end
        
        % IF ANIMAL IS RESPONDING DURING WAIT TIME, ADD PUNISHMENT TO
        % THAT TIME -- ANIMAL IS ONLY PUNISHED UP TO ONCE EVERY 100 ms
        if state == 2 && brokenBeams(4)
            blankTime = blankTime + P.durPunish;        % Add punishment for response with no stim
            A.totalWait = A.totalWait + P.durPunish;    % Add to total wait time if punished
            state = 3;
            revertTime = currentTime + 0.1;             % Punish max every 100 ms
        end
        
        % REVERT TO STATE 2, WAITING
        if state == 3 && revertTime < currentTime
            state = 2;
        end
        
        % BEAM BREAK COUNTER IS HERE
        if cbs == 0 && brokenBeams(4)   % Beam was open, now is broken
            cbs = 1;    % Beam is broken
            if state == 0 || state == 1
                A.RBBs = A.RBBs + 1;    % Reward beam break in state 0 or 1
            elseif state == 2 || state == 3
                A.WBBs = A.WBBs + 1;    % Wait beam break in state 2 or 3
            end
        end
        % ONCE BEAM IS OPEN AGAIN, SET CURRENT BEAM STATUS TO OPEN
        if cbs == 1 && ~brokenBeams(4)  % Beam was broken, now is open
            cbs = 0;
        end
    else  % IF UNDER MANUAL CONTROL
        if state == 0 && buttonPressed
            revertTime = currentTime + P.durIRI;
            dacCheck; giveWater(S.chValve3,P.durValve3);
            state = 1;
        end
        
        % REVERT TO STATE 0, IF INTER REWARD INTERVAL IS UP
        if state == 1 && revertTime < currentTime && ~buttonPressed
            state = 0;
        end
    end 
    
    % PROCEED TO STATE 2, WAITING, ONCE STIMULUS TIME IS UP
    if state < 2 && currentTime > A.startTime + P.durStim
        state = 2;
        showStim = 0;
        blankTime = currentTime + P.durWait;
        A.totalStim = P.durStim;        % Grab total stimulus time
        A.totalWait = P.durWait;        % Grab total wait time
    end
    
    % PROCEED TO STATE 4, END TRIAL, ONCE WAITING TIME IS UP
    if state == 2 || state == 3
        if currentTime > blankTime
            state = 4;
        end
    end
    
    if currentTime > lastFrameTime + frameTimeStep - 0.006
        % ALWAYS DRAW (3 red, 4 green, 5 blue) UR [1720 0 1920 200]
        drawBeams(brokenBeams,A.overlay,ledStatus);
        
        % DRAW STIMULUS IF IN REWARD EPOCH
        if showStim
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

% ENSURE DAC SCHEDULES HAVE ALL FINISHED
dacCheck;

% FLIP THE FRAME
Screen('Flip',A.window);
        
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

function buttonPressed = getButtonStatus()

% Check if any buttons are pressed
% If any button is pressed, the BITAND will return something other than
% hex2dec('FFFF'). More detailed reasoning is included in my explanation
% for using digital input and output with the RESPONSEPixx device
% (SamButtonRun.m)

Datapixx('RegWrRd');
buttonPressed = bitand(Datapixx('GetDinValues'),hex2dec('FFFF')) ~= hex2dec('FFFF');

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