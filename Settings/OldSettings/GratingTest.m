function [A S P] = GratingTest

%%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 100;

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'GratingInit2';
% "next trial" m-file
S.nextFunc = 'GratingNext2';
% "run trial" m-file
S.runFunc = 'GratingRun2';
% "finish trial" m-file
S.endFunc = 'GratingFinish2';

% Define Banner text to identify the experimental protocol
S.protocolTitle = 'Grating Presentation Protocol';

% OUTPUT NAMING CONVENTIONS
A.outputPrefix = 'Pref';
A.subject = 'TEST';

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
P.screenDistance = 50;                % Half distance from back of box to screen (cm)
S.screenDistance = 'Distance of ferret from screen (cm):';
S.chPhotodiode = 0;                 % ADC channel for the photodiode
S.photodiode = 0;                   % boolean for photodiode use
S.chLED1 = 0;                       % DAC channel for start LED
S.chLED2 = 3;                       % DAC channel for ending LED
S.chBeam = 8;                       % ADC channel for midway IR beam

%%%%% PARAMETERS -- VARIABLES FOR TASK, CAN CHANGE WHILE RUNNING %%%%%%%%%
% INCLUDES STIMULUS PARAMETERS, DURATIONS, FLAGS FOR TASK OPTIONS
% MUST BE SINGLE VALUE, NUMERIC -- NO STRINGS OR ARRAYS!
% THEY ALSO MUST INCLUDE DESCRIPTION OF THE VALUE IN THE SETTINGS ARRAY

% Stimulus settings
P.cpd = .25;
S.cpd = 'Cycles per degree:';
P.angle = 0;
S.angle = 'Angle of grating (degrees):';
P.bkgd = 127;
S.bkgd = 'Choose a grating background color (0-255):';
P.range = 127;
S.range = 'Luminance range of grating (1-127):';
P.stimSide = 1;
S.stimSide = 'Stimulus side, 1-right, 2-left, 3-mid:';

% Trial timing
P.stimDur = 5;
S.stimDur = 'Duration of grating presentation (s):';

% Trial control
P.trigger = 0;
S.trigger = 'Trigger grating from midway beam?:';

% Trials list
P.runType = 1;
S.runType = '0 -- random, 1 -- trials list:';
S.trialsList = [
0.125   1;
0.125   2;
0.125   3;
0.25    1;
0.25    2;
0.25    3;
0.5     1;
0.5     2;
0.5     3];
