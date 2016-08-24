sca

S.screenNumber = 1;                 % Designates the display for task stimuli
S.frameRate = 60;                   % Frame rate of screen in Hz
S.screenRect = [0 0 1440 900];      % Screen dimensions in pixels
S.screenWidth = 40.6;               % Width of screen (cm)
S.screenDistance = 14;              % Half distance from back of box to screen (cm)
S.cpd = 0.08;
S.cps = 0;
S.angle = 0;
S.dir = 1;
S.bkgd = 127;
S.range = 127;


% Get rid of the Psychtoolbox welcome screen, Close any open windows
Screen('Preference','VisualDebuglevel',3); Screen('CloseAll');
% These commands ready the PTB motion server for the VIEWPixx 2-CLUT system
% This is the first step in setting up the image processing properties of 
% a window for the psychophysics toolbox
PsychImaging('PrepareConfiguration');
% Uses 32 bit precision in displaying colors, if hardware can not handle
% this with alpha blending, consider dropping to 16 bit precision or using
% 'FloatingPoint32BitIfPossible', to drop precision while maintaining 
% alpha blending.
PsychImaging('AddTask','General','FloatingPoint32BitIfPossible');
% Applies a simple power-law gamma correction
PsychImaging('AddTask','FinalFormatting','DisplayColorCorrection','SimpleGamma');
% Now the image processing properties are set, open the stimulus window
[A.window A.screenRect] = PsychImaging('OpenWindow',S.screenNumber,0);
% Add gamma correction
PsychColorCorrection('SetEncodingGamma',A.window,1/1.8);
% Get the frame refresh rate of the stimulus window
A.frameRate = FrameRate(A.window);
% Set the the PTB motion server to maximum priority
A.priorityLevel = MaxPriority(A.window);
% Set alpha blending functions for antialiasing
Screen(A.window,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);



% GET SOME USEFUL VALUES
% cm per pixel
cmperpix = S.screenWidth/A.screenRect(3);
% angle subtended by stimulus
t1 = atan2(cmperpix*150,S.screenDistance);
t2 = atan2(cmperpix*650,S.screenDistance);
t = (t2-t1)*180/pi;
% number of cycles in that span
cycN = S.cpd * t;
% factor to multiply the meshgrid (x)
r = cycN*pi/250;
% speed in cycles per frame
cycperframe = S.cps/A.frameRate;
% radians to advance per frame
rpf = cycperframe*2*pi;
                
% STIMULUS GENERATION
% CREATE A MASK
[x y] = meshgrid(-250:250);
fade = round((x.^2 + y.^2-235^2).^.75);
fade(fade < 0) = 0; fade(fade > 255) = 255;
mask = zeros(501,501,2) + S.bkgd;
mask(:,:,2) = fade;
A.maskTex = Screen('MakeTexture',A.window,mask);
% CREATE THE GRATING TEXTURES
ra = 2*pi*rand;         % random starting phase
if rpf > 0
    A.gratTex = nan(ceil(A.frameRate*3),1);
    for frame = 1:length(A.gratTex)
        grat = round(S.range*sin(S.dir*r*x+rpf*frame+ra))+127;
        A.gratTex(frame) = Screen('MakeTexture',A.window,grat);
    end
else
    grat = round(S.range*sin(S.dir*r*x+ra))+127;
    A.gratTex = Screen('MakeTexture',A.window,grat);
end

Screen('FillRect',A.window,S.bkgd);
Screen('DrawTexture',A.window,A.gratTex,[],[869 49 1370 550],S.angle);
Screen('DrawTexture',A.window,A.maskTex,[],[869 49 1370 550],S.angle);
Screen('Flip',A.window,GetSecs);
