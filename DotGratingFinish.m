function D = DotGratingFinish(D,A)

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
%D.dotCoherence(A.j,1) = A.dotCoherence;
D.ori(A.j,1) = A.ori;
%D.deltaDot(A.j,1) = A.deltaDot;
D.startTime(A.j,1) = A.startTime;       % Matlab time ferret started the trial
D.startTimeDP(A.j,1) = A.startTimeDP;   % Datapixx time ferret started the trial
D.choiceTime(A.j,1) = A.choiceTime;
D.responseTime(A.j,1) = A.responseTime; % Matlab time ferret made its first response
D.frameTime{A.j}=A.frameTime;
end

% GET SOME STATS
D.numTrials = length(D.side);       % Total number of trials
D.numCorrect = sum(D.correct);          % Total number of correct trials
D.fcAll = D.numCorrect/D.numTrials;     % fraction of all trials correct

cohLevel=1;

for i=1:length(cohLevel)
    %idxR = find(D.dotCoherence==cohLevel(i) & D.side==1);
    %idxL = find(D.dotCoherence==cohLevel(i) & D.side==2);
    idxR = find(D.side==1);
    idxL = find(D.side==2);
    
    
    D.fcRight(i) = sum(D.correct(idxR))/length(idxR);
    D.fcLeft(i) = sum(D.correct(idxL))/length(idxL);
    
end


% PLOT PERFORMANCE
% Opening figure 1 to plot performance, and clearing any existant plots
figure(1); clf(1);
set(figure(1),'Position',[165 110 530 420]);
hold on;        %holds onto the plot
bar(1,100*D.fcAll,'FaceColor',[.75 0 .75]); %plots percentage of all data correct

for i=1:length(cohLevel)
   bar(i*2,100*D.fcLeft(i),'FaceColor',[0 0 1]);   %plots percentage of right data correct
   bar((i*2+1),100*D.fcRight(i),'FaceColor',[1 0 0]);    %plots percentage of left data correct
end

%AXIS SETTIGNS
axis([.5 length(cohLevel)*2+1.5 0 110.5]); %sets the x axis min and max and y axis min and max
%X AXIS
set(gca(1),'XTick',[1:2*length(cohLevel)+1]) %Changes the graph to have three x axis labels instead of the default 1
set(gca(1),'XTickLabel', {'All Trials' 'L1' 'R1'}); 
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
y1=rndPercentLR; %Used as the percentage text being displayed on graph
rndTotalLR=strcat('N=',{num2str(D.numTrials)});
y2=rndTotalLR; %Used as the total text being displayed on graph \
ytotal=99.5; %sets y axis position for where the text will be shown
x=1; %sets x axis postion for where the text will be displayed;
ypercent=ytotal+5; % so the numbers are not on top of each other by adding 5
%Places the text on the graph
text(x,ypercent,y1,'VerticalAlignment','bottom',...
        'HorizontalAlignment','center','FontSize',13);
    text(x,ytotal,y2,'VerticalAlignment','bottom',...
        'HorizontalAlignment','center','FontSize',13);

end