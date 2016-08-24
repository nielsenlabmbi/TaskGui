function D = HeadFixFinish(D,A)

% function D = HeadFixFinish(D,A)
%
% This function does things necessary to wrap up a trial, and is also
% crucial for setting information to be saved to the data file.
%
% Created by: Sam Nummela       Last Modified: 100614

% This command stops data update if no new entries are provided
if nargin>1 
% Close the created textures so they don't add up and cause memory problems
Screen('Close',A.gratTex(1));
Screen('Close',A.gratTex(2));
% PLACE DATA HERE TO BE RECORDED
D.cpd(A.j,1) = A.cpd;
D.angle(A.j,1) = A.angle;
D.range(A.j,1) = A.range;
D.rT(A.j,1) = A.totalStim;              % time in seconds of stimulus (reward) time
D.wT(A.j,1) = A.totalWait;              % time in seconds of wait (no reward) time
D.rN(A.j,1) = A.RBBs;                   % total beam breaks in stimulus epoch
D.wN(A.j,1) = A.WBBs;                   % total beam breaks in wait epoch
D.startTime(A.j,1) = A.startTime;       % Matlab time ferret started the trial
D.startTimeDP(A.j,1) = A.startTimeDP;   % Datapixx time ferret started the trial
end
