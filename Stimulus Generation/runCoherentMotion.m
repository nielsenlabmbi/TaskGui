win = Screen('OpenWindow',1,0);

XY = genCoherentMotion(300);

for i = 1:180
    Screen('DrawLines',win,XY(:,:,i),3,[255 255 255], [960 510]);
    Screen('Flip',win);
end

Screen('CloseAll');
