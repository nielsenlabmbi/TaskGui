function D = GratingFinish(D,A)

% PLACE DATA HERE TO BE RECORDED
D.stimSide(A.j,1) = A.stimSide;
D.startTime(A.j,1) = A.startTime;
D.startTimeDP(A.j,1) = A.startTimeDP;

% CLOSE TEXTURES
Screen('Close',A.maskTex);
for i = 1:length(A.gratTex)
    Screen('Close',A.gratTex(i));
end

end