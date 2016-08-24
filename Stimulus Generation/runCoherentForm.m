win = Screen('OpenWindow',1,0);

Screen(win,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

circleCenter = ceil([1000 800].*rand(1,2))-500;
XY = genCoherentForm(.3,circleCenter);

Screen('DrawLines',win,XY,7,[255 255 255],[960 510],0);
Screen('Flip',win);
WaitSecs(5);

Screen('DrawLines',win,XY,7,[255 255 255],[960 510],1);
Screen('Flip',win);
WaitSecs(5);

Screen('CloseAll');
