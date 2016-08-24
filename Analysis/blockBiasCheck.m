E.same = diff(E.side);
E.same = ~logical(E.same);
E.same = [0;E.same];

CgS = 0;    % correct given same
CgD = 0;    % correct given different
TS = 0;     % total same
TD = 0;     % total different

for i = 2:length(E.same)
    if E.same(i)
        TS = TS + 1;
        if E.correct(i); CgS = CgS + 1; end;
    end
    if ~E.same(i)
        TD = TD + 1;
        if E.correct(i); CgD = CgD + 1; end;
    end
end

[FCgS LgS] = binofit(CgS,TS)
[FCgD LgD] = binofit(CgD,TD)


if LgS(1) > LgD(2)
    h = 1
else
    h = 0
end