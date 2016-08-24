function D = OriObliqueFinish(D,A)

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
D.numR65 = sum(D.angle == 115);
D.numR25 = sum(D.angle == 155);      
D.numR62 = sum(D.angle == 118);      
D.numR28 = sum(D.angle == 152);
D.numR59 = sum(D.angle == 121);
D.numR31 = sum(D.angle == 149);
D.numR56 = sum(D.angle == 124);
D.numR34 = sum(D.angle == 146);
D.numR50 = sum(D.angle == 130);
D.numR40 = sum(D.angle == 140);

D.numL65 = sum(D.angle == 65);
D.numL25 = sum(D.angle == 25);      
D.numL62 = sum(D.angle == 62);      
D.numL28 = sum(D.angle == 28);      
D.numL59 = sum(D.angle == 59);
D.numL31 = sum(D.angle == 31);
D.numL56 = sum(D.angle == 56);
D.numL34 = sum(D.angle == 34);
D.numL50 = sum(D.angle == 50);
D.numL40 = sum(D.angle == 40);

D.numCorrect = sum(D.correct);          % Total number of correct trials
D.fcAll = D.numCorrect/D.numTrials;     % fraction of all trials correct

D.ncR65 = sum(D.correct & (D.angle == 115));
D.fcR65 = D.ncR65/D.numR65;
D.ncL65 = sum(D.correct & (D.angle == 65));
D.fcL65 = D.ncL65/D.numL65;

D.ncR62 = sum(D.correct & (D.angle == 118));
D.fcR62 = D.ncR62/D.numR62;
D.ncL62 = sum(D.correct & (D.angle == 62));
D.fcL62 = D.ncL62/D.numL62;

D.ncR59 = sum(D.correct & (D.angle == 121));
D.fcR59 = D.ncR59/D.numR59;
D.ncL59 = sum(D.correct & (D.angle == 59));
D.fcL59 = D.ncL59/D.numL59;

D.ncR56 = sum(D.correct & (D.angle == 124));
D.fcR56 = D.ncR56/D.numR56;
D.ncL56 = sum(D.correct & (D.angle == 56));
D.fcL56 = D.ncL56/D.numL56;

D.ncR50 = sum(D.correct & (D.angle == 130));
D.fcR50 = D.ncR50/D.numR50;
D.ncL50 = sum(D.correct & (D.angle == 50));
D.fcL50 = D.ncL50/D.numL50;

D.ncR40 = sum(D.correct & (D.angle == 140));
D.fcR40 = D.ncR40/D.numR40;
D.ncL40 = sum(D.correct & (D.angle == 40));
D.fcL40 = D.ncL40/D.numL40;

D.ncR34 = sum(D.correct & (D.angle == 146));
D.fcR34 = D.ncR34/D.numR34;
D.ncL34 = sum(D.correct & (D.angle == 34));
D.fcL34 = D.ncL34/D.numL34;

D.ncR31 = sum(D.correct & (D.angle == 149));
D.fcR31 = D.ncR31/D.numR31;
D.ncL31 = sum(D.correct & (D.angle == 31));
D.fcL31 = D.ncL31/D.numL31;

D.ncR28 = sum(D.correct & (D.angle == 152));
D.fcR28 = D.ncR28/D.numR28;
D.ncL28 = sum(D.correct & (D.angle == 28));
D.fcL28 = D.ncL28/D.numL28;

D.ncR25 = sum(D.correct & (D.angle == 155));
D.fcR25 = D.ncR25/D.numR25;
D.ncL25 = sum(D.correct & (D.angle == 25));
D.fcL25 = D.ncL25/D.numL25;


D.fcAll = D.numCorrect/D.numTrials;     % fraction of all trials correct

% PLOT PERFORMANCE
% Opening figure 1 to plot performance, and clearing any existant plots
colors = [1 0 0; 0 0 1];
figure(1); clf(1);
set(figure(1),'Position',[50 110 800 420]);
hold on;        %holds onto the plot
bar(1,100*D.fcAll,'FaceColor',[.75 0 .75]); %plots percentage of all data correct

if ~isnan(D.side(D.angle == 155))
    bar(2,100*D.fcR25,'FaceColor',colors(mean(D.side(D.angle==155)),:));    %plots percentage of left data correct
else bar(2,100*D.fcR25,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end
if ~isnan(D.side(D.angle == 115))
bar(3,100*D.fcR65,'FaceColor',colors(mean(D.side(D.angle==115)),:));    %plots percentage of left data correct
else bar(3,100*D.fcR65,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end

if ~isnan(D.side(D.angle == 152))
    bar(4,100*D.fcR28,'FaceColor',colors(mean(D.side(D.angle==152)),:));    %plots percentage of left data correct
else bar(4,100*D.fcR28,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end
if ~isnan(D.side(D.angle == 118))
bar(5,100*D.fcR62,'FaceColor',colors(mean(D.side(D.angle==118)),:));    %plots percentage of left data correct
else bar(5,100*D.fcR62,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end

if ~isnan(D.side(D.angle == 149))
    bar(6,100*D.fcR31,'FaceColor',colors(mean(D.side(D.angle==149)),:));    %plots percentage of left data correct
else bar(6,100*D.fcR31,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end
if ~isnan(D.side(D.angle == 121))
bar(7,100*D.fcR59,'FaceColor',colors(mean(D.side(D.angle==121)),:));    %plots percentage of left data correct
else bar(7,100*D.fcR59,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end

if ~isnan(D.side(D.angle == 146))
    bar(8,100*D.fcR34,'FaceColor',colors(mean(D.side(D.angle==146)),:));    %plots percentage of left data correct
else bar(8,100*D.fcR34,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end
if ~isnan(D.side(D.angle == 124))
bar(9,100*D.fcR56,'FaceColor',colors(mean(D.side(D.angle==124)),:));    %plots percentage of left data correct
else bar(9,100*D.fcR56,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end

if ~isnan(D.side(D.angle == 140))
    bar(10,100*D.fcR40,'FaceColor',colors(mean(D.side(D.angle==140)),:));    %plots percentage of left data correct
else bar(10,100*D.fcR40,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end
if ~isnan(D.side(D.angle == 130))
bar(11,100*D.fcR50,'FaceColor',colors(mean(D.side(D.angle==130)),:));    %plots percentage of left data correct
else bar(11,100*D.fcR50,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end
% if ~isnan(D.side(D.angle == 25))
%     bar(2,100*D.fcL25,'FaceColor',colors(mean(D.side(D.angle==25)),:));    %plots percentage of left data correct
% else bar(2,100*D.fcL25,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% if ~isnan(D.side(D.angle == 65))
% bar(3,100*D.fcL65,'FaceColor',colors(mean(D.side(D.angle==65)),:));    %plots percentage of left data correct
% else bar(3,100*D.fcL65,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% 
% if ~isnan(D.side(D.angle == 28))
%     bar(4,100*D.fcL28,'FaceColor',colors(mean(D.side(D.angle==28)),:));    %plots percentage of left data correct
% else bar(4,100*D.fcL28,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% if ~isnan(D.side(D.angle == 62))
% bar(5,100*D.fcL62,'FaceColor',colors(mean(D.side(D.angle==62)),:));    %plots percentage of left data correct
% else bar(5,100*D.fcR62,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% 
% if ~isnan(D.side(D.angle == 31))
%     bar(6,100*D.fcL31,'FaceColor',colors(mean(D.side(D.angle==31)),:));    %plots percentage of left data correct
% else bar(6,100*D.fcL31,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% if ~isnan(D.side(D.angle == 59))
% bar(7,100*D.fcL59,'FaceColor',colors(mean(D.side(D.angle==59)),:));    %plots percentage of left data correct
% else bar(7,100*D.fcL59,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% 
% if ~isnan(D.side(D.angle == 34))
%     bar(8,100*D.fcL34,'FaceColor',colors(mean(D.side(D.angle==34)),:));    %plots percentage of left data correct
% else bar(8,100*D.fcL34,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% if ~isnan(D.side(D.angle == 56))
% bar(9,100*D.fcL56,'FaceColor',colors(mean(D.side(D.angle==56)),:));    %plots percentage of left data correct
% else bar(9,100*D.fcL56,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end


    %AXIS SETTIGNS
axis([.5 11.5 0 110.5]); %sets the x axis min and max and y axis min and max
%X AXIS
set(gca(1),'XTick',[1 2 3 4 5 6 7 8 9 10 11]) %Changes the graph to have three x axis labels instead of the default 1
set(gca(1),'XTickLabel', {'All' 'L(-20)' 'R(+20)' 'L(-17)' 'R(+17)' 'L(-14)' 'R(+14)' 'L(-11)' 'R(+11)' 'L(-5)' 'R(+5)'}); %Then labels the three bars.
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
rndPercentR25=strcat({num2str(round(100*D.fcR25))},'%');
rndPercentR65=strcat({num2str(round(100*D.fcR65))},'%');
rndPercentR28=strcat({num2str(round(100*D.fcR28))},'%');
rndPercentR62=strcat({num2str(round(100*D.fcR62))},'%');
rndPercentR31=strcat({num2str(round(100*D.fcR31))},'%');
rndPercentR59=strcat({num2str(round(100*D.fcR59))},'%');
rndPercentR34=strcat({num2str(round(100*D.fcR34))},'%');
rndPercentR56=strcat({num2str(round(100*D.fcR56))},'%');
rndPercentR40=strcat({num2str(round(100*D.fcR40))},'%');
rndPercentR50=strcat({num2str(round(100*D.fcR50))},'%');
% rndPercentLR=strcat({num2str(round(100*D.fcAll))},'%'); 
% rndPercentL25=strcat({num2str(round(100*D.fcL25))},'%');
% rndPercentL65=strcat({num2str(round(100*D.fcL65))},'%');
% rndPercentL28=strcat({num2str(round(100*D.fcL28))},'%');
% rndPercentL62=strcat({num2str(round(100*D.fcL62))},'%');
% rndPercentL31=strcat({num2str(round(100*D.fcL31))},'%');
% rndPercentL59=strcat({num2str(round(100*D.fcL59))},'%');
% rndPercentL34=strcat({num2str(round(100*D.fcL34))},'%');
% rndPercentL56=strcat({num2str(round(100*D.fcL56))},'%');


y1=[rndPercentLR rndPercentR25 rndPercentR65 rndPercentR28 rndPercentR62 rndPercentR31 rndPercentR59 rndPercentR34 rndPercentR56 rndPercentR40 rndPercentR50]; %Used as the percentage text being displayed on graph
%y1=[rndPercentLR rndPercentL25 rndPercentL65 rndPercentL28 rndPercentL62 rndPercentL31 rndPercentL59 rndPercentL34 rndPercentL56]; %Used as the percentage text being displayed on graph


%Gets the TotalX from above converts number into string and adds N= at the beginning
rndTotalLR=strcat('N=',{num2str(D.numTrials)});
rndTotalR25=strcat('N=',{num2str(D.numR25)});
rndTotalR65=strcat('N=',{num2str(D.numR65)});
rndTotalR28=strcat('N=',{num2str(D.numR28)});
rndTotalR62=strcat('N=',{num2str(D.numR62)});
rndTotalR31=strcat('N=',{num2str(D.numR31)});
rndTotalR59=strcat('N=',{num2str(D.numR59)});
rndTotalR34=strcat('N=',{num2str(D.numR34)});
rndTotalR56=strcat('N=',{num2str(D.numR56)});
rndTotalR40=strcat('N=',{num2str(D.numR40)});
rndTotalR50=strcat('N=',{num2str(D.numR50)});

y2=[rndTotalLR rndTotalR25 rndTotalR65 rndTotalR28 rndTotalR62 rndTotalR31 rndTotalR59 rndTotalR34 rndTotalR56 rndTotalR40 rndTotalR50]; %Used as the total text being displayed on graph \
%y2=[rndTotalLR rndTotalL25 rndTotalL65 rndTotalL28 rndTotalL62 rndTotalL31 rndTotalL59 rndTotalL34 rndTotalL56]; %Used as the total text being displayed on graph \
ytotal=[99.5 99.5 99.5 99.5 99.5 99.5 99.5 99.5 99.5 99.5 99.5]; %sets y axis position for where the text will be shown
x=1:11; %sets x axis postion for where the text will be displayed;
ypercent=ytotal+5; % so the numbers are not on top of each other by adding 5
%Places the text on the graph
for i=1:11
    text(x(i),ypercent(i),y1(i),'VerticalAlignment','bottom',...
        'HorizontalAlignment','center','FontSize',13);
    text(x(i),ytotal(i),y2(i),'VerticalAlignment','bottom',...
        'HorizontalAlignment','center','FontSize',13);
end
end