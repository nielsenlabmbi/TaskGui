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

sca;
Screen('Preference','VisualDebuglevel',3); 
Screen('Preference','SuppressAllWarnings',1);
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','FloatingPoint32BitIfPossible');
PsychImaging('AddTask','General','EnableDataPixxM16OutputWithOverlay');
PsychImaging('AddTask','FinalFormatting','DisplayColorCorrection','SimpleGamma');
A.window = PsychImaging('OpenWindow',1,S.background);
PsychColorCorrection('SetEncodingGamma',A.window,1/2.2);
A.controlsCLUT = [S.controlsColors; zeros(256-size(S.controlsColors,1),3)];
A.subjectCLUT = [S.subjectColors; zeros(256-size(S.subjectColors,1),3)];
A.combinedCLUT = [A.subjectCLUT; A.controlsCLUT];
A.overlay = PsychImaging('GetOverlayWindow',A.window);
Screen('LoadNormalizedGammaTable',A.window,A.combinedCLUT,2);
A.priorityLevel = MaxPriority(A.window);
Screen(A.window,'BlendFunction',GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

if ~Datapixx('isReady'), Datapixx('Open'); pause(.1); end
Datapixx('StopAllSchedules');
Datapixx('EnableVideoScanningBacklight');
Datapixx('EnableAdcFreeRunning');
Datapixx('InitAudio');
Datapixx('WriteAudioBuffer',sin(2*pi*(1:64)/64));
Datapixx('RegWrRd');

square = zeros(300,300,4);
square(5:296,5:296,1:3) = 255;
square(5:296,5:296,4) = 255;
A.distTex = Screen('MakeTexture',A.window,square);
A.distXY = [80   445  810  1175 1540 80   445  810  1175 1540 80   445  810  1175 1540;
            140  140  140  140  140  440  440  440  440  440  740  740  740  740  740 ;
            380  745  1110 1475 1840 380  745  1110 1475 1840 380  745  1110 1475 1840;
            440  440  440  440  440  740  740  740  740  740  1040 1040 1040 1040 1040];
        
Screen('FillRect',A.overlay,0);
Screen('FillRect',A.window,S.background);
Screen('FillRect',A.overlay,4,[1700 50 1780 130]);
Screen('FillRect',A.overlay,4,[140 50 220 130]);
Screen('FillRect',A.overlay,4,[920 50 1000 130]);
Screen('FillOval',A.overlay,3,[1010 60 1070 120]);
Screen('DrawTextures',A.window,A.distTex,[],A.distXY,0);
Screen('Flip',A.window);

Screen('Close',A.distTex);


