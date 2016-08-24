function testRectAsLines

% Close all windows
sca;

% Open a window
Screen('Preference','VisualDebugLevel',3);
Screen('Preference','SuppressAllWarnings',1);
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','FloatingPoint32Bit');
PsychImaging('AddTask','General','EnableDataPixxM16OutputWithOverlay');
PsychImaging('AddTask','FinalFormatting','DisplayColorCorrection','SimpleGamma');
win = PsychImaging('OpenWindow',1,0);
% ADD GAMMA CORRECTION
PsychColorCorrection('SetEncodingGamma',win,1/2.2);
overlay = PsychImaging('GetOverlayWindow',win);
CLUT = defineColors;
Screen('LoadNormalizedGammaTable',win,CLUT,2);
MaxPriority(win);

% MAKE SURE THE SCANNING BACKLIGHT IS ON
Datapixx('Open');
Datapixx('EnableVideoScanningBacklight');

% SET A BLENDING FUNCTION
Screen(win,'BlendFunction',GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);



% MAKE A LINE TEXTURE WITH A TRANSPARENCY LAYER
line = zeros(160,160,2);
line(:,:,1) = 255;
line(77:83,6:155,2) = 255;  % THE OPAQUE PART OF THE TEXTURE DEFINES THE BAR

lineTex = Screen('MakeTexture',win,line);


% NOW START PASTING THESE TEXTURES ON A BACKGROUND
Screen('FillRect',win,.05);

% crossed lines
Screen('DrawTexture',win,lineTex,[],[1000 900 1160 1060],60);
Screen('DrawTexture',win,lineTex,[],[1000 900 1160 1060],11);

% Alternate crossed lines
Screen('DrawTextures',win,lineTex,[],...
    [1160 1160 1160; 900 900 900; 1320 1320 1320; 1060 1060 1060],[0 90 45]);

Screen('Flip',win);

end






function CLUT = defineColors
% Get color look up tables for an overlay window
% DEFINE THE COLOR LOOK UP TABLES
S.background = [0 0 0];

% COLORS FOR THE TASK CONTROLLER'S DISPLAY
S.controlsColors = [
0      0      0      ;  % 0 first row does not count
1      1      1      ;  % 1 white
0.5    0.5    0.5    ;  % 2 gray
1      0      0      ;  % 3 red
0      1      0      ;  % 4 green
0      0      1      ;  % 5 blue
1      1      1      ];
% COLORS FOR THE SUBJECT'S DISPLAY
S.subjectColors = [
0      0      0      ;  % 0 first row does not count
1      1      1      ;  % 1 white
0.5    0.5    0.5    ;  % 2 gray
S.background         ;  % 3 background
S.background         ;  % 4 background
S.background         ;  % 5 background
S.background         ];

S.controlsCLUT = [S.controlsColors; zeros(256-size(S.controlsColors,1),3)];
S.subjectCLUT = [S.subjectColors; zeros(256-size(S.subjectColors,1),3)];
% A COMBINED COLOR LOOK UP TABLE (CLUT) FOR THE VPIXX 2-CLUT SYSTEM
CLUT = [S.subjectCLUT; S.controlsCLUT];
end