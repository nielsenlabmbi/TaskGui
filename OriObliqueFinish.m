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
% if P.runtype ==3;
% D.CountCorrect(A.j,1) = A.CountCorrect;
D.offset(A.j,1) = A.offset;
% end
end

% GET SOME STATS
D.numTrials = length(D.side);       % Total number of trials
% D.numR65 = sum(D.angle == 115);
% D.numR25 = sum(D.angle == 155);      
% D.numR63 = sum(D.angle == 117);      
% D.numR27 = sum(D.angle == 153);     
% D.numR61 = sum(D.angle == 119);
% D.numR29 = sum(D.angle == 151);
% D.numR59 = sum(D.angle == 121);
% D.numR31 = sum(D.angle == 149);
% D.numR57 = sum(D.angle == 123);
% D.numR33 = sum(D.angle == 147);
% D.numR55 = sum(D.angle == 125);
% D.numR35 = sum(D.angle == 145);

D.numL65 = sum(D.angle == 65);
D.numL25 = sum(D.angle == 25);      
D.numL63 = sum(D.angle == 63);      
D.numL27 = sum(D.angle == 27);      
D.numL61 = sum(D.angle == 61);
D.numL29 = sum(D.angle == 29);
D.numL59 = sum(D.angle == 59);
D.numL31 = sum(D.angle == 31);
D.numL57 = sum(D.angle == 57);
D.numL33 = sum(D.angle == 33);
D.numL55 = sum(D.angle == 55);
D.numL35 = sum(D.angle == 35);
D.numL53 = sum(D.angle == 53);
D.numL37 = sum(D.angle == 37);


D.numCorrect = sum(D.correct);          % Total number of correct trials
D.fcAll = D.numCorrect/D.numTrials;     % fraction of all trials correct

% D.ncR65 = sum(D.correct & (D.angle == 115));
% D.fcR65 = D.ncR65/D.numR65;
% D.ncR63 = sum(D.correct & (D.angle == 117));
% D.fcR63 = D.ncR63/D.numR63;
% D.ncR61 = sum(D.correct & (D.angle == 119));
% D.fcR61 = D.ncR61/D.numR61;
% D.ncR59 = sum(D.correct & (D.angle == 121));
% D.fcR59 = D.ncR59/D.numR59;
% D.ncR57 = sum(D.correct & (D.angle == 123));
% D.fcR57 = D.ncR57/D.numR57;
% D.ncR55 = sum(D.correct & (D.angle == 125));
% D.fcR55 = D.ncR55/D.numR55;
% D.ncR35 = sum(D.correct & (D.angle == 145));
% D.fcR35 = D.ncR35/D.numR35;
% D.ncR33 = sum(D.correct & (D.angle == 147));
% D.fcR33 = D.ncR33/D.numR33;
% D.ncR31 = sum(D.correct & (D.angle == 149));
% D.fcR31 = D.ncR31/D.numR31;
% D.ncR29 = sum(D.correct & (D.angle == 151));
% D.fcR29 = D.ncR29/D.numR29;
% D.ncR27 = sum(D.correct & (D.angle == 153));
% D.fcR27 = D.ncR27/D.numR27;
% D.ncR25 = sum(D.correct & (D.angle == 155));
% D.fcR25 = D.ncR25/D.numR25;

D.ncL65 = sum(D.correct & (D.angle == 65));
D.fcL65 = D.ncL65/D.numL65;
D.ncL63 = sum(D.correct & (D.angle == 63));
D.fcL63 = D.ncL63/D.numL63;
D.ncL61 = sum(D.correct & (D.angle == 61));
D.fcL61 = D.ncL61/D.numL61;
D.ncL59 = sum(D.correct & (D.angle == 59));
D.fcL59 = D.ncL59/D.numL59;
D.ncL57 = sum(D.correct & (D.angle == 57));
D.fcL57 = D.ncL57/D.numL57;
D.ncL55 = sum(D.correct & (D.angle == 55));
D.fcL55 = D.ncL55/D.numL55;
D.ncL53 = sum(D.correct & (D.angle == 53));
D.fcL53 = D.ncL53/D.numL53;
D.ncL37 = sum(D.correct & (D.angle == 37));
D.fcL37 = D.ncL37/D.numL37;
D.ncL35 = sum(D.correct & (D.angle == 35));
D.fcL35 = D.ncL35/D.numL35;
D.ncL33 = sum(D.correct & (D.angle == 33));
D.fcL33 = D.ncL33/D.numL33;
D.ncL31 = sum(D.correct & (D.angle == 31));
D.fcL31 = D.ncL31/D.numL31;
D.ncL29 = sum(D.correct & (D.angle == 29));
D.fcL29 = D.ncL29/D.numL29;
D.ncL27 = sum(D.correct & (D.angle == 27));
D.fcL27 = D.ncL27/D.numL27;
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
% 
% if ~isnan(D.side(D.angle == 155))
%     bar(2,100*D.fcR25,'FaceColor',colors(mean(D.side(D.angle==155)),:));    %plots percentage of left data correct
% else bar(2,100*D.fcR25,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% if ~isnan(D.side(D.angle == 115))
% bar(3,100*D.fcR65,'FaceColor',colors(mean(D.side(D.angle==115)),:));    %plots percentage of left data correct
% else bar(3,100*D.fcR65,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% 
% if ~isnan(D.side(D.angle == 153))
%     bar(4,100*D.fcR27,'FaceColor',colors(mean(D.side(D.angle==153)),:));    %plots percentage of left data correct
% else bar(4,100*D.fcR27,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% if ~isnan(D.side(D.angle == 117))
% bar(5,100*D.fcR63,'FaceColor',colors(mean(D.side(D.angle==117)),:));    %plots percentage of left data correct
% else bar(5,100*D.fcR63,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% 
% if ~isnan(D.side(D.angle == 151))
%     bar(6,100*D.fcR29,'FaceColor',colors(mean(D.side(D.angle==151)),:));    %plots percentage of left data correct
% else bar(6,100*D.fcR29,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% if ~isnan(D.side(D.angle == 119))
% bar(7,100*D.fcR61,'FaceColor',colors(mean(D.side(D.angle==119)),:));    %plots percentage of left data correct
% else bar(7,100*D.fcR61,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% 
% if ~isnan(D.side(D.angle == 149))
%     bar(8,100*D.fcR31,'FaceColor',colors(mean(D.side(D.angle==149)),:));    %plots percentage of left data correct
% else bar(8,100*D.fcR31,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% if ~isnan(D.side(D.angle == 121))
% bar(9,100*D.fcR59,'FaceColor',colors(mean(D.side(D.angle==121)),:));    %plots percentage of left data correct
% else bar(9,100*D.fcR59,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% 
% if ~isnan(D.side(D.angle == 147))
%     bar(10,100*D.fcR33,'FaceColor',colors(mean(D.side(D.angle==147)),:));    %plots percentage of left data correct
% else bar(10,100*D.fcR33,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% if ~isnan(D.side(D.angle == 123))
% bar(11,100*D.fcR57,'FaceColor',colors(mean(D.side(D.angle==123)),:));    %plots percentage of left data correct
% else bar(11,100*D.fcR57,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% 
% if ~isnan(D.side(D.angle == 145))
%     bar(12,100*D.fcR35,'FaceColor',colors(mean(D.side(D.angle==145)),:));    %plots percentage of left data correct
% else bar(12,100*D.fcR35,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
% if ~isnan(D.side(D.angle == 125))
% bar(13,100*D.fcR55,'FaceColor',colors(mean(D.side(D.angle==125)),:));    %plots percentage of left data correct
% else bar(13,100*D.fcR55,'FaceColor',[1 0 0]);    %plots percentage of left data correct
% end
if ~isnan(D.side(D.angle == 25))
    bar(2,100*D.fcL25,'FaceColor',colors(mean(D.side(D.angle==25)),:));    %plots percentage of left data correct
else bar(2,100*D.fcL25,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end
if ~isnan(D.side(D.angle == 65))
bar(3,100*D.fcL65,'FaceColor',colors(mean(D.side(D.angle==65)),:));    %plots percentage of left data correct
else bar(3,100*D.fcL65,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end

if ~isnan(D.side(D.angle == 27))
    bar(4,100*D.fcL27,'FaceColor',colors(mean(D.side(D.angle==27)),:));    %plots percentage of left data correct
else bar(4,100*D.fcL27,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end
if ~isnan(D.side(D.angle == 63))
bar(5,100*D.fcL63,'FaceColor',colors(mean(D.side(D.angle==63)),:));    %plots percentage of left data correct
else bar(5,100*D.fcL63,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end

if ~isnan(D.side(D.angle == 29))
    bar(6,100*D.fcL29,'FaceColor',colors(mean(D.side(D.angle==29)),:));    %plots percentage of left data correct
else bar(6,100*D.fcL29,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end
if ~isnan(D.side(D.angle == 61))
bar(7,100*D.fcL61,'FaceColor',colors(mean(D.side(D.angle==61)),:));    %plots percentage of left data correct
else bar(7,100*D.fcL61,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end

if ~isnan(D.side(D.angle == 31))
    bar(8,100*D.fcL31,'FaceColor',colors(mean(D.side(D.angle==31)),:));    %plots percentage of left data correct
else bar(8,100*D.fcL31,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end
if ~isnan(D.side(D.angle == 59))
bar(9,100*D.fcL59,'FaceColor',colors(mean(D.side(D.angle==59)),:));    %plots percentage of left data correct
else bar(9,100*D.fcL59,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end

if ~isnan(D.side(D.angle == 33))
    bar(10,100*D.fcL33,'FaceColor',colors(mean(D.side(D.angle==33)),:));    %plots percentage of left data correct
else bar(10,100*D.fcL33,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end
if ~isnan(D.side(D.angle == 57))
bar(11,100*D.fcL57,'FaceColor',colors(mean(D.side(D.angle==57)),:));    %plots percentage of left data correct
else bar(11,100*D.fcL57,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end

if ~isnan(D.side(D.angle == 35))
    bar(12,100*D.fcL35,'FaceColor',colors(mean(D.side(D.angle==35)),:));    %plots percentage of left data correct
else bar(12,100*D.fcL35,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end
if ~isnan(D.side(D.angle == 55))
bar(13,100*D.fcL55,'FaceColor',colors(mean(D.side(D.angle==55)),:));    %plots percentage of left data correct
else bar(13,100*D.fcL55,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end

if ~isnan(D.side(D.angle == 37))
    bar(14,100*D.fcL37,'FaceColor',colors(mean(D.side(D.angle==37)),:));    %plots percentage of left data correct
else bar(14,100*D.fcL37,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end
if ~isnan(D.side(D.angle == 53))
bar(15,100*D.fcL53,'FaceColor',colors(mean(D.side(D.angle==53)),:));    %plots percentage of left data correct
else bar(15,100*D.fcL53,'FaceColor',[1 0 0]);    %plots percentage of left data correct
end

    %AXIS SETTIGNS
axis([.5 15.5 0 110.5]); %sets the x axis min and max and y axis min and max
%X AXIS
set(gca(1),'XTick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]) %Changes the graph to have three x axis labels instead of the default 1
% set(gca(1),'XTickLabel', {'All' 'L-20' 'R+20' 'L-18' 'R+18' 'L-16' 'R+16' 'L-14' 'R+14' 'L-12' 'R+12' 'L-10' 'R+10'}); %Then labels the three bars.
set(gca(1),'XTickLabel', {'All' 'R-20' 'L+20' 'R-18' 'L+18' 'R-16' 'L+16' 'R-14' 'L+14' 'R-12' 'L+12' 'R-10' 'L+10' 'R-8' 'L+8'}); %Then labels the three bars.

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
% rndPercentLR=strcat({num2str(round(100*D.fcAll))},'%'); 
% rndPercentR25=strcat({num2str(round(100*D.fcR25))},'%');
% rndPercentR65=strcat({num2str(round(100*D.fcR65))},'%');
% rndPercentR27=strcat({num2str(round(100*D.fcR27))},'%');
% rndPercentR63=strcat({num2str(round(100*D.fcR63))},'%');
% rndPercentR29=strcat({num2str(round(100*D.fcR29))},'%');
% rndPercentR61=strcat({num2str(round(100*D.fcR61))},'%');
% rndPercentR31=strcat({num2str(round(100*D.fcR31))},'%');
% rndPercentR59=strcat({num2str(round(100*D.fcR59))},'%');
% rndPercentR33=strcat({num2str(round(100*D.fcR33))},'%');
% rndPercentR57=strcat({num2str(round(100*D.fcR57))},'%');
% rndPercentR35=strcat({num2str(round(100*D.fcR35))},'%');
% rndPercentR55=strcat({num2str(round(100*D.fcR55))},'%');
rndPercentLR=strcat({num2str(round(100*D.fcAll))},'%'); 
rndPercentL25=strcat({num2str(round(100*D.fcL25))},'%');
rndPercentL65=strcat({num2str(round(100*D.fcL65))},'%');
rndPercentL27=strcat({num2str(round(100*D.fcL27))},'%');
rndPercentL63=strcat({num2str(round(100*D.fcL63))},'%');
rndPercentL29=strcat({num2str(round(100*D.fcL29))},'%');
rndPercentL61=strcat({num2str(round(100*D.fcL61))},'%');
rndPercentL31=strcat({num2str(round(100*D.fcL31))},'%');
rndPercentL59=strcat({num2str(round(100*D.fcL59))},'%');
rndPercentL33=strcat({num2str(round(100*D.fcL33))},'%');
rndPercentL57=strcat({num2str(round(100*D.fcL57))},'%');
rndPercentL35=strcat({num2str(round(100*D.fcL35))},'%');
rndPercentL55=strcat({num2str(round(100*D.fcL55))},'%');
rndPercentL37=strcat({num2str(round(100*D.fcL37))},'%');
rndPercentL53=strcat({num2str(round(100*D.fcL53))},'%');

% y1=[rndPercentLR rndPercentR25 rndPercentR65 rndPercentR27 rndPercentR63 rndPercentR29 rndPercentR61 rndPercentR31 rndPercentR59 rndPercentR33 rndPercentR57 rndPercentR35 rndPercentR55]; %Used as the percentage text being displayed on graph
y1=[rndPercentLR rndPercentL25 rndPercentL65 rndPercentL27 rndPercentL63 rndPercentL29 rndPercentL61 rndPercentL31 rndPercentL59 rndPercentL33 rndPercentL57 rndPercentL35 rndPercentL55 rndPercentL37 rndPercentL53]; %Used as the percentage text being displayed on graph


%Gets the TotalX from above converts number into string and adds N= at the beginning
% rndTotalLR=strcat('N=',{num2str(D.numTrials)});
% rndTotalR25=strcat('N=',{num2str(D.numR25)});
% rndTotalR65=strcat('N=',{num2str(D.numR65)});
% rndTotalR27=strcat('N=',{num2str(D.numR27)});
% rndTotalR63=strcat('N=',{num2str(D.numR63)});
% rndTotalR29=strcat('N=',{num2str(D.numR29)});
% rndTotalR61=strcat('N=',{num2str(D.numR61)});
% rndTotalR31=strcat('N=',{num2str(D.numR31)});
% rndTotalR59=strcat('N=',{num2str(D.numR59)});
% rndTotalR33=strcat('N=',{num2str(D.numR33)});
% rndTotalR57=strcat('N=',{num2str(D.numR57)});
% rndTotalR35=strcat('N=',{num2str(D.numR35)});
% rndTotalR55=strcat('N=',{num2str(D.numR55)});

rndTotalLR=strcat('N=',{num2str(D.numTrials)});
rndTotalL25=strcat('N=',{num2str(D.numL25)});
rndTotalL65=strcat('N=',{num2str(D.numL65)});
rndTotalL27=strcat('N=',{num2str(D.numL27)});
rndTotalL63=strcat('N=',{num2str(D.numL63)});
rndTotalL29=strcat('N=',{num2str(D.numL29)});
rndTotalL61=strcat('N=',{num2str(D.numL61)});
rndTotalL31=strcat('N=',{num2str(D.numL31)});
rndTotalL59=strcat('N=',{num2str(D.numL59)});
rndTotalL33=strcat('N=',{num2str(D.numL33)});
rndTotalL57=strcat('N=',{num2str(D.numL57)});
rndTotalL35=strcat('N=',{num2str(D.numL35)});
rndTotalL55=strcat('N=',{num2str(D.numL55)});
rndTotalL37=strcat('N=',{num2str(D.numL37)});
rndTotalL53=strcat('N=',{num2str(D.numL53)});

% y2=[rndTotalLR rndTotalR25 rndTotalR65 rndTotalR27 rndTotalR63 rndTotalR29 rndTotalR61 rndTotalR31 rndTotalR59 rndTotalR33 rndTotalR57 rndTotalR35 rndTotalR55]; %Used as the total text being displayed on graph \
y2=[rndTotalLR rndTotalL25 rndTotalL65 rndTotalL27 rndTotalL63 rndTotalL29 rndTotalL61 rndTotalL31 rndTotalL59 rndTotalL33 rndTotalL57 rndTotalL35 rndTotalL55 rndTotalL37 rndTotalL53]; %Used as the total text being displayed on graph \
ytotal=99.5*ones(size(y2)); %sets y axis position for where the text will be shown
x=1:length(y2); %sets x axis postion for where the text will be displayed;
ypercent=ytotal+5; % so the numbers are not on top of each other by adding 5
%Places the text on the graph
for i=1:length(y2)
    text(x(i),ypercent(i),y1(i),'VerticalAlignment','bottom',...
        'HorizontalAlignment','center','FontSize',13);
    text(x(i),ytotal(i),y2(i),'VerticalAlignment','bottom',...
        'HorizontalAlignment','center','FontSize',13);
end
end