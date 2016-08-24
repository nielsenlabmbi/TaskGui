function D = PlaidFinish(D,A)

% function D = PlaidFinish(D,A)
%
% This function does things necessary to wrap up a trial, and is also
% crucial for setting information to be saved to the data file.
%
% Created by: Kristina Nielsen      Last Modified: 130215

% This command stops data update if no new entries are provided
if nargin > 1
    %A.tF % prints out the period number into the command window
    % PLACE DATA HERE TO BE RECORDED
    D.correct(A.j,1) = A.correct;
    D.side(A.j,1) = A.side;
    D.cpd(A.j,1) = A.cpd;
    D.tF(A.j,1) = A.tF;
    D.range(A.j,1) = A.range;
    D.plaid(A.j,1)=A.plaid;
    
    D.startTime(A.j,1) = A.startTime;       % Matlab time ferret started the trial
    D.startTimeDP(A.j,1) = A.startTimeDP;   % Datapixx time ferret started the trial
    D.responseTime(A.j,1) = A.responseTime; % Matlab time ferret made its first response
    D.frameTime{A.j}=A.frameTime;
end

% GET SOME STATS
D.numTrials = length(D.side);       % Total number of trials
D.numRight1 = sum(D.side == 1 & D.plaid ==0);      % Total number of Right trials, no plaid
D.numRight2 = sum(D.side == 1 & D.plaid ==1);      % Total number of Right trials, plaid
D.numLeft1 = sum(D.side == 2 & D.plaid ==0);       % Total number of Left trials, no plaid
D.numLeft2 = sum(D.side == 2 & D.plaid ==1);       % Total number of Left trials, plaid

D.numCorrect = sum(D.correct);          % Total number of correct trials
D.fcAll = D.numCorrect/D.numTrials;     % fraction of all trials correct
D.ncRight1 = sum(D.correct & (D.side==1) & D.plaid==0);
D.ncRight2 = sum(D.correct & (D.side==1) & D.plaid==1);
D.fcRight1 = D.ncRight1/D.numRight1;
D.fcRight2 = D.ncRight2/D.numRight2;
D.ncLeft1 = sum(D.correct & D.side==2 & D.plaid==0);
D.ncLeft2 = sum(D.correct & D.side==2 & D.plaid==1);
D.fcLeft1 = D.ncLeft1/D.numLeft1;
D.fcLeft2 = D.ncLeft2/D.numLeft2;


% PLOT PERFORMANCE
% Opening figure 1 to plot performance, and clearing any existant plots
figure(1); clf(1);
set(figure(1),'Position',[165 110 530 420]);
hold on;        %holds onto the plot
bar(1,100*D.fcAll,'FaceColor',[.75 0 .75]); %plots percentage of all data correct
bar(2,100*D.fcLeft1,'FaceColor',[0 0 1]);   %plots percentage of right data correct
bar(3,100*D.fcLeft2,'FaceColor',[0 0 1]);   %plots percentage of right data correct
bar(4,100*D.fcRight1,'FaceColor',[1 0 0]);    %plots percentage of left data correct
bar(5,100*D.fcRight2,'FaceColor',[1 0 0]);    %plots percentage of left data correct
%AXIS SETTIGNS
axis([.5 5.5 0 110.5]); %sets the x axis min and max and y axis min and max
%X AXIS
set(gca(1),'XTick',[1 2 3 4 5]) %Changes the graph to have three x axis labels instead of the default 1
set(gca(1),'XTickLabel', {'All' 'Left' 'Left P' 'Right' 'Right P'}); %Then labels the three bars.
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
rndPercentR1=strcat({num2str(round(100*D.fcRight1))},'%');
rndPercentR2=strcat({num2str(round(100*D.fcRight2))},'%');
rndPercentL1=strcat({num2str(round(100*D.fcLeft1))},'%');
rndPercentL2=strcat({num2str(round(100*D.fcLeft2))},'%');
y1=[rndPercentLR rndPercentL1 rndPercentL2 rndPercentR1 rndPercentR2]; %Used as the percentage text being displayed on graph
%Gets the TotalX from above converts number into string and adds N= at the beginning
rndTotalLR=strcat('N=',{num2str(D.numTrials)});
rndTotalR1=strcat('N=',{num2str(D.numRight1)});
rndTotalR2=strcat('N=',{num2str(D.numRight2)});
rndTotalL1=strcat('N=',{num2str(D.numLeft1)});
rndTotalL2=strcat('N=',{num2str(D.numLeft2)});
y2=[rndTotalLR rndTotalL1 rndTotalL2 rndTotalR1 rndTotalR2]; %Used as the total text being displayed on graph \
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