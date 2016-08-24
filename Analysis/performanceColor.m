function performanceColor(D,f)

%get the total number of trials for specific color
%find how many correct for each color
uniqueColors=unique(D.lineColor);
total=zeros(255,1);
correct=zeros(255,1);
for i=1:length(D.firstTry)
for h=uniqueColors'
    if D.lineColor(i)==h & D.firstTry(i)==1
        correct(h)=correct(h)+1;
    end
    total(h)=sum(D.lineColor==h);
end
end
percCorrect=(correct./total)*100;
xvalue=1:255;

figure(f)
scatter(xvalue,percCorrect,'r','Filled');  %plots all recordings for both ferrets on top graph
axis([0 255 0 100]);                 %axis for top plot
xlabel('Distractor Color')
ylabel('percent Correct')  %labels y axis
hold on
x=uniqueColors';
num=0;
%Places the text on the graph
for i=uniqueColors';
    num=num+1;
    y1=strcat({num2str(round(percCorrect(i)))},'%');    %creates string of percent correct
    y2=strcat('N=',{num2str(total(i))});                %creates string of total number of trials
    ypercent=percCorrect(i)+5;                          %creates y axis coordinate for percent
    ytotal=ypercent-4;                                  %creates y axis coordinate for total
    text(x(num),ypercent,y1,'VerticalAlignment','bottom',...
        'HorizontalAlignment','center','FontSize',11);
    text(x(num),ytotal,y2,'VerticalAlignment','bottom',...
        'HorizontalAlignment','center','FontSize',11);
end

end