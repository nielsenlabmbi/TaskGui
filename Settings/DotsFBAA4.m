function [A S P] = DotsFBAA0

%%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 250;

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'DotsInit';
% "next trial" m-file
S.nextFunc = 'DotsNext';
% "run trial" m-file
S.runFunc = 'DotsRun';
% "finish trial" m-file
S.endFunc = 'DotsFinish_varispeed';

% Define Banner text to identify the experimental protocol
S.protocolTitle = 'Coherent Motion Detection';

% OUTPUT NAMING CONVENTIONS
A.outputPrefix = 'Dots';
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
S.background         ;  % 2 background
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
P.dotSize = 1.5;
S.dotSize = 'Dot size (deg):';
P.nrDots = 100;
S.nrDots = 'Nr dots:';
P.dir = 0;
S.dir = 'Direction (0 or 180):';
P.bkgd = 0;
S.bkgd = 'Choose a background color (0-1)';
P.dotSpeed = .6; %used to be 30
S.dotSpeed = 'Speed of dot in deg per frame:'; 
P.fractionBlack = .5;
S.fractionBlack = 'Fraction of black dots:';
P.dotCoherence = 1;
S.dotCoherence = 'Fraction noise dots:';
P.dotLifetime = 240;
S.dotLifetime = 'Lifetime in frames (0 indef):';

% Timing variables
P.durStim = 60;
S.durStim = 'Max duration of stimulus (s):';
P.durValve1 = 300;                                       % Reward duration for valve 1 (ms)
S.durValve1 = 'Duration of right valve (ms):';
P.durValve2 = 300;                                       % Reward duration for valve 2 (ms)
S.durValve2 = 'Duration of left valve (ms):';
P.durValve3 = 100;                                        % Reward duration for valve 3 (ms)
S.durValve3 = 'Duration of back valve (ms):';
P.durTone = 1;                                           % audio feedback (s)
S.durTone = 'Duration of feedback tone (s):';
P.durITI = 3.0;
S.durITI = 'Intertrial interval (s):';


% Trial control
P.forceCorrect = 1;
S.forceCorrect = 'Force correct response?';
P.alwaysWater = 0.20;
S.alwaysWater = 'Water when initially wrong?';
P.runType = 1;
S.runType = '(0-random, 1-list, 2-force side):';
P.forceSide = 1;
S.forceSide = 'Force side, 1-right 2-left';

% Trials list -- Column 1: reward side -- Column 2: direction of motion --
% Column 3: motion coherence -- column 4: speed 
S.trialsList = [
    
1   0   .6   .05;
2   180  .6  .05;
1   0   .6   .2;
2   180  .6  .2;
1   0   .6  .4;
2   180 .6  .4;
1   0   .6   .6;
2   180  .6  .6;
1   0   .6  1.2;
2   180 .6  1.2;

% 1   0   1.0   .2;
% 2   180  1.0  .2;
% 1   0   .8   .2;
% 2   180  .8  .2;
% 1   0   .6  .2;
% 2   180 .6  .2;
% 1   0   .4   .2;
% 2   180  .4  .2;
% 1   0   .2  .2;
% 2   180 .2  .2;
% 1   0   .15  .2;
% 2   180 .15 .2;

];