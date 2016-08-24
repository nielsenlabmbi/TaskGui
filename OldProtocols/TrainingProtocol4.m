function TrainingProtocol

% This function runs and exploration protocol, having all stimuli present
% while the ferret explores the environment

% GET PROTOCOL SETTINGS
c = ExploreSettings;

% Create an output
A = struct;
filename = 'data.mat';

% Prepare the PTB
Screen('CloseAll');
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','FloatingPoint32BitIfPossible');
PsychImaging('AddTask','General','EnableDataPixxM16OutputWithOverlay');
PsychImaging('AddTask','FinalFormatting','DisplayColorCorrection','SimpleGamma');
[c.window c.screenRect] = PsychImaging('OpenWindow',c.screenNumber,c.background);
c.frameRate = FrameRate(c.window);
c.overlay = PsychImaging('GetOverlayWindow',c.window);
Screen('LoadNormalizedGammaTable',c.window,c.combinedCLUT,2);
% c.window2 = Screen('OpenWindow',0);   % For PTB control of both screens
c.priorityLevel = MaxPriority(c.window);

% Prepare the VIEWPixx
if ~Datapixx('isReady'), Datapixx('Open'); pause(.1); end
Datapixx('StopAllSchedules');
Datapixx('EnableVideoScanningBacklight');
Datapixx('EnableAdcFreeRunning');
Datapixx('InitAudio');
Datapixx('WriteAudioBuffer',sin(2*pi*(1:64)/64));
Datapixx('RegWrRd');

% Initialize environment
dacCheck;
Datapixx('WriteDacBuffer',10,0,c.chLED);
Datapixx('SetDacSchedule',0,1000,1,c.chLED,0,1);
Datapixx('StartDacSchedule'); Datapixx('RegWrRd');      % TURN ON RED LED
Screen('FillRect',c.overlay,0);
Screen('FillRect',c.window,c.background);
Screen('Flip',c.window,GetSecs+0.00);
run = 1;        % RUN ENVIRONMET
state = 0;      % State is 0, LED on, no stimuli

% Init data out
A.numBack = 0;

while run
    
    brokenBeams = getBeamStatus([c.chBeam1 c.chBeam2 c.chBeam3]);
    
    if brokenBeams(3)
        
        A.numBack = A.numBack+1;
        
        % TURN OFF LED
        Datapixx('WriteDacBuffer',0,0,c.chLED);
        Datapixx('SetDacSchedule',0,1000,1,c.chLED,0,1);
        Datapixx('StartDacSchedule'); Datapixx('RegWrRd');
        
        % DELIVER REWARD
        vdur = c.durValve3; vch = c.chValve3;
        dacWave = [zeros(1,5) repmat(10,1,1000*vdur) zeros(1,5)];
        Datapixx('WriteDacBuffer',dacWave,0,vch);
        Datapixx('SetDacSchedule',0,1000,length(dacWave),vch,0,length(dacWave));
        Datapixx('StartDacSchedule'); Datapixx('RegWrRd');
        
        % WAIT 1 SECOND UNTIL NEXT REWARD
        pause(3);
        
        Datapixx('WriteDacBuffer',10,0,c.chLED);
        Datapixx('SetDacSchedule',0,1000,1,c.chLED,0,1);
        Datapixx('StartDacSchedule'); Datapixx('RegWrRd');      % TURN ON RED LED
        Screen('FillRect',c.overlay,0);
    end
    
    pause(.001);
end
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


% CONDITIONS
function c = ExploreSettings
% GET VALUES FOR TASK

c.background = [0.3 0.3 0.3];
% COLORS FOR THE TASK CONTROLLER'S DISPLAY
controlsColors = [ 0      0      0      ;   % 0 first row does not count
                   1      1      1      ;   % 1 white
                   0.5    0.5    0.5    ;   % 2 gray
                   1      0      0      ;   % 3 red
                   0      1      0      ;   % 4 green
                   0      0      1      ;   % 5 blue
                   1      1      1      ];  % 6 white
c.controlsCLUT = [controlsColors; zeros(256-size(controlsColors,1),3)];
% COLORS FOR THE SUBJECT'S DISPLAY
subjectColors =  [ 0      0      0      ;   % 0 first row does not count
                   1      1      1      ;   % 1 white
                   0.5    0.5    0.5    ;   % 2 gray
                   c.background         ;   % 3 background
                   c.background         ;   % 4 background
                   c.background         ;   % 5 background
                   c.background         ];   % 6 background
c.subjectCLUT = [subjectColors; zeros(256-size(subjectColors,1),3)];
% A COMBINED COLOR LOOK UP TABLE (CLUT) FOR THE VPIXX 2-CLUT SYSTEM
c.combinedCLUT = [c.subjectCLUT; c.controlsCLUT];

% DISPLAY/RIG SETTINGS
c.screenNumber = 1;                 % Designates the display for task stimuli
c.screenWidth = 52;                 % Width of screen (cm)
c.halfDistance = 50;                % Half distance from back of box to screen (cm)
c.chPhotodiode = 0;                 % ADC channel for the photodiode
c.chBeam1 = 2;                      % ADC channel for IR Beam 1 (right of display)
c.chBeam2 = 4;                      % ADC channel for IR Beam 2 (left of display)
c.chBeam3 = 6;                      % ADC channel for IR Beam 3 (back of box)
c.chLED = 0;                        % DAC channel for LED at back
c.chValve1 = 1;                     % DAC channel for Solenoid Valve 1 (to IR Beam 1)
c.chValve2 = 2;                     % DAC channel for Solenoid Valve 2 (to IR Beam 2)
c.chValve3 = 3;                     % DAC channel for Solenoid Valve 3 (to IR Beam 3)
c.durValve1 = 0.35;                 % Reward duration for valve 1 (s)
c.durValve2 = 0.35;                 % Reward duration for valve 2 (s)
c.durValve3 = 0.3;                  % Reward duration for valve 3 (s)
                  % Form center options (vertl, pixels)
% Timing
c.durWait = 1;                      % 1 second wait between rewards
end