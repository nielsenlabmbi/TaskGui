% motion tuning curve

files = {
%     'Output/Mot_090614_FBAA4_0.mat';
%     'Output/Mot_100614_FBAA4_0.mat';
%     'Output/Mot_110614_FBAA4_0.mat';
%     'Output/Mot_120614_FBAA4_0.mat';
%     'Output/Mot_130614_FBAA4_0.mat';
%     'Output/Mot_160614_FBAA4_0.mat';
    'Output/Mot_170614_FBAA4_0.mat';        % Started with stim off at midpoint here
    'Output/Mot_180614_FBAA4_0.mat';
    'Output/Mot_190614_FBAA4_0.mat';
    'Output/Mot_200614_FBAA4_0.mat';
    'Output/Mot_300614_FBAA4_0.mat';
    'Output/Mot_010714_FBAA4_0.mat';
    'Output/Mot_020714_FBAA4_0.mat';
    'Output/Mot_030714_FBAA4_0.mat';
    'Output/Mot_040714_FBAA4_0.mat';
    };
    

E.c = [];
E.tF = [];

for i = 1:length(files)
    load(files{i});
    E.c = [E.c;D.correct];
    E.tF = [E.tF;D.tF];
end


x = unique(E.tF);
y = nan(size(x));

for i = 1:length(x)
    y(i) = sum(E.tF == x(i) & E.c)/sum(E.tF == x(i));
%     [a b] = binofit(sum(E.tF == x(i) & E.c),sum(E.tF == x(i)))
end

figure(1);
plot(x,y);

