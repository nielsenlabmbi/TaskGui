files = {
    
%%% FOR FBAA0, ACUITY AT HALFWAY MARK
'Ori_180314_FBAA0_0.mat';
'Ori_190314_FBAA0_0.mat';
'Ori_200314_FBAA0_0.mat';
'Ori_210314_FBAA0_0.mat';
'Ori_240314_FBAA0_0.mat';
'Ori_250314_FBAA0_0.mat';
'Ori_260314_FBAA0_0.mat';
'Ori_270314_FBAA0_0.mat';
'Ori_280314_FBAA0_0.mat';};
subject = 'FBAA0';
f=1;
    
%%% FOR FBAA1, ACUITY AT HALFWAY MARK
% 'Ori_260214_FBAA1_0.mat';
% 'Ori_270214_FBAA1_0.mat';
% 'Ori_280214_FBAA1_0.mat';
% 'Ori_040314_FBAA1_0.mat';
% 'Ori_050314_FBAA1_0.mat';
% 'Ori_060314_FBAA1_0.mat';
% 'Ori_070314_FBAA1_0.mat';
% 'Ori_100314_FBAA1_1.mat'; %%Initial file was combined with begining of FBAA2 but I separated the file so we can use this data.  
% 'Ori_110314_FBAA1_0.mat';
% 'Ori_120314_FBAA1_0.mat';
% 'Ori_130314_FBAA1_0.mat';
% 'Ori_140314_FBAA1_0.mat';
% 'Ori_170314_FBAA1_0.mat';
% 'Ori_180314_FBAA1_0.mat';
% 'Ori_190314_FBAA1_0.mat';
% 'Ori_200314_FBAA1_0.mat';
% 'Ori_200314_FBAA1_0.mat'};
% subject = 'FBAA1';
% f = 2;


% %% FOR FBAA2, ACUITY AT HALFWAY MARK
% 'Ori_110214_FBAA2_0.mat'; %% 57% %%
% 'Ori_120214_FBAA2_0.mat';
% 'Ori_130214_FBAA2_0.mat';
% 'Ori_140214_FBAA2_0.mat';
% 'Ori_170214_FBAA2_0.mat'; %% BIAS %%
% 'Ori_180214_FBAA2_0.mat';
% 'Ori_190214_FBAA2_0.mat';
% 'Ori_200214_FBAA2_0.mat'; %% BIAS %%
% 'Ori_210214_FBAA2_0.mat'; %% BIAS %%
% 'Ori_240214_FBAA2_0.mat';
% 'Ori_250214_FBAA2_0.mat';
% 'Ori_260214_FBAA2_0.mat'; %% BIAS %%
% 'Ori_270214_FBAA2_0.mat'; %% BIAS %%
% 'Ori_280214_FBAA2_0.mat'; %% BIAS %%
% 'Ori_040314_FBAA2_0.mat';
% 'Ori_050314_FBAA2_0.mat';
% 'Ori_060314_FBAA2_0.mat';
% 'Ori_070314_FBAA2_0.mat';
% 'Ori_100314_FBAA2_0.mat';
% 'Ori_110314_FBAA2_0.mat';
% 'Ori_120314_FBAA2_0.mat';
% 'Ori_130314_FBAA2_0.mat';
% 'Ori_140314_FBAA2_0.mat';
% 'Ori_170314_FBAA2_0.mat'};
% subject = 'FBAA2';
% f = 4;

% %%% FOR FBAA3, ACUITY AT HALFWAY MARK
% 'Ori_100214_FBAA3_0.mat';
% 'Ori_110214_FBAA3_0.mat';
% 'Ori_120214_FBAA3_0.mat'; %% BIAS %%
% 'Ori_130214_FBAA3_0.mat'; %% BIAS %%
% 'Ori_140214_FBAA3_0.mat'; %% BIAS %%
% 'Ori_170214_FBAA3_0.mat'; %% BIAS %%
% 'Ori_180214_FBAA3_0.mat'; %% BIAS %%
% 'Ori_190214_FBAA3_0.mat'; %% 59% %%
% 'Ori_200214_FBAA3_0.mat'; %% BIAS %%
% 'Ori_210214_FBAA3_0.mat';
% 'Ori_240214_FBAA3_0.mat';
% 'Ori_250214_FBAA3_0.mat';
% 'Ori_260214_FBAA3_0.mat';
% 'Ori_270214_FBAA3_0.mat';
% 'Ori_280214_FBAA3_0.mat'; %% BIAS %%
% 'Ori_040314_FBAA3_0.mat';
% 'Ori_050314_FBAA3_0.mat'; 
% 'Ori_060314_FBAA3_0.mat';
% 'Ori_070314_FBAA3_0.mat';
% 'Ori_100314_FBAA3_0.mat';
% 'Ori_110314_FBAA3_0.mat';
% 'Ori_120314_FBAA3_0.mat';
% 'Ori_130314_FBAA3_0.mat'; %% HUGE BIAS %%
% 'Ori_140314_FBAA3_0.mat'; %% HUGE BIAS %%
% 'Ori_170314_FBAA3_0.mat'}; %% BIAS %%
% subject = 'FBAA3';
% f = 5;

E = struct;
E.correct = [];
E.cpd = [];
E.range = [];
E.side = [];

cd Output
for i = 1:length(files)
    file = files{i};
    load(file);
    E.correct = [E.correct;D.correct];
    E.cpd = [E.cpd;D.cpd];
    E.range = [E.range;D.range];
    E.side = [E.side;D.side];
end
cd ..

D = E;

[fc corN allN] = fitData(D,20,f);
ranges = unique(D.range)';
% Add the contrast information to the numbers data
allN = [ranges;allN]; corN = [ranges;corN];
figure(f); title(subject);