function [x y sig d l] = genDots(N,R,D,C,L,S)

%%% ID dots as signal or noise
% Assume all dots are noise
sig = false(N,1);
% If coherence is > 1 assume percentage, otherwise assume fraction
if C > 1; C = C/100; end
% Get number of coherent dots
M = round(C*N);
% Assign the coherent dots
if M > 0; sig(1:M,1) = true; end

%%% Generate the positions of dots
t = 2*pi*rand(S,N,1);
r = R*rand(S,N,1);
x = r.*cos(t);
y = r.*sin(t);

%%% Generate directions of dots
d = 2*pi*rand(S,N,1);
d(sig) = D*pi/180;

% Generate lifetimes of dots
if L > 0; l = mod((1:N)',L)+1; else l = zeros(N,1); end

end