sca;

% Suppress PTB warnings
visualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
supressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);

% PREPARE WINDOW
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','FloatingPoint32Bit');
PsychImaging('AddTask','General','EnableDataPixxM16OutputWithOverlay');
PsychImaging('AddTask','FinalFormatting','DisplayColorCorrection','SimpleGamma');

% Open a window -- screen number 1, color 0, full screen, 32 bit pixels, 2 buffers
[win rect] = Screen('OpenWindow',1,0);


% Max priority
MaxPriority(win);

% Blend function, not familiar with this command, should allow alpha blending
Screen(win,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);


%%%%% Now place a white stripe across the center of the screen
Screen('FillRect',win,255,[0 700 1920 760]);

% Create a gray mask
[x y] = meshgrid(-100:100,-100:100);
mask = ones(201,201,2)*120;
mask(:,:,2) = (x.^2 + y.^2 > 2500)*255;

% Turn the array into a texture
maskTex = Screen('MakeTexture',win,mask);

% Draw the texture over the line to check the transparancy mask window
Screen('DrawTexture',win,maskTex,[0 0 201 201],[800 650 1001 851]);

%%%% OK SO FAR THIS IS WORKING, SEE IF I CAN GET ANTI-ALIASED LINES NOW

% MAKE A LINE TEXTURE WITH A TRANSPARENCY LAYER
line = zeros(160,160,2);
line(27:33,6:155,1) = 255;
line(27:33,6:155,2) = 255;

lineTex = Screen('MakeTexture',win,line);

% NOW START PASTING THESE TEXTURES DOWN
Screen('DrawTexture',win,lineTex,[0 0 160 160],[500 900 660 1060],0);
Screen('DrawTexture',win,lineTex,[0 0 160 160],[560 900 720 1060],30);
Screen('DrawTexture',win,lineTex,[0 0 160 160],[620 900 780 1060],60);
Screen('DrawTexture',win,lineTex,[0 0 160 160],[680 900 840 1060],90);


Screen('DrawTexture',win,lineTex,[0 0 160 160],[1000 900 1160 1060],60);
Screen('DrawTexture',win,lineTex,[0 0 160 160],[1000 900 1160 1060],0);

Screen('Flip',win);

