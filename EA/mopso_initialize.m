function [f0,v0,pbest,gbest] = mopso_initialize(Npop,Nobj,Nvar)
global evaluate vrange
f0 = rand(Npop,Nvar+Nobj); %uniform
% f0 = (1-2*rand(Npop,Nvar+Nobj))*0.15+0.5; %uniform cube around center
f0(:,Nvar+1:end) = NaN;
v0 = rand(Npop,Nvar)*0.1;
X = f0(:,1:Nvar);
X = vrange(:,1)' + (vrange(:,2) - vrange(:,1))'.*X;
Y = evaluate(X);
f0(:,Nvar+1:Nvar+Nobj) = Y;
% f0=func_mass(f0, Nobj, Nvar);
pbest = f0;
gbest = non_domination_sort_mod(f0(:,1:Nobj+Nvar), Nobj, Nvar);