% motion tuning curve

files = {
    'Output/Mot_090614_FBAA2_0.mat';
    'Output/Mot_100614_FBAA2_0.mat';
    'Output/Mot_110614_FBAA2_0.mat';
    'Output/Mot_120614_FBAA2_0.mat';
    'Output/Mot_130614_FBAA2_0.mat';
    'Output/Mot_160614_FBAA2_0.mat';
    'Output/Mot_080714_FBAA2_0.mat';
    'Output/Mot_090714_FBAA2_0.mat';
    'Output/Mot_100714_FBAA2_0.mat';
    'Output/Mot_110714_FBAA2_0.mat';};

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

figure(3);
plot(x,y,'b');
xlabel('Frequency')
ylabel('correct')
title('FBAA2')
hold on 

legend('.083 cpd');
numSessions083
numTrials083