function f = mass_eval_GP(f,da,Nobj,Nvar)
% Nobj = length(da.invKmat_list);
% Nvar = da.dim;
% bet = 1.0;

if isfield(da,'bet')
    bet = da.bet;
else
    bet = 0.3;
end

for ii=1:Nobj
    da.invKmat = da.invKmat_list{ii};
    da.fa = da.fa_list(:,ii);
    for jj=1:size(f,1)
        %[mu, sig2] = distri_param_predicted(f(jj,1:Nvar)', da,da.Sig2_prior(ii), da.mu_prior(ii));
        [mu, sig2] = distri_param_predicted2(f(jj,1:Nvar)', da,da.Sig2_prior(ii), da.mu_prior(ii));
        f(jj,Nvar+ii) = mu-bet*sqrt(sig2);
        f(jj,Nvar+Nobj+ii) = sqrt(sig2);
    end
end