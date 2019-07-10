function kv=gaussian_kernel(x1,x2,varargin)
%square exponental kernel for Gaussian Process
%created by X. Huang, 1/17/2019
%

N = length(x1);
if length(x2)~=N
   error('vectors x2 and x1 should have the same length'); 
end
theta = ones(N,1);
if nargin>=3
    theta = varargin{1};
end

kv = exp(-0.5*(x1-x2)'*diag(1./theta.^2)*(x1-x2));
