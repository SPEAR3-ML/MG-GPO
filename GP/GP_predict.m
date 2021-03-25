function f = GP_predict(data)
% data: {{{Xmat, ffa}, ft}}

% Unpack the data
Xmat = data{1}{1}{1};
ffa = data{1}{1}{2};
ft = data{1}{2};

da.Xmat = Xmat';
da.fa_list = ffa;
da.mu_prior = mean(da.fa_list);
da.Sig2_prior = std(da.fa_list).^2;
Nvar = size(Xmat,2);
da.dim = Nvar;
da.nf = size(Xmat,1);
da.theta = 0.4; % scalar for now, should be Nvar \times Nobj in dimension
sigy = 1e-4;

Nobj = size(ffa,2);

if Nobj == 1
f = zeros(size(ft,1),Nobj*2);
for ii=1:Nobj
    Kmat = da.Sig2_prior(ii)*kernel_matrix(da.Xmat,da.theta);
    da.invKmat = inv(Kmat+sigy^2*eye(da.nf));
    da.fa = da.fa_list(:,ii);
    for jj=1:size(f,1)
        [mu, sig2] = distri_param_predicted(ft(jj,:)',da,da.Sig2_prior(ii),da.mu_prior(ii));
        f(jj,ii) = mu;
        f(jj,Nobj+ii) = sqrt(sig2);
    end   
end    

elseif Nobj == 2
f = zeros(2,size(ft,1),Nobj);
for ii=1:Nobj
    Kmat = da.Sig2_prior(ii)*kernel_matrix(da.Xmat,da.theta);
    da.invKmat = inv(Kmat+sigy^2*eye(da.nf));
    da.fa = da.fa_list(:,ii);
    for jj=1:size(ft,1)
        [mu, sig2] = distri_param_predicted(ft(jj,:)',da,da.Sig2_prior(ii),da.mu_prior(ii));
        f(1,jj,ii) = mu;
        f(2,jj,ii) = sqrt(sig2);
    end
end
end
