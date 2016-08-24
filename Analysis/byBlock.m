function [fc labels] = byBlock(D)

ind = find(diff([0;D.stimSide])~=0);

labels = {'1st' '1st 3' 'all' 'last 3' 'last'};

cc = D.stimSide & D.firstTry;

fc = nan(length(ind)-1,4);
for i = 1:length(ind)-1
    fc(i,1) = cc(ind(i));
    fc(i,2) = mean(cc(ind(i):ind(i)+3));
    fc(i,3) = mean(cc(ind(i):ind(i+1)-1));
    fc(i,4) = mean(cc(ind(i+1)-3:ind(i+1)-1));
    fc(i,5) = cc(ind(i+1)-1);
end

fc = mean(fc);