function D = OriVerticalFinish(D,A)

% function D = OriFinish(D,A)
%
% This function does things necessary to wrap up a trial, and is also
% crucial for setting information to be saved to the data file.
%
% Created by: Sam Nummela       Last Modified: 280813

% This command stops data update if no new entries are provided
if nargin>1 
% Close the created textures so the don't add up and cause memory problems
Screen('Close',A.gratTex);
%Screen('Close',A.gratTex(2));
% PLACE DATA HERE TO BE RECORDED
D.correct(A.j,1) = A.correct;
D.side(A.j,1) = A.side;
D.cpd(A.j,1) = A.cpd;
D.angle(A.j,1) = A.angle;
D.range(A.j,1) = A.range;
D.startTime(A.j,1) = A.startTime;       % Matlab time ferret started the trial
D.startTimeDP(A.j,1) = A.startTimeDP;   % Datapixx time ferret started the trial
D.responseTime(A.j,1) = A.responseTime; % Matlab time ferret made its first response
D.phase(A.j,1) = A.phase;
D.frameTime{A.j}=A.frameTime;
end

% GET SOME STATS
D.numTrials = length(D.side);       % Total number of trials
D.numR45 = sum(D.angle == 135);      % Total number of R45
D.numL45 = sum(D.angle == 45);       % Total number of L45
D.numR30 = sum(D.angle == 150);      % Total number of R30
D.numL30 = sum(D.angle == 30);       % Total number of L30
D.numR20 = sum(D.angle == 160);      % Total number of R25
D.numL20 = sum(D.angle == 20);       % Total number of L25
D.numR15 = sum(D.angle == 165);      % Total number of R15
D.numL15 = sum(D.angle == 15);       % Total number of L15
D.numR10 = sum(D.angle == 170);      % Total number of R10
D.numL10 = sum(D.angle == 10);       % Total number of L10
D.numR7 = sum(D.angle == 171);      % Total number of R9
D.numL7 = sum(D.angle == 9);       % Total number of L9
D.numR4 = sum(D.angle == 176);      % Total number of R4
D.numL4 = sum(D.angle == 4);       % Total number of L4

D.numCorrect = sum(D.correct);          % Total number of correct trials
D.fcAll = D.numCorrect/D.numTrials;     % fraction of all trials correct

D.ncR45 = sum(D.correct & (D.angle == 135));
D.fcR45 = D.ncR45/D.numR45;
D.ncL45 = sum(D.correct & (D.angle == 45));
D.fcL45 = D.ncL45/D.numL45;

D.ncR30 = sum(D.correct & (D.angle == 150));
D.fcR30 = D.ncR30/D.numR30;
D.ncL30 = sum(D.correct & (D.angle == 30));
D.fcL30 = D.ncL30/D.numL30;

D.ncR20 = sum(D.correct & (D.angle == 160));
D.fcR20 = D.ncR20/D.numR20;
D.ncL20 = sum(D.correct & (D.angle == 20));
D.fcL20 = D.ncL20/D.numL20;

D.ncR15 = sum(D.correct & (D.angle == 165));
D.fcR15 = D.ncR15/D.numR15;
D.ncL15 = sum(D.correct & (D.angle == 15));
D.fcL15 = D.ncL15/D.numL15;

D.ncR10 = sum(D.correct & (D.angle == 170));
D.fcR10 = D.ncR10/D.numR10;
D.ncL10 = sum(D.correct & (D.angle == 10));
D.fcL10 = D.ncL10/D.numL10;

D.ncR7 = sum(D.correct & (D.angle == 173));
D.fcR7 = D.ncR7/D.numR7;
D.ncL7 = sum(D.correct & (D.angle == 7));
D.fcL7 = D.ncL7/D.numL7;

D.ncR4 = sum(D.correct & (D.angle == 176));
D.fcR4 = D.ncR4/D.numR4;
D.ncL4 = sum(D.correct & (D.angle == 4));
D.fcL4 = D.ncL4/D.numL4;

D.fcAll = D.numCorrect/D.numTrials;     % fraction of all trials correct

% PLOT PERFORMANCE
% Opening figure 1 to plot performance, and clearing any existant plots

figure(1); clf(1);
set(figure(1),'Position',[50 110 1000 420]);
hold on;        %holds onto the plot

bar(1,100*D.fcAll,'FaceColor',[.75 0 .75]); %plots percentage of all data correct
bar(2,100*D.fcL45,'FaceColor',[0 0 1]);
bar(3,100*D.fcR45,'FaceColor',[1 0 0]);    %plots percentage of left data correct
bar(4,100*D.fcL30,'FaceColor',[0 0 1]);   %plots percentage of right data correct 
bar(5,100*D.fcR30,'FaceColor',[1 0 0]);    %plots percentage of left data correct
bar(6,100*D.fcL20,'FaceColor',[0 0 1]);   %plots percentage of right data correct 
bar(7,100*D.fcR20,'FaceColor',[1 0 0]);    %plots percentage of left data correct
bar(8,100*D.fcL15,'FaceColor',[0 0 1]);   %plots percentage of right data correct 
bar(9,100*D.fcR15,'FaceColor', [1 0 0]);
bar(10,100*D.fcL10,'FaceColor',[0 0 1]);
bar(11,100*D.fcR10,'FaceColor',[1 0 0]); 
bar(12,100*D.fcL7,'FaceColor',[0 0 1]);   %plots percentage of right data correct 
bar(13,100*D.fcR7,'FaceColor', [1 0 0]);
bar(14,100*D.fcL4,'FaceColor',[0 0 1]);   %plots percentage of right data correct 
bar(15,100*D.fcR4,'FaceColor', [1 0 0]);

    %AXIS SETTIGNS
axis([.5 15.5 0 110.5]); %sets the x axis min and max and y axis min and max
%X AXIS
set(gca(1),'XTick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]) %Changes the graph to have three x axis labels instead of the default 1
set(gca(1),'XTickLabel', {'All' 'L45' 'R45' 'L30' 'R30' 'L20' 'R20' 'L15' 'R15' 'L10' 'R10' 'L9' 'R9' 'L4' 'R4'}); %Then labels the three bars.
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
rndPercentR45=strcat({num2str(round(100*D.fcR45))},'%');
rndPercentL45=strcat({num2str(round(100*D.fcL45))},'%');
rndPercentR30=strcat({num2str(round(100*D.fcR30))},'%');
rndPercentL30=strcat({num2str(round(100*D.fcL30))},'%');
rndPercentR20=strcat({num2str(round(100*D.fcR20))},'%');
rndPercentL20=strcat({num2str(round(100*D.fcL20))},'%');
rndPercentR15=strcat({num2str(round(100*D.fcR15))},'%');
rndPercentL15=strcat({num2str(round(100*D.fcL15))},'%');
rndPercentR10=strcat({num2str(round(100*D.fcR10))},'%');
rndPercentL10=strcat({num2str(round(100*D.fcL10))},'%');
rndPercentR7=strcat({num2str(round(100*D.fcR7))},'%');
rndPercentL7=strcat({num2str(round(100*D.fcL7))},'%');
rndPercentR4=strcat({num2str(round(100*D.fcR4))},'%');
rndPercentL4=strcat({num2str(round(100*D.fcL4))},'%');
y1=[rndPercentLR rndPercentL45 rndPercentR45  rndPercentL30 rndPercentR30 rndPercentL20 rndPercentR20 rndPercentL15 rndPercentR15 rndPercentL10 rndPercentR10 rndPercentL7 rndPercentR7 rndPercentL4 rndPercentR4]; %Used as the percentage text being displayed on graph
%Gets the TotalX from above converts number into string and adds N= at the beginning
rndTotalLR=strcat('N=',{num2str(D.numTrials)});
rndTotalR45=strcat('N=',{num2str(D.numR45)});
rndTotalL45=strcat('N=',{num2str(D.numL45)});
rndTotalR30=strcat('N=',{num2str(D.numR30)});
rndTotalL30=strcat('N=',{num2str(D.numL30)});
rndTotalR20=strcat('N=',{num2str(D.numR20)});
rndTotalL20=strcat('N=',{num2str(D.numL20)});
rndTotalR15=strcat('N=',{num2str(D.numR15)});
rndTotalL15=strcat('N=',{num2str(D.numL15)});
rndTotalR10=strcat('N=',{num2str(D.numR10)});
rndTotalL10=strcat('N=',{num2str(D.numL10)});
rndTotalR7=strcat('N=',{num2str(D.numR7)});
rndTotalL7=strcat('N=',{num2str(D.numL7)});
rndTotalR4=strcat('N=',{num2str(D.numR4)});
rndTotalL4=strcat('N=',{num2str(D.numL4)});
y2=[rndTotalLR rndTotalL45 rndTotalR45 rndTotalL30 rndTotalR30 rndTotalL20 rndTotalR20 rndTotalL15 rndTotalR15 rndTotalL10 rndTotalR10 rndTotalL7 rndTotalR7 rndTotalL4 rndTotalR4]; %Used as the total text being displayed on graph \
ytotal=[99.5 99.5 99.5 99.5 99.5 99.5 99.5 99.5 99.5 99.5 99.5 99.5 99.5 99.5 99.5]; %sets y axis position for where the text will be shown
x=1:15; %sets x axis postion for where the text will be displayed;
ypercent=ytotal+5; % so the numbers are not on top of each other by adding 5
%Places the text on the graph
for i=1:15
    text(x(i),ypercent(i),y1(i),'VerticalAlignment','bottom',...
        'HorizontalAlignment','center','FontSize',13);
    text(x(i),ytotal(i),y2(i),'VerticalAlignment','bottom',...
        'HorizontalAlignment','center','FontSize',13);
end
end