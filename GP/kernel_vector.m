function Kvec = kernel_vector(Xmat,theta,xnew)
%calculate the kernel vector between one point and a set of points (in Xmat)
%each column in Xmat is a N-dim vector representing a point, 
%xnew is a N-vector representing a new point
%the kernel vector is given by 
%Kvec(ii) = kernel(Xmat(:,ii), xnew)
%created by X. Huang, 1/17/2019
%

N = size(Xmat,2);
Kvec = zeros(N,1);
for ii=1:N
   Kvec(ii) = gaussian_kernel(Xmat(:,ii), xnew,theta);
end
