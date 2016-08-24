function [A P] = PlaidNext(S,P,A)

% function [A P] = PlaidNext(S,P,A)
%
% This function performs tasks required before the start of each trial 
% such as generating stimulus related variables or setting up data 
% acquisition schedules.
%
% Any sub-functions used to generate stimuli should be located within this 
% function!
%
% THINKING IN TERMS OF LOOPS LOGIC, THE MAIN REASON FOR RUNNING THIS IS TO
% CONVERT ALL PARAMETERS, AND SETTINGS THAT DEFINE THE SCOPE OF PARAMETERS,
%
% Created by: Kristina Nielsen       Last modified: 130215

% LAST TRIAL TYPE, 0 random, 1 pseudorandom
% If new output file
% GET STIMULUS SIDE AND BACKGROUND LINE COLOR
if A.newOutput
    A.newOutput = 0;
    A.listIndex = 0;
end

% GET STIMULUS PROPERTIES

% If list has finished start, start a new list
if ~A.listIndex
    A.listPerm = randperm(size(S.trialsList,1));
end
% Get stimulus side and grating type to play from trials list
A.side = S.trialsList(A.listPerm(A.listIndex+1),1);
A.plaid = S.trialsList(A.listPerm(A.listIndex+1),2);
A.cpd = S.cpd;
A.tF = S.tF;
A.range = S.range;
% Update index
A.listIndex = mod(A.listIndex+1,size(S.trialsList,1));



end