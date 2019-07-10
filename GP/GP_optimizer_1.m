function [x1,f1,da]=GP_optimizer(func,x0,theta,sigy,step,tol,maxEval,flag_plot)
%Gaussian process optimizer (for minimization)
%[x1,f1,nf]=GP_optimizer(func,x0,theta,sigy,step,tol,maxEval,flag_plot)
%use line scan
%Idimut:
%   func, function handle
%   x0, initial solution
%   step, step size
%   tol, a small number to define the termination condition, set to 0 to
%        disable the feature. 
%   maxIt, maximum number of iteration, default to 100
%   flag_plot, 'plot' to plot, otherwise no plot, default to 'noplot'
%   maxEval, maximum number of function evaluation, default to 1500
%Output:
%   x1, best solution
%   f1, func(x1)
%   nf, number of evaluations
%
%Created by X. Huang, 1/18/2019
%

dim = length(x0);

xs=x0*ones(1,dim+1); %each column is the parameter vector for a vertex
ys=ones(1,dim+1)*NaN; %function value for each vertex

dx = step;
for ii=1:dim
    xs(ii,ii+1) = x0(ii)+dx;
    %xs(ii,ii+1) = check_range(xs(ii,ii+1));
end
nf = 0;
for ii=1:dim+1
    ys(ii) = func(xs(:,ii));
    nf = nf + 1;
end

da.Xmat=xs;
da.fa = ys(:);
da.dim = dim;
da.nf = nf;
da.theta = theta;

Kmat = kernel_matrix(da.Xmat,da.theta);
da.invKmat = inv(Kmat+sigy^2*eye(nf));

[f1,indxmin] = min(ys);
x1 = xs(:,indxmin);

while nf<maxEval
    opt.MaxFunEvals=2000;
    opt.Display =  'off';
    ta = tic;
    [xt, fvt] = fminsearch(@(x)GP_LCB(x, da),x1,opt);
    
    %evaluate new point
    ynew = func(xt);
    da.Xmat=[da.Xmat xt];
    da.fa = [da.fa; ynew];
    nf = nf+1;
    da.nf = nf;
    
    %expand the GP data structure
    kvec = kernel_vector(da.Xmat(:,1:end-1),da.theta,xt);    
    Kmat = [Kmat kvec; kvec' 1.0];
    da.invKmat = inv(Kmat+sigy^2*eye(nf));
    
    [f1,indxmin] = min(da.fa);
    x1 = da.Xmat(:,indxmin);
    Nd = size(da.Xmat,1);
    x1 = x1 + 0.01*randn(size(x1));
% %     x1 = da.Xmat(:,randi(Nd,1));
    et = toc(ta);
    
    da.etime(nf) = et;
    
    x1(:)'
    fprintf('%d: %f, min=%f, time=%3.1f seconds\n', nf, ynew, f1, et);
end

save tmp_GP_model




