function [A P] = BarsNext(S,P,A)

% function [A P] = BarsNext(S,P,A)
%
% This function performs tasks required before the start of each trial 
% such as generating stimulus related variables or setting up data 
% acquisition schedules.
%
% Any sub-functions used to generate stimuli should be located within this 
% function!
%
% THINKING IN TERMS OF LOOPS LOGIC, THE MAIN REASON FOR RUNNING THIS IS TO
% CONVERT ALL PARAMETERS, AND SETTINGS THAT DEFINE THE SCOPE OF PARAMETERS,
%
% Created by: Sam Nummela       Last modified: 310713

% LAST TRIAL TYPE, 0 random, 1 pseudorandom, 2 blocking
% If new output file, assume the last trial type was random
if A.newOutput, A.runType = 0; A.newOutput = 0; end

% GET STIMULUS SIDE AND BACKGROUND LINE COLOR
switch P.runType
    case 0
        % random stimulus side
        A.stimSide = ceil(2*rand);
    case 1
        % If last trial was not pseudo random, set up a trial list
        if ~(A.runType == 1)
            A.listIndex = 0;
        end
        % If list has finished start, start a new list
        if ~A.listIndex
            A.listPerm = randperm(size(S.trialsList,1));
        end
        % Get stimulus side and line color from trials list
        A.stimSide = S.trialsList(A.listPerm(A.listIndex+1),1);
        P.lineColor = S.trialsList(A.listPerm(A.listIndex+1),2);
        P.distTheta = S.trialsList(A.listPerm(A.listIndex+1),3);
        P.stimTheta = S.trialsList(A.listPerm(A.listIndex+1),4);
        % Update index
        A.listIndex = mod(A.listIndex+1,size(S.trialsList,1));
    case 2
        % If last trial was not blocking, then set up blocking
        if ~(A.runType == 2)
            A.stimSide = ceil(2*rand);
            A.blockIndex = 0;
        end
        % If block has finished, start a new block
        if ~A.blockIndex
            A.stimSide = mod(A.stimSide,2)+1;
            A.blockLength = P.blockLengthMin + floor((P.blockLengthRan+1)*rand);
        end
        % Update block index, reaching block length resets it to 0
        A.blockIndex = mod(A.blockIndex+1,A.blockLength);
end

% Update the run type, this is tracked so when the run type changes, history
% dependent run types (blocking, trials list) will correctly start a new
% set of trials
A.runType = P.runType;

% MAKE A LINE TEXTURE WITH A TRANSPARENCY LAYER
line = zeros(P.lineWidth+2,P.lineLength+2,4);
line(2:end-1,2:end-1,4) = 255;
line(:,:,1:3) = 255;
% PLACE THIS LINES INTO A SQUARE
square = zeros(300,300,4);
square(150-ceil(P.lineWidth/2+1)+(1:size(line,1)),150-ceil(P.lineLength/2+1)+(1:size(line,2)),1:size(line,3)) = line;
A.stimTex = Screen('MakeTexture',A.window,square);

% MAKE A DISTRACTER LINE WITH A DIFFERENT COLOR
line(:,:,1:3) = P.lineColor;
% PLACE THIS LINES INTO A SQUARE
square = zeros(300,300,4);
square(150-ceil(P.lineWidth/2+1)+(1:size(line,1)),150-ceil(P.lineLength/2+1)+(1:size(line,2)),1:size(line,3)) = line;
A.distTex = Screen('MakeTexture',A.window,square);

% DEFINE WHERE TO PLACE THE DISTRACTERS
A.distXY = [80   445  810  1175 1540 80   445  810  1175 1540 80   445  810  1175 1540;
            140  140  140  140  140  440  440  440  440  440  740  740  740  740  740 ;
            380  745  1110 1475 1840 380  745  1110 1475 1840 380  745  1110 1475 1840;
            440  440  440  440  440  740  740  740  740  740  1040 1040 1040 1040 1040];

% DEFINE WHERE TO PLACE THE STIMULUS
switch A.stimSide
    case 1
        A.stimXY = [1175 440 1475 740];
    case 2
        A.stimXY = [445 440 745 740];
end

end