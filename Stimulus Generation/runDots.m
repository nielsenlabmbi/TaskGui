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
[A.window A.screenRect] = PsychImaging('OpenWindow',1,0);
% Apply a gamma correction
PsychColorCorrection('SetEncodingGamma',A.window,1/2.2);
% Get the frame refresh rate of the stimulus window
A.frameRate = FrameRate(A.window);
% Set the the PTB motion server to maximum priority
A.priorityLevel = MaxPriority(A.window);
% Set alpha blending functions for antialiasing
Screen(A.window,'BlendFunction',GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

% Seed random number generation by date
S = RandStream.create('mrg32k3a','NumStreams',1,'Seed',datenum(date));

N = 25;
R = 280;
D = 135;
C = 1.0;
L = 16;
V = 5;
dotSize = 35;
frames = 720;

x = nan(N,frames);
y = nan(N,frames);
sig = false(N,frames);
d = nan(N,frames);
l = nan(N,frames);

[x(:,1) y(:,1) sig(:,1) d(:,1) l(:,1)] = genDots(N,R,D,C,L,S);

for i = 2:frames
    [x(:,i) y(:,i) sig(:,i) d(:,i) l(:,i)] = updateDots(x(:,i-1),y(:,i-1),sig(:,i-1),d(:,i-1),l(:,i-1),R,L,V,S);
end

disp('Playing movie now')
times = nan(frames,1);
for i = 1:frames
    % Screen('FrameOval',A.window,.5,[250 250 750 750]);
    Screen('DrawDots',A.window,[x(:,i)';y(:,i)'],dotSize,1,[500 500],2);
    times(i) = Screen('Flip',A.window);
end
