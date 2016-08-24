function [fc corN allN] = fitData(D,minN,f)

if ~nargin
    error('Requires data input!');
end

if nargin < 3
    f = 1;
end

if ~exist('minN','var')
    minN = 1;
end

% IF D IS A NUMBER TRY LOADING TODAY'S DATA FROM THE CORRESPONDING SUBJECT
if isnumeric(D)
    dmy = datestr(now,'ddmmyy');
    file = strcat('Output/Acuity_',dmy,'_FBAA',num2str(D),'_0.mat');
    load(file);
end

% IF D IS A STRING, ASSUME IT IS A FILE
if ischar(D)
    load(D);
end

% AT THIS POINT ASSUME D IS NOW A DATA STRUCTURE AND PROCEED

% Get unique c/deg and luminance range (in 16bit color values)
cpds = sort(unique(D.cpd));
ranges = sort(unique(D.range));
cpdN = length(cpds);
rangeN = length(ranges);

% CREATE STRUCTURES TO HOLD FINAL VALUES
fc = zeros(cpdN,rangeN);    % fraction correct
corN = fc;                  % number of correct responses
allN = fc;                  % number of trials

for i = 1:cpdN
    cpd = cpds(i);
    for j = 1:rangeN
        ran = ranges(j);
        
        allN(i,j) = sum(D.cpd == cpd & D.range == ran);
        corN(i,j) = sum(D.correct & D.cpd == cpd & D.range == ran);
    end
end
fc = corN./allN;
% This next command uses data only if enough trials have been collected
%fc(allN<minN) = NaN;

% Set up search grid -- p0 are a range of values to try as the initial
% parameter set to do a best parameter search on
p0.alpha = 0:0.002:1;
p0.beta = logspace(-1,3,500);
p0.gamma = 0.5;

% Which parameters are free? No signal strength should be chance
% performance -- this assumption needs to be examined
freeParam = [1 1 0 1];

% Run Fit -- other functions: PAL_Weibull, PAL_Logistic, PAL_Gumbel,
%                               PAL_CumulativeNormal, PAL_HyperbolicSecant
for i = 1:cpdN
    p0.lambda = floor(100-max(fc(i,:))*100)/100;
%     p0.lambda = floor(100-max(max(fc))*100)/100;
    p1(i,:) = PAL_PFML_Fit(ranges',corN(i,:),allN(i,:),p0,freeParam,@PAL_Weibull);
end

% PLOT
x = 0:1:127;
figure(f); clf; hold on; axis([0 130 0 101]);
colors = 'bgrcmy';
legstr = cell(1,2*cpdN); j = 1;
for i = 1:cpdN
    scatter(ranges',100*fc(i,:),strcat('o',colors(i)),'filled');
    y = 100*PAL_Weibull(p1(i,:),x);
    plot(x,y,colors(i));
    legstr{j} = num2str(cpds(i));
    legstr{j+1} = '';
    j = j+2;
end
legend(gca,'Location','SouthEast',legstr);
line([0 127],[75 75],'LineStyle','--','Color','k');
end


% % PAL_PFML_BootstrapNonParametric
% [SD paramsSim LLSim converged] = PAL_PFML_BootstrapNonParametric(...
%         X,YN,N,[],freeParam,500,@PAL_Weibull,...
%         'searchGrid',p0,'lapseLimits',[ceil(100*Y(1))/100 1]);
% 
% % If I want to plot the bounds of the function at this point, I need to run
% % the function (PAL_Weibull) at all parameters, then take the 95%
% % confidence intervals on each value.
% ys = nan(500,100);
% for i = 1:500
%     ys(i,:) = PAL_Weibull(paramsSim(i,:),x);
% end
% for i = 1:100
%     ys(:,i) = sort(ys(:,i));
% end
% 
% lb = ys(round(.025*500),:); ub = ys(round(.975*500),:);
% plot(x,lb,'r'); plot(x,ub,'r');