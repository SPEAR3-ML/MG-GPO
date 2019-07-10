function f = GP_LCBm(x, da)
%calculate the lower confidence bound (LCB) acquisition function 
%with given data set in da
%   x continas N column vectors for new point
%   da contains all evaluated data
%   Xmat, all points in its columns
%   invKmat, = inv(Kmat+sig^2*I)
%return
%   f,  Nobj \times N
%created by X. Huang, 1/18/2019
%this is for minimization problem
%multiple objective GP 

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

Nobj = length(da.invKmat_list);
for ii=1:Nobj
    da.invKmat = da.invKmat_list{ii};
    for jj=1:size(x,2)
        [mu, sig2] = distri_param_predicted(x(:,jj), da);
        f(ii,jj) = mu-bet*sqrt(sig2);
    end   
end
