function obj = evaluate_ZDT2(x)

% obj = zeros(size(x,1),2);
obj(:,1) = x(:,1);

g = 1+9*mean(x(:,2:size(x,2)),2);
obj(:,2) = g.*(1-(x(:,1)./g).^2);
% obj = obj(:);