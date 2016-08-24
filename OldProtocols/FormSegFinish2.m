function D = FormSegFinish2(D,A)

% Close the created textures so they don't pile up
Screen('Close',A.lineTex);
Screen('Close',A.distTex);

% PLACE DATA HERE TO BE RECORDED
D.stimSide(A.j,1) = A.stimSide;
D.lineColor(A.j,1) = A.lineColor;
D.firstTry(A.j,1) = A.firstTry;
D.startTime(A.j,1) = A.startTime;
D.startTimeDP(A.j,1) = A.startTimeDP;
D.firstTime(A.j,1) = A.firstTime;
D.finishTime(A.j,1) = A.finishTime;

% GET SOME STATS
D.numTrials = length(D.stimSide);
D.numRight = sum(D.stimSide == 1);
D.numLeft = sum(D.stimSide == 2);
D.numFirst = sum(D.firstTry);
D.fcAll = D.numFirst/D.numTrials;
D.fcRight = sum(D.firstTry & (D.stimSide==1))/D.numRight;
D.fcLeft = sum(D.firstTry & (D.stimSide==2))/D.numLeft;

% PLOT PERFORMANCE
figure(1); clf(1); bar([1 2 3],[D.fcAll D.fcRight D.fcLeft]);
axis([.5 3.5 0 1]); set(gca,'XTick',1:3,'XTickLabel',{'All' 'R' 'L'});
end