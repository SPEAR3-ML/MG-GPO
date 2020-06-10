function xn = mutate(x0,mum)
%perform mutation on chromosome x0

xn = x0;

for j = 1 : length(x0)
    r(j) = rand(1);
    if r(j) < 0.5
        delta(j) = (2*r(j))^(1/(mum+1)) - 1;
    else
        delta(j) = 1 - (2*(1 - r(j)))^(1/(mum+1));
    end
    % Generate the corresponding child element.
    xn(j) = x0(j) + delta(j);
    % Make sure that the generated element is within the decision
    % space.
    if xn(j) > 1
        xn(j) = 1;
    elseif xn(j) < 0
        xn(j) = 0;
    end
end