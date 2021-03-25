function obj = Rosenbrock(x)

vrange = ones(size(x,2),1)*[0,1];
x = vrange(:,1)' + (vrange(:,2) - vrange(:,1))'.*x;

asum = 0;
Nsample = size(x,1);
Nvar = size(x,2);
for ii = 1:Nsample
    for jj = 1:(Nvar-1)
         asum = asum  + 100 * (x(jj+1)-(x(jj))^2)^2 + (1-x(jj))^2;
    end
    obj(ii,1) = asum;
end
end