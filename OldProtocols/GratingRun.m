function [A handles] = GratingRun(S,P,A,hObject)

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
% Created by: Sam Nummela       Last modified: 300513


%%%%% Initialize trial %%%%%
% Blank screen
Screen('FillRect',A.window,P.bkgd);
lastFrameTime = Screen('Flip',A.window,GetSecs);
frameTimeStep = 1/A.frameRate;          % time between frame flips
% State starts at 0
state = 0;
% Frame starts at 1
frame = 1;
% Video has not been started
videoStart = 0;
% LED off
dacCheck; switchLED(S.chLED1,0);
dacCheck; switchLED(S.chLED2,0);
% Update handles
pause(.001); handles = guidata(hObject);

% Making this communications variable global so I can use it
global DcomState
% REMOVING THIS MESSAGE, I THINK IF IT IS SENT BEFORE VIDEO ACQUISITION HAS
% FINISHED IT MESSES UP THE VIDEO CAPTURE
% % Send message that stimulus is read
% cmd = 'Stimulus is ready.~';
% fwrite(DcomState.serialPortHandle,cmd);
% pause(0.001);

%%%%% Start trial loop %%%%%
while state < 3 && ~handles.abortTask
    
    % GET CURRENT TIME
    currentTime = GetSecs;
    
    % START VIDEO ACQUISTION EARLY
    if currentTime > A.startTime + P.delayDur - 1.5;
        if ~videoStart
            % At this point, stimulus will start, start the webcam
        	cmd = strcat('trial',num2str(A.j),'.avi~');
            fwrite(DcomState.serialPortHandle,cmd);
            videoStart = 1;
            pause(0.001);
        end
    end
    
    if currentTime > A.startTime + P.delayDur && state == 0
        state = 1;
        % Turn ON the start LED
        dacCheck; switchLED(S.chLED1,10);
    end
    
    if currentTime > A.startTime + P.delayDur + P.stimDur && state == 1
        state = 2;
        % Turn ON the ending LED
        dacCheck; switchLED(S.chLED2,10);
        % Turn OFF the start LED
        dacCheck; switchLED(S.chLED1,0);
    end
    
    if currentTime > A.startTime + P.delayDur + P.stimDur + P.iti && state == 2
        state = 3;
        % Turn OFF the ending LED
        dacCheck; switchLED(S.chLED2,0);
    end
    
    
    if currentTime > lastFrameTime + frameTimeStep - 0.006
        
        % ONLY UPDATE GRATING IF STATE IS 0
        switch state
            case 1
                Screen('FillRect',A.window,P.bkgd);
                switch A.stimSide
                    case 1
                        Screen('DrawTexture',A.window,A.gratTex(frame),[],[869 249 1370 750],P.angle);
                        Screen('DrawTexture',A.window,A.maskTex,[],[869 249 1370 750],P.angle);
                    case 2
                        Screen('DrawTexture',A.window,A.gratTex(frame),[],[69 249 570 750],P.angle);
                        Screen('DrawTexture',A.window,A.maskTex,[],[69 249 570 750],P.angle);
                end
                
                if frame < length(A.gratTex)
                    frame = frame+1;
                end
                
            otherwise
                % JUST DRAW A GRAY RECTANGLE IF STIMULUS IS OVER
                Screen('FillRect',A.window,P.bkgd);
        end
        
        lastFrameTime = Screen('Flip',A.window,GetSecs);
        
        % Pause and update handles
        pause(.001); handles = guidata(hObject);
    end
end

% CLEAR SCREEN
Screen('FillRect',A.window,P.bkgd);
Screen('Flip',A.window);

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
