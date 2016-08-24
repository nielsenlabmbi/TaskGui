function [A S P] = OriFBAA6

%%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 250;

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'OriInit';
% "next trial" m-file
S.nextFunc = 'OriNext';
% "run trial" m-file
S.runFunc = 'OriRun';
% "finish trial" m-file
S.endFunc = 'OriFinish';

% Define Banner text to identify the experimental protocol
S.protocolTitle = 'Grating Orientation Discrimination Protocol';

% OUTPUT NAMING CONVENTIONS
A.outputPrefix = 'Ori';
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
P.screenDistance = 75;
S.screenDistance = 'Distance of ferret from screen (cm):';
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
P.cpd = 0.25;
S.cpd = 'Cycles per degree:';
P.angle = 0;
S.angle = 'Angle of grating (degrees):';
P.bkgd = 127;
S.bkgd = 'Choose a grating background color (0-255):';
P.range = 121;
S.range = 'Luminance range of grating (1-127):';
P.side = 1;
S.side = 'Correct side, 1-right, 2-left:';

% Timing variables
P.durValve1 = 500;                                         % Reward duration for valve 1 (ms)
S.durValve1 = 'Duration of right valve (ms):';
P.durValve2 = 500;                                         % Reward duration for valve 2 (ms)
S.durValve2 = 'Duration of left valve (ms):';
P.durValve3 = 100;                                         % Reward duration for valve 3 (ms)
S.durValve3 = 'Duration of back valve (ms):';
P.durTone = 1;                                            % audio feedback (s)
S.durTone = 'Duration of feedback tone (s):';
P.durITI = 3.2;
S.durITI = 'Intertrial interval (s):';
P.durStim = -1;
S.durStim = 'Duration of stimulus from midpoint (s):';

% Trial control
P.forceCorrect = 1;
S.forceCorrect = 'Force correct response?';
P.alwaysWater = 0.5;
S.alwaysWater = 'Water when initially wrong?';
P.runType = 2;
S.runType = '(0-random, 1-list, 2-blocks, 3-stair, 4-angle block, 5-force side):';
P.blockLengthMinRight = 1;
S.blockLengthMinRight = 'Minimum block length, right:';
P.blockLengthMinLeft = 2;
S.blockLengthMinLeft = 'Minimum block length, left:';
P.blockLengthRan = 0;
S.blockLengthRan = 'Maximum added block length:';
P.forceSide = 2;
S.forceSide = 'Force side, 1-right 2-left';
%P.counterPhase = 0;
%S.counterPhase = 'Switch phase every x frames:';


%block list - this is to run individual blocks of angles
S.blockList = [0 45;
0 135];
S.withinList = [
1 121 .25 0;
1 121 .25 180;
2 121 .25 0;
2 121 .25 180];


% Trials list -- Column 1: stim side -- Column 2: angle --
% Column 3: contrast range -- Column 4 -- cycles per degree
% column 5: phase (0 or 180)
S.cpds = [.125 .25 .5];% 1];
S.ranges = [10 2 5];% 120];
S.trialsList = [

1   45   121   .25   0;
1   45   121   .25   0;
1   45   121 .25   0;
1   45   121 .25   0;
1   45   121 .25   0;
2   135  121 .25   0;
2   135  121 .25   0;
2   135  121 .25   0;
2   135  121 .25   0;
2   135  121 .25   0;
1   45   121   .25   180;
1   45   121   .25   180;
1   45   121 .25   180;
1   45   121 .25   180;
1   45   121 .25   180;
2   135  121 .25   180;
2   135  121 .25   180;
2   135  121 .25   180;
2   135  121 .25   180;
2   135  121 .25   180];

