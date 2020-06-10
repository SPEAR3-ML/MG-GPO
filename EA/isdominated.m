function res = isdominated(f1,f2)
%compare if f1 and f2 dominate one another
%res=1, f1 dominate f2  (i.e., all f1 elements are smaller or equal than
%countparts in f2)
%res=-1, f2 dominate f1
%res=0, non-dominated
d = f1-f2;
if max(d)<=0
    res = 1;
elseif min(d)>=0
    res = -1;
else
    res = 0;
end