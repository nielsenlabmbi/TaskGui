function D = GratingFinish2(D,A)

% PLACE DATA HERE TO BE RECORDED
D.stimSide(A.j,1) = A.stimSide;
D.cpd(A.j,1) = A.cpd;
D.startTime(A.j,1) = A.startTime;
D.startTimeDP(A.j,1) = A.startTimeDP;

% CLOSE TEXTURES
Screen('Close',A.gratTex);

end