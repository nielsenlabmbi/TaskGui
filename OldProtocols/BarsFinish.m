function D = BarsFinish(D,A)

% function D = BarsFinish(D,A)
%
% This function does things necessary to wrap up a trial, and is also
% crucial for setting information to be saved to the data file.
%
% Created by: Sam Nummela       Last Modified: 310713

% This command stops data update if no new entries are provided
if nargin>1 
% Close the created textures so the don't add up and cause memory problems
Screen('Close',A.stimTex);
Screen('Close',A.distTex);
% PLACE DATA HERE TO BE RECORDED
D.stimSide(A.j,1) = A.stimSide;         % Side the stimulus is on
D.lineColor(A.j,1) = A.lineColor;       % Color of the distracter lines
D.firstTry(A.j,1) = A.firstTry;         % 1 if the ferret's first choice is correct
D.startTime(A.j,1) = A.startTime;       % Matlab time ferret started the trial
D.startTimeDP(A.j,1) = A.startTimeDP;   % Datapixx time ferret started the trial
D.firstTime(A.j,1) = A.firstTime;       % Matlab time ferret made its first response
D.finishTime(A.j,1) = A.finishTime;     % Matlabe time ferret made its final response (if allowing more than 1 try)
D.choiceTime(A.j,1) = A.choiceTime;
D.distTheta(A.j,1) = A.distTheta;
end

% GET SOME STATS
D.numTrials = length(D.stimSide);       %Total number of trials
D.numRight = sum(D.stimSide == 1);      %Total number of Right trials
D.numLeft = sum(D.stimSide == 2);       %Total number of Left trials
D.numFirst = sum(D.firstTry);           %Total number of correct trials
D.fcAll = D.numFirst/D.numTrials;       %fraction of all trials correct
D.fcRight = sum(D.firstTry & (D.stimSide==1))/D.numRight;   %fraction of all right trials correct
D.corrRight=sum(D.firstTry & D.stimSide==1);
D.fcLeft = sum(D.firstTry & (D.stimSide==2))/D.numLeft;     %fraction of all left trials correct
D.corrLeft=sum(D.firstTry & D.stimSide==2);
D.pcAll= D.fcAll*100;                   %Calculates the percentage of all trials correct
D.pcRight= D.fcRight*100;               %Calculates the percentage of right trials correct
D.pcLeft= D.fcLeft*100;                 %Calculates the percentage of left trials correct
[~, D.fitAll]=binofit(D.numFirst,D.numTrials,0.05);    
[~, D.fitRight]=binofit(D.corrRight,D.numRight,0.05);    
[~, D.fitLeft]=binofit(D.corrLeft,D.numLeft,0.05);       

% PLOT PERFORMANCE
% Opening figure 1 to plot performance, and clearing any existant plots
figure(1); clf(1);
set(figure(1),'Position',[165 110 530 420]);
hold on;        %holds onto the plot
bar(1,D.pcAll,'FaceColor',[.75 0 .75]); %plots percentage of all data correct
bar(2,D.pcLeft,'FaceColor',[0 0 1]);   %plots percentage of right data correct   
bar(3,D.pcRight,'FaceColor',[1 0 0]);    %plots percentage of left data correct
%AXIS SETTIGNS
axis([.5 3.5 0 110.5]); %sets the x axis min and max and y axis min and max
%X AXIS
set(gca(1),'XTick',[1 2 3]) %Changes the graph to have three x axis labels instead of the default 1
set(gca(1),'XTickLabel', {'All Trials' 'Left Trials' 'Right Trials'}); %Then labels the three bars.
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
rndPercentLR=strcat({num2str(round(1*D.pcAll))},'%'); 
rndPercentR=strcat({num2str(round(1*D.pcRight))},'%');
rndPercentL=strcat({num2str(round(1*D.pcLeft))},'%');
y1=[rndPercentLR rndPercentL rndPercentR]; %Used as the percentage text being displayed on graph
%Gets the TotalX from above converts number into string and adds N= at the beginning
rndTotalLR=strcat('N=',{num2str(D.numTrials)});
rndTotalR=strcat('N=',{num2str(D.numRight)});
rndTotalL=strcat('N=',{num2str(D.numLeft)});
y2=[rndTotalLR rndTotalL rndTotalR]; %Used as the total text being displayed on graph \
ytotal=[99.5 99.5 99.5]; %sets y axis position for where the text will be shown
x=1:3; %sets x axis postion for where the text will be displayed;
ypercent=ytotal+5; % so the numbers are not on top of each other by adding 5
%Places the text on the graph
for i=1:3
    text(x(i),ypercent(i),y1(i),'VerticalAlignment','bottom',...
        'HorizontalAlignment','center','FontSize',13);
    text(x(i),ytotal(i),y2(i),'VerticalAlignment','bottom',...
        'HorizontalAlignment','center','FontSize',13);
end
%ERROR BARS- BINOMIAL FIT
m=[1 3 2;1 3 2]; %the xaxis for the lines
D.fitAll=D.fitAll*100;
D.fitRight=D.fitRight*100;
D.fitLeft=D.fitLeft*100;
n=[D.fitAll(1) D.fitRight(1) D.fitLeft(1);D.fitAll(2) D.fitRight(2) D.fitLeft(2)];    %sets up the matrix of values for the error bars, this matrix needs to be the same size as m which is the x values
line(m,n,'LineWidth',5,'Color',[0 0 0]); %Adds error bars to the graph and makes them black
end