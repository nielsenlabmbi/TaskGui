% motion tuning curve

files = {
%     'Output/Mot_300614_FBAA0_0.mat';
%     'Output/Mot_010714_FBAA0_0.mat';
%     'Output/Mot_020714_FBAA0_0.mat';
%     'Output/Mot_030714_FBAA0_0.mat';
%     'Output/Mot_040714_FBAA0_0.mat';
%     'Output/Mot_080714_FBAA0_0.mat';
%     'Output/Mot_090714_FBAA0_0.mat';
%     'Output/Mot_100714_FBAA0_0.mat';
%     'Output/Mot_110714_FBAA0_0.mat';};
      'Output/Mot_240714_FBAA0_0.mat';      %first day of midpoint detection
      'Output/Mot_250714_FBAA0_0.mat';
      'Output/Mot_290714_FBAA0_0.mat';};    
  
E.c = [];
E.tF = [];
numTrials083=zeros(4,2);
for i = 1:length(files)
    load(files{i});
    Frequency=unique(D.tF);
    E.c = [E.c;D.correct];
    E.tF = [E.tF;D.tF];
    r=0;
    for j=Frequency'
        r=r+1;
        numTrials083(r,2)=numTrials083(r,2)+sum(D.tF==j);
    end
end
numTrials083(:,1)=Frequency;
numSessions083=length(files);
x = unique(E.tF);
y = nan(size(x));

for i = 1:length(x)
    y(i) = sum(E.tF == x(i) & E.c)/sum(E.tF == x(i));
%     [a b] = binofit(sum(E.tF == x(i) & E.c),sum(E.tF == x(i)))
end

figure(2);
plot(x,y,'b');
axis([5 60 .45 1])
xlabel('Frequency')
ylabel('correct')
title('FBAA0')
hold on 
%-------------------%---------------------%--------------------%-----------
files = {
    'Output/Mot_300714_FBAA0_0.mat';
    'Output/Mot_310714_FBAA0_0.mat';
    'Output/Mot_010814_FBAA0_0.mat';};  %.125
    
E.c = [];
E.tF = [];
numTrials125=zeros(4,2);
for i = 1:length(files)
    load(files{i});
    Frequency=unique(D.tF);
    E.c = [E.c;D.correct];
    E.tF = [E.tF;D.tF];
    r=0;
    for j=Frequency'
        r=r+1;
        numTrials125(r,2)=numTrials125(r,2)+sum(D.tF==j);
    end
end
numTrials125(:,1)=Frequency;
numSessions125=length(files);
x = unique(E.tF);
y = nan(size(x));

for i = 1:length(x)
    y(i) = sum(E.tF == x(i) & E.c)/sum(E.tF == x(i));
%     [a b] = binofit(sum(E.tF == x(i) & E.c),sum(E.tF == x(i)))
end

plot(x,y,'g')




legend('.083 cpd','.125 cpd');
numSessions083
numTrials083
numSessions125
numTrials125