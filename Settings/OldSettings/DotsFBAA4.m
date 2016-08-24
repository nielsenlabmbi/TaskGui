function [A S P] = DotsFBAA4

%%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 250;

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'DotsInit';
% "next trial" m-file
S.nextFunc = 'DotsNext';
% "run trial" m-file
S.runFunc = 'DotsRunTEST';
% "finish trial" m-file
S.endFunc = 'DotsFinishNEW';

% Define Banner text to identify the experimental protocol
S.protocolTitle = 'Coherent Motion Detection';

% OUTPUT NAMING CONVENTIONS
A.outputPrefix = 'Dots';
A.subject = 'FBAA4';

%%%%% END OF NECESSARY VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% SETTINGS -- VARIABLES FOR TASK, NOT TO BE CHANGED WHILE RUNNING %%%%
% INCLUDES HARDWARE VALUES, COLOR ARRAYS, STIMULUS OPTION ARRAYS

% DEFINE THE COLOR LOOK UP TABLES
S.background = [0.005 0.005 0.005].^(1/2.2); % 2.2 GAMMA CORRECTION NEEDED FOR THE OVERLAY WINDOW
% COLORS FOR THE TASK CONTROLLER'S DISPLAY
S.controlsColors = [
0      0      0      ;  % 0 first row does not count
1      1      1      ;  % 1 white
S.background         ;  % 2 background
1      0      0      ;  % 3 red
0      1      0      ;  % 4 green
0      0      1      ;  % 5 blue
1      1      1      ]; % 6 white


% COLORS FOR THE SUBJECT'S DISPLAY
S.subjectColors = [
0      0      0      ;  % 0 first row does not count
1      1      1      ;  % 1 white
S.background         ;  % 2 gray
S.background         ;  % 3 background
S.background         ;  % 4 background
S.background         ;  % 5 background
S.background         ]; % 6 background

% DISPLAY/RIG SETTINGS -- THESE SHOULD NOT BE VALUES THAT CHANGE
S.screenNumber = 1;                 % Designates the display for task stimuli
S.frameRate = 120;                  % Frame rate of screen in Hz
S.screenRect = [0 0 1920 1080];     % Screen dimensions in pixels
S.screenWidth = 52;                 % Width of screen (cm)
P.screenDistance = 50;
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
P.side = 1;
S.side = 'Rewarded side, 1-right, 2-left:';
P.coh = 1.0;
S.coh = 'Motion coherence:';
P.dir = 0;
S.dir = 'Angle of motion (degrees):';
P.bkgd = 12;
S.bkgd = 'Choose a stimulus background color (0-255):';
P.windowSize = 800;
S.windowSize = 'Size of stimulus window in pixels:';
P.randStart = 0;
S.randStart = 'Randomize starting position (1-yes, 0-no):';
P.dotSpeed = 4;
S.dotSpeed = 'Speed of dot in pixels per frame:';

% Timing variables
P.durValve1 = 260;                                       % Reward duration for valve 1 (ms)
S.durValve1 = 'Duration of right valve (ms):';
P.durValve2 = 260;                                       % Reward duration for valve 2 (ms)
S.durValve2 = 'Duration of left valve (ms):';
P.durValve3 = 50;                                        % Reward duration for valve 3 (ms)
S.durValve3 = 'Duration of back valve (ms):';
P.durTone = 1;                                           % audio feedback (s)
S.durTone = 'Duration of feedback tone (s):';
P.durITI = 3.0;
S.durITI = 'Intertrial interval (s):';
P.durTO = 0;
S.durTO = 'Timeout duration (s):';
P.durStim = 10;
S.durStim = 'Duration that stimulus is displayed (s):';

% Trial control
P.forceCorrect = 1;
S.forceCorrect = 'Force correct response?';
P.alwaysWater = 0.2;
S.alwaysWater = 'Water when initially wrong?';
P.runType = 0;
S.runType = '(0-random, 1-list, 2-blocks, 3-list+repeat):';
P.blockLengthMin = 1;
S.blockLengthMin = 'Minimum block length:';
P.blockLengthRan = 3;
S.blockLengthRan = 'Maximum added block length:';

% Trials list -- Column 1: reward side -- Column 2: direction of motion --
% Column 3: motion coherence 
S.trialsList = [
1   0   1.0;
2   90  1.0;
1   0   1.0;
2   90  1.0;
1   0   1.0;
2   90  1.0;
1   0   1.0;
2   90  1.0];