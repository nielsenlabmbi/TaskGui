function [A S P] = MotFBAA4

%%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 250;

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'MotInit';
% "next trial" m-file
S.nextFunc = 'MotNext';
% "run trial" m-file
S.runFunc = 'MotRun';
% "finish trial" m-file
S.endFunc = 'MotFinish';

% Define Banner text to identify the experimental protocol
S.protocolTitle = 'Motion Discrimination Protocol';

% OUTPUT NAMING CONVENTIONS
A.outputPrefix = 'Mot';
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
S.screenDistance = 75;
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
S.cpd = 0.125;                   % Cycles per degree of grating
S.tF = 15;    %15                      % Number of frames to do 1 cycle, 120 = 1 Hz, 60 = 2Hz, 30 = 4Hz
S.angle = 0;                        % Angle of grating
S.bkgd = 127;                       % Grating background color
S.range = 121;                      % Grating range (i.e. contrast, 121 is 95%)

% Stimulus settings for method of constant stimuli, 16 deg/s
S.cpds = [0.125 0.125 0.125 0.125];
S.tFs = [60 48 24 12]; %[48 24 12 6];
% Trials list, col 1 is side, col2 is cpds/tFs index
S.trialsList = [1   1;
                1   1;
                1   1;
                1   1;
                2   1;
                2   1;
                2   1;
                2   1;
                1   2;
                1   2;
                1   2;
                1   2;
                2   2;
                2   2;
                2   2;
                2   2;
                1   3;
                1   3;
                1   3;
                1   3;
                2   3;
                2   3;
                2   3;
                2   3;
                1   4;
                1   4;
                1   4;
                1   4;
                2   4;
                2   4;
                2   4;
                2   4];
            
% Timing variables
P.durValve1 = 280;                                        % Reward duration for valve 1 (ms)
S.durValve1 = 'Duration of right valve (ms):';
P.durValve2 = 280;                                        % Reward duration for valve 2 (ms)
S.durValve2 = 'Duration of left valve (ms):';
P.durValve3 = 40;                                        % Reward duration for valve 3 (ms)
S.durValve3 = 'Duration of back valve (ms):';
P.durTone = 1;                                           % audio feedback (s)
S.durTone = 'Duration of feedback tone (s):';
P.durITI = 1.6;
S.durITI = 'Intertrial interval (s):';
P.durStim = 0;
S.durStim = 'Duration of stimulus from midpoint (s):';

% Trial control
P.forceCorrect = 1;
S.forceCorrect = 'Force correct response?';
P.alwaysWater = 0.10;
S.alwaysWater = 'Water when initially wrong?';
P.runType = 0;
S.runType = '(0-random, 1-list, 2-blocks):';
P.blockLengthMin = 2;
S.blockLengthMin = 'Minimum block length:';
P.blockLengthRan = 2;
S.blockLengthRan = 'Maximum added block length:';
P.counterPhase = 0;
S.counterPhase = 'Switch phase every x frames:';
