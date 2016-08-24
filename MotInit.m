function A = MotInit(S,A)

% function A = MotInit(S,A)
%
% This function performs one-time needed steps to prepare the protocol for 
% running repeated trials of the task.
%
% Input:
% S                     Task settings
% A                     Temporarily held task values
%
% Output:
% A                     Temporarily held taks values
%
% Created by: Sam Nummela       Last modified: 190514

% Get into a random zone
rand(mod(round(GetSecs),10000000),1);

%%%%% INITIALIZE THE VIEWPIXX 3D %%%%%
% Close any open windows
sca;
% Get rid of the Psychtoolbox welcome screen, Close any open windows
Screen('Preference','VisualDebuglevel',3); 
Screen('Preference','SuppressAllWarnings',1);
% These commands ready the PTB motion server for the VIEWPixx 2-CLUT system
% This is the first step in setting up the image processing properties of 
% a window for the psychophysics toolbox
PsychImaging('PrepareConfiguration');
% Uses 32 bit precision in displaying colors, if hardware can not handle
% this with alpha blending, consider dropping to 16 bit precision or using
% 'FloatingPoint32BitIfPossible', to drop precision while maintaining 
% alpha blending.
PsychImaging('AddTask','General','FloatingPoint32BitIfPossible');
% This command adds the use of an overlay window, unlike the main window,
% the overlay window uses a color look-up table where 0 values are
% transparent, Overlay for Viewpixx is only supported in M16 mode
PsychImaging('AddTask','General','EnableDataPixxM16OutputWithOverlay');
% Applies a simple power-law gamma correction
PsychImaging('AddTask','FinalFormatting','DisplayColorCorrection','SimpleGamma');
% Now the image processing properties are set, open the stimulus window
[A.window A.screenRect] = PsychImaging('OpenWindow',S.screenNumber,S.background);
% Apply a gamma correction -- Also possible to load a gamma table, but this
% works well for the ViewPIXX -- 2.2 gamma correction
PsychColorCorrection('SetEncodingGamma',A.window,1/2.2);
% Get the frame refresh rate of the stimulus window
A.frameRate = FrameRate(A.window);
% Get color look up tables for an overlay window
A.controlsCLUT = [S.controlsColors; zeros(256-size(S.controlsColors,1),3)];
A.subjectCLUT = [S.subjectColors; zeros(256-size(S.subjectColors,1),3)];
% A COMBINED COLOR LOOK UP TABLE (CLUT) FOR THE VPIXX 2-CLUT SYSTEM
A.combinedCLUT = [A.subjectCLUT; A.controlsCLUT];
% Open the overlay window for writing to the window using the clut
A.overlay = PsychImaging('GetOverlayWindow',A.window);
% Load the CLUTs that were combined into the window, the VIEWPixx will use
% the first 256 values in the CLUT, the VIEWPixx DVI out will use the
% next 256 values.
Screen('LoadNormalizedGammaTable',A.window,A.combinedCLUT,2);
% Set the the PTB motion server to maximum priority
A.priorityLevel = MaxPriority(A.window);
% Set alpha blending functions for antialiasing
Screen(A.window,'BlendFunction',GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

% INITIALIZE THE VIEWPIXX FOR STIMULUS CONTROL AND DATA COLLECTION
% Open the viewpixx device for communication with Matlab
if ~Datapixx('isReady'), Datapixx('Open'); pause(.1); end
% Stop any pre-existing schedules, none should be running, just to be safe
Datapixx('StopAllSchedules');
% Enable the scanning backlight, in this mode back light modules sweep
% across the monitor similar to the way a CRT sweeps across a TV screen,
% briefly illuminating the LCD when at the correct color and hiding
% the LCD as it transitions from one color to another.
Datapixx('EnableVideoScanningBacklight');
% Enable the ability to query ADC voltages realtime, this reduces
% accuracy of scheduled collection by 5 micro-seconds, but is worth the
% small trade-off in accuracy for real-time beam detection
Datapixx('EnableAdcFreeRunning');
% Initializes audio output of the Viewpixx
Datapixx('InitAudio');
% 64-sample sinewave in audio buffer--all tones will be sinewaves
Datapixx('WriteAudioBuffer',sin(2*pi*(1:64)/64));
% Set volume
Datapixx('SetAudioVolume',.06);
% Write these changes to the Viewpixx
Datapixx('RegWrRd');

% Blank screen
Screen('FillRect',A.overlay,0);
Screen('FillRect',A.window,.5);
Screen('Flip',A.window);

% Create gratings using settings
% GET SOME CRUCIAL CONVERSION VALUES
DistanceCM = S.screenDistance;
ScreenWidthCM = S.screenWidth;
ScreenWidthDeg = 2*atan2((ScreenWidthCM/2),DistanceCM)*180/pi;
ScreenWidthPix = A.screenRect(3);
DegPerPix = ScreenWidthDeg/ScreenWidthPix;
PixPerDeg = 1/DegPerPix;

% Create grating for single cpd options (for blocking or random) -- you
% cannot run multiple cyc per deg or temporal freqs without a trials list!
%nCycles = 24*S.cpd;
%had to shrink the stimulus to accomdate graphics card issues
nCycles = 15*S.cpd;
DegPerCyc = 1/S.cpd;
ApertureDeg = DegPerCyc*nCycles;
AperturePix = round(PixPerDeg*ApertureDeg);
% CREATE A MESHGRID THE SIZE OF THE GRATING
GridLims = [-(AperturePix-1)/2 (AperturePix-1)/2];
[x y] = meshgrid(GridLims(1):GridLims(2));
% CREATE A GAUSSIAN TO SMOOTH THE OUTER 10% OF THE GRATING
r = sqrt(x.^2 + y.^2);
%sigmaDeg = ApertureDeg/16.5;
sigmaDeg = ApertureDeg/10.3;
MaskLimit = abs(x(1,round(.2*AperturePix)));
sigmaPix = sigmaDeg*PixPerDeg;
e1 = exp(-.5*(r-MaskLimit).^2/sigmaPix.^2);
e1(r<MaskLimit) = 1;
tF = S.tF;        % Number of frames to go one cycle (120 = 1Hz, 60 = 2Hz, 30 = 4Hz)
% GRATING
for i = 0:(tF-1)
    s1 = sin(nCycles.*(x+GridLims(2))./((AperturePix-1)/(2*pi)) + (-i*2*pi/tF)).*e1;
    g1 = round(s1*S.range) + S.bkgd;
    A.gratTex(i+1) = Screen('MakeTexture',A.window,g1);
end

% Now, if S.cpds and S.tFs are fields, it will create gratings for use with
% a trials list
if isfield(S,'cpds') && isfield(S,'tFs')
    for j = 1:length(S.cpds)
        nCycles = 24*S.cpds(j);
        tF = S.tFs(j);
        for i = 0:(tF-1)
            s1 = sin(nCycles.*(x+GridLims(2))./((AperturePix-1)/(2*pi)) + (-i*2*pi/tF)).*e1;
            g1 = round(s1*S.range) + S.bkgd;
            A.gratTexs(j).a(i+1) = Screen('MakeTexture',A.window,g1);
        end
    end
end
