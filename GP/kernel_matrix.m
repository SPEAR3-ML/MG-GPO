function Kmat = kernel_matrix(Xmat,theta)
%calculate the kernel matrix for a given set of points (in Xmat)
%each column in Xmat is a N-dim vector representing a point
%the kernel matrix given by 
%Kmat(ii,jj) = kernel(Xmat(:,ii), Xmat(:,jj),theta)
%created by X. Huang, 1/17/2019
%

N = size(Xmat,2);
Kmat = zeros(N,N);
for ii=1:N
    Kmat(ii,ii) = 1.0;
    for jj=ii+1:N
        Kmat(ii,jj) = gaussian_kernel(Xmat(:,ii), Xmat(:,jj),theta);
        Kmat(jj,ii) = Kmat(ii,jj);
    end
end
