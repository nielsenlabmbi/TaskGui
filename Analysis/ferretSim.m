% simulate a ferret performing the grating detection task

sig = [ 0.1 0.25 0.5 1 1.5 2 3];

dis =  [.8   .5   1   1.8   3.5    5];
cpds = [.125 .25  .5   1     2    4];

n = 60;

N = n*length(sig)*length(dis);
D.range = nan(N,1);
D.cpd = D.range;
D.correct = D.range;

k = 0;
for i = 1:length(sig)
    s = sig(i);
    for j = 1:length(dis)
        d = dis(j);
        c = cpds(j);
        for m = 1:n
            k = k+1;
            D.range(k) = (127/max(sig))*s;
            D.cpd(k) = c;
            D.correct(k) = d*randn < s+d*randn;
            lapse = rand > 0.85;
            if lapse
                D.correct(k) = round(rand);
            end
        end
    end
end

fitData(D,0,5);