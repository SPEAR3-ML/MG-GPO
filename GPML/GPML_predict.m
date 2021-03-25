function f = GPML_predict(data)
% data: {{{Xmat, ffa}, ft}}

% Unpack the data
Xmat = data{1}{1}{1};
ffa = data{1}{1}{2};
ft = data{1}{2};

Nobj = size(ffa,2);

if Nobj == 1
    f = zeros(size(ft,1),Nobj*2);
    meanfunc = @meanConst;     % Constant mean function
    covfunc = @covSEiso;       % Squared Exponental covariance function
    likfunc = @likGauss;       % Gaussian likelihood

    hyp = struct('mean', [0], 'cov', [0 0], 'lik', -1);
    hyp2 = minimize(hyp, @gp, -300, @infGaussLik, meanfunc, covfunc, likfunc, Xmat, ffa(:,Nobj));

    [f(:,Nobj), f(:,Nobj+1)] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, Xmat, ffa(:,Nobj), ft);

elseif Nobj == 2
f = zeros(2,size(ft,1),Nobj);
for ii = 1: Nobj
    meanfunc = @meanConst;     % Constant mean function
    covfunc = @covSEiso;       % Squared Exponental covariance function
    likfunc = @likGauss;       % Gaussian likelihood

    hyp = struct('mean', [0], 'cov', [0 0], 'lik', -1);
    hyp2 = minimize(hyp, @gp, -300, @infGaussLik, meanfunc, covfunc, likfunc, Xmat, ffa(:,ii));

    [mu, sigma] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, Xmat, ffa(:,ii), ft);
    f(1,:,ii) = mu;
    f(2,:,ii) = sigma;
end
end
end