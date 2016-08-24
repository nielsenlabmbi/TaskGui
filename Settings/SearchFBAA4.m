function [A S P] = SearchFBAA0

%%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 250;

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'SearchInit';
% "next trial" m-file
S.nextFunc = 'SearchNext';
% "run trial" m-file
S.runFunc = 'SearchRun';
% "finish trial" m-file
S.endFunc = 'SearchFinish';

% Define Banner text to identify the experimental protocol
S.protocolTitle = 'Motion Discrimination Protocol';

% OUTPUT NAMING CONVENTIONS
A.outputPrefix = 'Search';
A.subject = 'FBAA4';

%%%%% END OF NECESSARY VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% SETTINGS -- VARIABLES FOR TASK, NOT TO BE CHANGED WHILE RUNNING %%%%
% INCLUDES HARDWARE VALUES, COLOR ARRAYS, STIMULUS OPTION ARRAYS

% DEFINE THE COLOR LOOK UP TABLES
S.background = [0.5 0.5 0.5].^(1/2.2); % 2.2 GAMMA CORRECTION NEEDED FOR THE OVERLAY WINDOW
% COLORS FOR THE TASK CONTROLLER'S DISPLAY
S.controlsColors = [
0      0      0      ;  % 0 first row does not count
1      1      1      ;  % 1 white
0.5    0.5    0.5    ;  % 2 gray
1      0      0      ;  % 3 red
0      1      0      ;  % 4 green
0      0      1      ;  % 5 blue
1      1      1      ]; % 6 white


% COLORS FOR THE SUBJECT'S DISPLAY
S.subjectColors = [
0      0      0      ;  % 0 first row does not count
1      1      1      ;  % 1 white
0.5    0.5    0.5    ;  % 2 gray
S.background         ;  % 3 background
S.background         ;  % 4 background
S.background         ;  % 5 background
S.background         ]; % 6 background

% DISPLAY/RIG SETTINGS -- THESE SHOULD NOT BE VALUES THAT CHANGE
S.screenNumber = 1;                 % Designates the display for task stimuli
S.frameRate = 120;                  % Frame rate of screen in Hz
S.screenRect = [0 0 1920 1080];     % Screen dimensions in pixels
S.screenWidth = 52;                 % Width of screen (cm)
S.screenDistance = 75;              % Distance of ferret from screen (cm)
S.chPhotodiode = 0;                 % ADC channel for the photodiode
S.photodiode = 0;                   % boolean for photodiode use
S.chBeam1 = 2;                      % ADC channel for IR Beam 1 (right of display)
S.chBeam2 = 4;                      % ADC channel for IR Beam 2 (left of display)
S.chBeam3 = 6;                      % ADC channel for IR Beam 3 (back of box)
S.chBeam4 = 8;                      % ADC channel for IR Beam 4 (midway)
S.chLED = 0;                        % DAC channel for LED
S.chValve1 = 1;                     % DAC channel for Solenoid Valve 1 (to IR Beam 1)
S.chValve2 = 2;                     % DAC channel for Solenoid Valve 2 (to IR Beam 2)
S.chValve3 = 3;                     % DAC channel for Solenoid Valve 3 (to IR Beam 3)

%%%%% PARAMETERS -- VARIABLES FOR TASK, CAN CHANGE WHILE RUNNING %%%%%%%%%
% INCLUDES STIMULUS PARAMETERS, DURATIONS, FLAGS FOR TASK OPTIONS
% MUST BE SINGLE VALUE, NUMERIC -- NO STRINGS OR ARRAYS!
% THEY ALSO MUST INCLUDE DESCRIPTION OF THE VALUE IN THE SETTINGS ARRAY

% Stimulus settings
P.contrast=100;
S.contrast = 'Contrast of distractors (%):';
P.nrDist=1;
S.nrDist = 'Nr distractors:';
P.area=10;
S.area = 'Stimulus area (deg2):';
P.protectZone=400;
S.protectZone = 'Minimal distance of target from midline (px):';
P.stimType=1;
S.stimType = 'Dist rand/opposite target';  % Whether the distractor (singular) is opposite to the target or randomly placed

% Timing variables
P.durValve1 = 300;                                          % Reward duration for valve 1 (ms)
S.durValve1 = 'Duration of right valve (ms):';
P.durValve2 = 300;                                          % Reward duration for valve 2 (ms)
S.durValve2 = 'Duration of left valve (ms):';
P.durValve3 = 40;                                           % Reward duration for valve 3 (ms)
S.durValve3 = 'Duration of back valve (ms):';
P.durTone = 1;                                              % audio feedback (s)
S.durTone = 'Duration of feedback tone (s):';
P.durITI = 1.6;
S.durITI = 'Intertrial interval (s):';
P.durStim = -1;
S.durStim = 'Duration of stimulus from midpoint (s):';

% Trial control
P.forceCorrect = 1;
S.forceCorrect = 'Force correct response?';
P.alwaysWater = 0.2;
S.alwaysWater = 'Water when initially wrong?';
P.runType = 1;
S.runType = '1-list:';

%column 1: target side, column 2: target identity
S.trialsList=[
    1 1;
    2 1
    1 1
    2 1];

