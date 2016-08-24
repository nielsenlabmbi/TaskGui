win = Screen('OpenWindow',1,0);

% circleCenter = ceil([1000 800].*rand(1,2))-500;

coherences = [0 .08 .18 .33 .7 1];
circleCenter = [200 100];

for i = 1:length(coherences)
    
    c = coherences(i);
    
    XY = genCoherentForm(c,circleCenter);
    
    Screen('DrawLines',win,XY,5,[255 255 255], [960 510]);
    Screen('Flip',win);
    
    imageArray = Screen('GetImage', win);
    imageTitle = sprintf('formCoh%d.jpg',100*c);
    imwrite(imageArray,imageTitle,'jpeg');
end

Screen('CloseAll');


% % capture screen images using 'GetImage' and save it into imageArray
% for m=1:nFrames
%     Screen('DrawDots',win,allPos,dotSize,contrastValue,[],dotType);
%     VBL= Screen('Flip', win, [] , AuxBuffers);
%     imageArray{m}= Screen('GetImage', win);
% end
% %Create the movie
% h=figure;
% for m=1:length(imageArray)
%     imshow(imageArray{m});
%     M(m) = getframe(h);
% end
% movie(M);
% movie2avi(M,'movie');