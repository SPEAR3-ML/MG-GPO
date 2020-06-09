function [f1,f2,p] = func_ZDT2(x)
%the ZDT2 test functions (see Deb. 2002)
%



global vrange
Nvar = size(vrange, 1);

if size(x,1)==1
    x = x';
end
p = vrange(:,1) + (vrange(:,2) - vrange(:,1)).*x;

if min(x)<0 || max(x)>1
    dxlim = 0;
    for ii=1:Nvar
        if x(ii)<0
            dxlim = dxlim + abs(x(ii));
        elseif x(ii)>1
            dxlim = dxlim + abs(x(ii)-1);
        end
    end
    
    f1 = NaN; %-5 + dxlim^2;
    f2 = NaN;
    return;
end

f1=p(1);

g = 1+9*sum(p(2:Nvar))/(Nvar-1);
f2 = g*(1-(p(1)/g)^2);




