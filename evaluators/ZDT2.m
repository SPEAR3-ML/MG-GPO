function obj = ZDT2(x)

obj(:,1) = x(:,1);
g = 1+9*mean(x(:,2:size(x,2)),2);
obj(:,2) = g.*(1-(x(:,1)./g).^2);
