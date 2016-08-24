load('Output/Dots_050314_FBAA0_0.mat')  % loads the file
trans=logical([0;diff(D.side)]);        % creats logical array for when switches occur
totalTrans= sum(trans(1,:));            %gets total number of transitions
totalTransRight=0;  
totalTransLeft=0;
corrRight=0;
corrLeft=0;
for i=1:D.numTrials
if trans(i)==1
    if D.side(i)==1     % for switching left to right side
        totalTransRight=totalTransRight+1;  %adds up the total number of switches for the right
        if D.correct(i)==1
            corrRight=corrRight+1;      %adds up the number of correct switches for right
        end
    end
    if D.side(i)==2     %for swithcing right to left side
        totalTransLeft=totalTransLeft+1; %adds up the total number of switches for the left
        if D.correct(i)==1
            corrLeft=corrLeft+1;        %adds up the number of correct switches for left
        end
    end
end
end
percCorrRight= corrRight/totalTransRight*100    %percentage correct for switching left to right
percCorrLeft= corrLeft/totalTransLeft*100       %percentage correct for switching right to left
