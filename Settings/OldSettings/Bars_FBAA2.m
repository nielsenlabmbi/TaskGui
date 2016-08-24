function [A S P] = Bars_FBAA2

%%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 250;

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'BarsInit';
% "next trial" m-file
S.nextFunc = 'BarsNext';
% "run trial" m-file
S.runFunc = 'BarsRun';
% "finish trial" m-file
S.endFunc = 'BarsFinish';

% Define Banner text to identify the experimental protocol
S.protocolTitle = 'Bar Orientation Discrimination Protocol';

% OUTPUT NAMING CONVENTIONS
A.outputPrefix = 'Bars';
A.subject = 'FBAA2';

%%%%% END OF NECESSARY VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% SETTINGS -- VARIABLES FOR TASK, NOT TO BE CHANGED WHILE RUNNING %%%%
% INCLUDES HARDWARE VALUES, COLOR ARRAYS, STIMULUS OPTION ARRAYS

% DEFINE THE COLOR LOOK UP TABLES
S.background = [0.03 0.03 0.03];
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
S.background.^(1/2.2);  % 3 background -- THE ADJUSTMENT IS FOR GAMMA CORRECTION!
S.background.^(1/2.2);  % 4 background
S.background.^(1/2.2);  % 5 background
S.background.^(1/2.2)]; % 6 background

% DISPLAY/RIG SETTINGS -- THESE SHOULD NOT BE VALUES THAT CHANGE
S.screenNumber = 1;                 % Designates the display for task stimuli
S.frameRate = 120;                  % Frame rate of screen in Hz
S.screenRect = [0 0 1920 1080];     % Screen dimensions in pixels
S.screenWidth = 52;                 % Width of screen (cm)
S.halfDistance = 50;                % Half distance from back of box to screen (cm)
S.chPhotodiode = 0;                 % ADC channel for the photodiode
S.photodiode = 0;                   % boolean for photodiode use
S.chBeam1 = 2;                      % ADC channel for IR Beam 1 (right of display)
S.chBeam2 = 4;                      % ADC channel for IR Beam 2 (left of display)
S.chBeam3 = 6;                      % ADC channel for IR Beam 3 (back of box)
S.chLED = 0;                        % DAC channel for LED at back
S.chValve1 = 1;                     % DAC channel for Solenoid Valve 1 (to IR Beam 1)
S.chValve2 = 2;                     % DAC channel for Solenoid Valve 2 (to IR Beam 2)
S.chValve3 = 3;                     % DAC channel for Solenoid Valve 3 (to IR Beam 3)

%%%%% PARAMETERS -- VARIABLES FOR TASK, CAN CHANGE WHILE RUNNING %%%%%%%%%
% INCLUDES STIMULUS PARAMETERS, DURATIONS, FLAGS FOR TASK OPTIONS
% MUST BE SINGLE VALUE, NUMERIC -- NO STRINGS OR ARRAYS!
% THEY ALSO MUST INCLUDE DESCRIPTION OF THE VALUE IN THE SETTINGS ARRAY

% Stimulus Variables
P.lineLength = 278;                                       % Line segment length (pixels)
S.lineLength = 'Stimulus Line Lengths (pixels):';
P.lineWidth = 36;                                         % Line segment width (pixels)
S.lineWidth = 'Stimulus Line Widths (pixels):';
P.lineColor = 8;                                          % color value for non-form line segments
S.lineColor = 'Color for background lines (0-255):';
S.stimRadius = 'Radius of coherent form (pixels):';
P.stimTheta = 0;
S.stimTheta = 'Stimulus angle (degrees):';
P.distTheta = 90;
S.distTheta = 'Distracter angles (degrees):';

% Timing variables
P.durValve1 = 140;                                        % Reward duration for valve 1 (ms)
S.durValve1 = 'Duration of right valve (ms):';
P.durValve2 = 140;                                        % Reward duration for valve 2 (ms)
S.durValve2 = 'Duration of left valve (ms):';
P.durValve3 = 80;                                         % Reward duration for valve 3 (ms)
S.durValve3 = 'Duration of back valve (ms):';
P.durTone = 1;                                            % audio feedback (s)
S.durTone = 'Duration of feedback tone (s):';
P.durTimeOut = 8;                                         % time out if not on first try
S.durTimeOut = 'Duration of time outs (s):';
P.durITI = 2;
S.durITI = 'Intertrial interval (s):';

% For blocking trials
P.runType = 3;                                            % Flag to use blocks
S.runType = '(0-random, 1-list, 2-blocks, 3-list+repeat):';
P.blockLengthMin = 5;                                     % Block length minimum
S.blockLengthMin = 'Minimum block length:';
P.blockLengthRan = 5;                                     % Random additional block length
S.blockLengthRan = 'Maximum added block length:';
P.repeatLength = 3;
S.repeatLength = 'Nr repeat until correct: ';              % Nr of repeats until next trial after 
% after incorrect



% Trial control flag, 0-next trial when correct, 1-next trial after 1st try
P.oneTry = 0;
S.oneTry = '0-Force correct, 1-Next trial after 1st response:';

% Trials list -- Column 1: stim side -- Column 2: distracter line color --
% Column 3: Distracter orientations -- Column 4: Stimulus orientation
S.trialsList = [
1   8   90  0;
2   8   90  0;
1   8   90  0;
2   8   90  0;
1   8   90  0;
2   8   90  0;
1   8   90  0;
2   8   90  0;
1   8   90  0;
2   8   90  0;
1   8   90  0;
2   8   90  0;
1   8   90  0;
2   8   90  0;
1   8   90  0;
2   8   90  0;
1   16   90  0;
2   16   90  0;
1   16   90  0;
2   16   90  0];
