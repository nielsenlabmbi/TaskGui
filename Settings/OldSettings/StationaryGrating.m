function [A S P] = StationaryGrating

%%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 60;

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'GratingInit';
% "next trial" m-file
S.nextFunc = 'GratingNext';
% "run trial" m-file
S.runFunc = 'GratingRun';
% "finish trial" m-file
S.endFunc = 'GratingFinish';

% Define Banner text to identify the experimental protocol
S.protocolTitle = 'Grating Presentation Protocol';

% OUTPUT NAMING CONVENTIONS
A.outputPrefix = 'Grating';
A.subject = 'TEST';

%%%%% END OF NECESSARY VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% SETTINGS -- VARIABLES FOR TASK, NOT TO BE CHANGED WHILE RUNNING %%%%
% INCLUDES HARDWARE VALUES, COLOR ARRAYS, STIMULUS OPTION ARRAYS

% DEFINE THE COLOR LOOK UP TABLES
S.background = [0.1 0.1 0.1];
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
S.frameRate = 60;                   % Frame rate of screen in Hz
S.screenRect = [0 0 1440 900];      % Screen dimensions in pixels
S.screenWidth = 40.6;               % Width of screen (cm)
P.screenDistance = 14;              % Half distance from back of box to screen (cm)
S.screenDistance = 'Distance of ferret from screen (cm):';
S.chPhotodiode = 0;                 % ADC channel for the photodiode
S.photodiode = 0;                   % boolean for photodiode use
S.chLED1 = 0;                       % DAC channel for start LED
S.chLED2 = 3;                       % DAC channel for ending LED

%%%%% PARAMETERS -- VARIABLES FOR TASK, CAN CHANGE WHILE RUNNING %%%%%%%%%
% INCLUDES STIMULUS PARAMETERS, DURATIONS, FLAGS FOR TASK OPTIONS
% MUST BE SINGLE VALUE, NUMERIC -- NO STRINGS OR ARRAYS!
% THEY ALSO MUST INCLUDE DESCRIPTION OF THE VALUE IN THE SETTINGS ARRAY

% Stimulus settings
P.cpd = 0.08;
S.cpd = 'Cycles per degree:';
P.cps = 0;
S.cps = 'Cycles per second:';
P.angle = 0;
S.angle = 'Angle of grating (degrees):';
P.dir = 1;
S.dir = 'Direction of drift (+/-1):';
P.bkgd = 115;
S.bkgd = 'Choose a grating background color (0-255):';
P.range = 110;
S.range = 'Luminance range of grating (1-127):';

% Trial timing
P.delayDur = 10;
S.delayDur = 'Delay before presenting grating (s):';
P.stimDur = 4;
S.stimDur = 'Duration of grating presentation (s):';
P.iti = 1;
S.iti = 'Duration of intertrial interval (s):';

% Trial type control
P.runType = 1;                                    % Flag to use blocks
S.runType = '(0-random, 1-list, 2-blocks):';
P.blockLengthMin = 5;                             % Block length minimum
S.blockLengthMin = 'Minimum block length:';
P.blockLengthRan = 5;                             % Random additional block length
S.blockLengthRan = 'Maximum added block length:';

% Trials list -- side, cycPerDeg, cycPerSec, direction, angle
S.trialsList =  [       % THIS TRIALS LIST IS FOR STATIONARY GRATINGS
1    0.08 0    1    0;
1    0.40 0    1    0;
1    3.75 0    1    0;
2    0.08 0    1    0;
2    0.40 0    1    0;
2    3.75 0    1    0;
1    0.08 0    -1   0;
1    0.40 0    -1   0;
1    3.75 0    -1   0;
2    0.08 0    -1   0;
2    0.40 0    -1   0;
2    3.75 0    -1   0];