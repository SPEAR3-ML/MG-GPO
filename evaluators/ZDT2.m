function obj = ZDT2(x)
% objective function to be minimized
% here we take ZDT2 as an example
%
% x should be a (n, v) shape matrix, n is the sample size, v is the number
% of the input variables, x should be normalized to [0, 1]
% obj will be a (n, o) shape matrix, n is the sample size, o is the number
% of the objectives

% Denormalize the input x
vrange = ones(size(x,2),1)*[0,1];
x = vrange(:,1)' + (vrange(:,2) - vrange(:,1))'.*x;

obj(:,1) = x(:,1);
g = 1+9*mean(x(:,2:size(x,2)),2);
obj(:,2) = g.*(1-(x(:,1)./g).^2);
