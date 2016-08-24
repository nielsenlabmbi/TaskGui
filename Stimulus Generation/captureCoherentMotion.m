win = Screen('OpenWindow',1,0);

nFrames = 25;
XY = genCoherentMotion(nFrames);
imageArray = cell(nFrames,1);

for i = 1:nFrames
    Screen('DrawLines',win,XY(:,:,i),3,[255 255 255], [960 510]);
    Screen('Flip',win);
    
    imageArray{i} = Screen('GetImage',win);
end

Screen('CloseAll');

h=figure;
for i = 1:nFrames
    imshow(imageArray{i});
    M(i) = getframe(h);
end
movie(M);
movie2avi(M,'movie');
