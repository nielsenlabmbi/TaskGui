%-------------------------PERFORMANCE PERCENTAGE---------------------------


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
figure(1);
set(figure(1),'OuterPosition',[10 558 560 500]);   %Sets the position of the figure
hold on;        %holds onto the plot
bar(1,D.pcAll,'g');     %plots percentage of all data correct
bar(2,D.pcLeft,'b');   %plots percentage of right data correct   
bar(3,D.pcRight,'m');    %plots percentage of left data correct
axis([.5 3.5 0 110.5]); %sets the x axis min and max and y axis min and max
set(gca(1),'XTick',[1 2 3]) %Changes the graph to have three x axis labels instead of the default 1
set(gca(1),'XTickLabel', {'All Trials' 'Left Trials' 'Right Trials'}); %Then labels the three bars.
set(gca(1),'YTick',[0 10 20 30 40 50 60 70 80 90 100]) %labels the major tic marks
ylabel('Correct Trial Percentage');   %Labels the axis
title('percentage correct'); %Sets the title of the graph and the font size
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