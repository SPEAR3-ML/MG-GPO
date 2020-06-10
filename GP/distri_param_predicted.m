function [mu, sig2] = distri_param_predicted(xnew, da,Sig2_prior, mu_prior)
%calculate the distribution parameters for a new point, xnew, in Gaussian
%process
%da contains all evaluated points
%   Xmat
%   fa
%   invKmat
%created by X. Huang, 1/17/2019
%

kvec = Sig2_prior*kernel_vector(da.Xmat,da.theta,xnew);
ktK = kvec'*da.invKmat;
% mu = ktK*da.fa;%+mu_prior;
mu = ktK*(da.fa-mu_prior)+mu_prior;

%sig2 = gaussian_kernel(xnew,xnew) - ktK*kvec;
%sig2 = 1.0 - ktK*kvec;
sig2 = Sig2_prior - ktK*kvec;
