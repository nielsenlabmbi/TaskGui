function D = TestFinish(D,A)

% function D = MotFinish(D,A)
%
% This function does things necessary to wrap up a trial, and is also
% crucial for setting information to be saved to the data file.
%
% Created by: Sam Nummela       Last Modified: 190514

% This command stops data update if no new entries are provided
if nargin > 1
    %A.tF % prints out the period number into the command window
    % PLACE DATA HERE TO BE RECORDED
    %D.correct(A.j,1) = A.correct;
    %D.side(A.j,1) = A.side;
    
    
    %D.startTime(A.j,1) = A.startTime;       % Matlab time ferret started the trial
    %D.startTimeDP(A.j,1) = A.startTimeDP;   % Datapixx time ferret started the trial
    %D.responseTime(A.j,1) = A.responseTime; % Matlab time ferret made its first response
    D.frameTime{A.j}=A.frameTime;
    D.startTime{A.j}=A.startTime;
    D.remTime{A.j}=A.remTime;
end

