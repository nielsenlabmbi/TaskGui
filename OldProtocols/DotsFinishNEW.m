function D = DotsFinishNEW(D,A)

% function D = DotsFinish(D,A)
%
% This function does things necessary to wrap up a trial, and is also
% crucial for setting information to be saved to the data file.
%
% Created by: Sam Nummela       Last Modified: 161213

% This command stops data update if no new entries are provided
if nargin>1 
% PLACE DATA HERE TO BE RECORDED
D.correct(A.j,1) = A.correct;
D.side(A.j,1) = A.side;
D.coh(A.j,1) = A.coh;
D.dir(A.j,1) = A.dir;
D.startTime(A.j,1) = A.startTime;       % Matlab time ferret started the trial
D.startTimeDP(A.j,1) = A.startTimeDP;   % Datapixx time ferret started the trial
D.responseTime(A.j,1) = A.responseTime; % Matlab time ferret made its first response
end

% GET SOME STATS
D.numTrials = length(D.side);       % Total number of trials
D.numRight = sum(D.side == 1);      % Total number of Right trials
D.numLeft = sum(D.side == 2);       % Total number of Left trials
D.numCorrect = sum(D.correct);          % Total number of correct trials
D.fcAll = D.numCorrect/D.numTrials;     % fraction of all trials correct
D.ncRight = sum(D.correct & (D.side==1));
D.fcRight = D.ncRight/D.numRight;
D.ncLeft = sum(D.correct & D.side==2);
D.fcLeft = D.ncLeft/D.numLeft;

D.trans= logical([0;diff(D.side)]);     %gets the transitions between sides
    D.totalTrans=sum(D.trans);            %gets the total number of transitions
    D.transRight=sum(D.trans==1 & D.side==1);   %gets the total number of transitions from left to right
    D.corrRight=sum(D.trans==1 & D.side==1 & D.correct==1);    %gets number of correct transitions
    D.transLeft=sum(D.trans==1 & D.side==2);    %gets the total number of transitions from right to left
    D.corrLeft=sum(D.trans==1 & D.side==2 & D.correct==1);     %gets number of correct transitions
    D.percCorrRight= D.corrRight/D.transRight*100;    %percentage correct for switching left to right
    D.percCorrLeft= D.corrLeft/D.transLeft*100;       %percentage correct for switching right to left
    
% PLOT PERFORMANCE
% Opening figure 1 to plot performance, and clearing any existant plots
figure(1); clf(1);
set(figure(1),'Position',[165 110 650 500]);
hold on;        %holds onto the plot
bar(1,100*D.fcAll,'FaceColor',[.75 0 .75]); %plots percentage of all data correct
bar(2,100*D.fcLeft,'FaceColor',[0 0 1]);   %plots percentage of right data correct
bar(3,D.percCorrLeft,'FaceColor',[1 1 0]); %plots percentage transitions correct from right to left
bar(4,100*D.fcRight,'FaceColor',[1 0 0]);    %plots percentage of left data correct
bar(5,D.percCorrRight,'FaceColor',[0 1 0]);  %plots percentage transitions correct from left to right
%AXIS SETTIGNS
axis([.5 5.5 0 110.5]); %sets the x axis min and max and y axis min and max
%X AXIS
set(gca(1),'XTick',[1 2 3 4 5]) %Changes the graph to have ***three x axis labels instead of the default 1
set(gca(1),'XTickLabel', {'All Trials' 'Left Trials' 'Right to Left' 'Right Trials' 'Left to Right'}); %Then labels the three bars.
%Y AXIS
set(gca(1),'YTick',[0 10 20 30 40 50 60 70 80 90 100]) %labels the major tic marks
set(gca(1),'YMinorTick','on');  %turns on the minor tics for easier estimation
ylabel('Correct Trial Percentage','FontSize',13);   %Labels the axis
space='  '; %Used in naming the graph to add a space between the two words
name=[A.outputPrefix space A.subject];
title(name,'FontSize',15); %Sets the title of the graph and the font size
set(gca(1),'FontSize',13);  %sets font size for the axies
%Gets the percent from above and rounds it so 1.there are no decimal points
%2.converts the number into a string, and 3. adds a % sign at the end
rndPercentLR=strcat({num2str(round(100*D.fcAll))},'%'); 
rndPercentR=strcat({num2str(round(100*D.fcRight))},'%');
rndPercentL=strcat({num2str(round(100*D.fcLeft))},'%');
rndPercentTR=strcat({num2str(round(D.percCorrRight))},'%');
rndPercentTL=strcat({num2str(round(D.percCorrLeft))},'%');
y1=[rndPercentLR rndPercentL rndPercentTL rndPercentR rndPercentTR]; %Used as the percentage text being displayed on graph
%Gets the TotalX from above converts number into string and adds N= at the beginning
rndTotalLR=strcat('N=',{num2str(D.numTrials)});
rndTotalR=strcat('N=',{num2str(D.numRight)});
rndTotalL=strcat('N=',{num2str(D.numLeft)});
rndTotalTR=strcat('N=',{num2str(D.transRight)});
rndTotalTL=strcat('N=',{num2str(D.transLeft)});
y2=[rndTotalLR rndTotalL rndTotalTL rndTotalR rndTotalTR]; %Used as the total text being displayed on graph \
ytotal=[99.5 99.5 99.5 99.5 99.5]; %sets y axis position for where the text will be shown
x=1:5; %sets x axis postion for where the text will be displayed;
ypercent=ytotal+5; % so the numbers are not on top of each other by adding 5
%Places the text on the graph
for i=1:5
    text(x(i),ypercent(i),y1(i),'VerticalAlignment','bottom',...
        'HorizontalAlignment','center','FontSize',13);
    text(x(i),ytotal(i),y2(i),'VerticalAlignment','bottom',...
        'HorizontalAlignment','center','FontSize',13);
end
end