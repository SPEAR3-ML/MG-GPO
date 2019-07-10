function f = GP_LCB(x, da)
%calculate the lower confidence bound function with given data set in da
%x is a vector for a new point
%da contains all evaluated data
%   Xmat, all points in its columns
%   invKmat, = inv(Kmat+sig^2*I)
%   
%created by X. Huang, 1/18/2019
%this is for minimization problem
%

if 0
nu=1;
delta = 0.1;
dim = length(x);
t = length(da.fa);
taut = 2*log(t^(dim/2+2)*pi^2/3/delta);
bet = sqrt(nu*taut);
else
    bet = 1.8;
end

[mu, sig2] = distri_param_predicted(x, da);
f = mu-bet*sqrt(sig2);
