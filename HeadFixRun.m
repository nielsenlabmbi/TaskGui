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
showStim = 0;       % showStim is a proxy for states 0 and 1, indicating the stimulus should be shown

% LED off
dacCheck; ledStatus = switchLED(S.chLED,0);
% Update handles
pause(.001); handles = guidata(hObject);

%%%%% Start trial loop %%%%%
while state < 3 && ~handles.abortTask
    
    % GET STATUS OF IR BEAMS
    brokenBeams = getBeamStatus([S.chBeam1 S.chBeam2 S.chBeam3 S.chBeam4]);
    
    
    % GET CURRENT TIME
    currentTime = GetSecs;
    
    %START OF TRIAL - MAKE SURE THAT LEVER HAS NOT ALREADY BEEN PULLED
    if state == 0 && ~brokenBeams(4)
       state = 1;
       showStim=1;
        
    end
    
    
    % IF BEAM IS BROKEN AND STIMULUS IS ON
    if state == 1 && brokenBeams(4)
        %NOTE RESPONSE TIME
        A.responseTime = GetSecs;
        % PLAY HIGH TONE
        playTone(50000,P.durTone,.14);
        %GIVE REWARD
        dacCheck; giveWater(S.chValve3,P.durValve3);
        %TRIAL IS COMPLETE
        state = 2;
        %TURN STIMULUS OFF
        showStim=0;
    end
    
    
     % FIND OUT WHEN TO END TRIAL
    if state == 2 
        if currentTime > A.responseTime + P.durValve3/1000 + P.durITI
            state = 3;
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