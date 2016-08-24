
dmy = datestr(now,'ddmmyy');
file = strcat('Output/Ori_',dmy,'_FBAA',num2str(0),'_0.mat');
load(file);
figure(5)
set(figure(5),'Position',[1169 566 560 420]);
plot(D.range(D.cpd == .125),'b'); hold on
plot(D.range(D.cpd == .25),'g'); hold on
plot(D.range(D.cpd == .5),'r'); hold on
plot(D.range(D.cpd == 1),'c'); hold on
title('FBAA0')

dmy = datestr(now,'ddmmyy');
file = strcat('Output/Ori_',dmy,'_FBAA',num2str(1),'_0.mat');
load(file);
figure(1)
set(figure(1),'Position',[46 566 560 420]);
plot(D.range(D.cpd == .125),'b'); hold on
plot(D.range(D.cpd == .25),'g'); hold on
plot(D.range(D.cpd == .5),'r'); hold on
plot(D.range(D.cpd == 1),'c'); hold on
title('FBAA1')

dmy = datestr(now,'ddmmyy');
file = strcat('Output/Ori_',dmy,'_FBAA',num2str(2),'_0.mat');
load(file);
figure(2)
set(figure(2),'Position',[608 566 560 420]);
plot(D.range(D.cpd == .125),'b'); hold on
plot(D.range(D.cpd == .25),'g'); hold on
plot(D.range(D.cpd == .5),'r'); hold on
plot(D.range(D.cpd == 1),'c'); hold on
title('FBAA2')


dmy = datestr(now,'ddmmyy');
file = strcat('Output/Ori_',dmy,'_FBAA',num2str(3),'_0.mat');
load(file);
figure(3)
set(figure(3),'Position',[47 99 560 420]);
plot(D.range(D.cpd == .125),'b'); hold on
plot(D.range(D.cpd == .25),'g'); hold on
plot(D.range(D.cpd == .5),'r'); hold on
plot(D.range(D.cpd == 1),'c'); hold on
title('FBAA3')


dmy = datestr(now,'ddmmyy');
file = strcat('Output/Ori_',dmy,'_FBAA',num2str(4),'_0.mat');
load(file);
figure(4)
set(figure(4),'Position',[608 99 560 420]);
plot(D.range(D.cpd == .125),'b'); hold on
plot(D.range(D.cpd == .25),'g'); hold on
plot(D.range(D.cpd == .5),'r'); hold on
plot(D.range(D.cpd == 1),'c'); hold on
title('FBAA4')


