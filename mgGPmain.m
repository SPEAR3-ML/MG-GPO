function gbest = mgGPmain(func_mass,Npop,Ngen,Nobj,Nvar,varargin)
%main function for multi-geneartion Gaussian Process optimizer (mgGPO)
%created by X. Huang, 6/18/2019
%

global g_mum
if isempty(g_mum)
    g_mum = 60;
end

if nargin==5
    %intialize and evaluate
%     [f0,v0,gbest] = mopso_initialize(func_mass,Npop,Ngen,Nobj,Nvar);
    [f0,v0,pbest,gbest] = mopso_initialize(func_mass,Npop,Ngen,Nobj,Nvar);
    
    da.Xmat=f0(:,1:Nvar)';
    da.fa_list = f0(:,Nvar+1:Nvar+Nobj);
    da.mu_prior = mean(da.fa_list);
    da.Sig2_prior = std(da.fa_list).^2;
    
    da.v0 = v0;
    
    da.dim = Nvar;
    da.nf = size(f0,1);
    da.bet = 0.5;
    
    %theta = 0.1*ones(Nvar,Nobj);
    theta = 0.4;
    da.theta = theta;  %scalar for now, should be Nvar \times Nobj in dimension
    da.pbest = pbest;
    da.gbest = f0; 

    sigy = 0; %for now
    for ii=1:Nobj
        Kmat = da.Sig2_prior(ii)*kernel_matrix(da.Xmat,da.theta); %da.theta(:,ii));
        da.invKmat_list{ii} = inv(Kmat+sigy^2*eye(da.nf));
    end
    save generation_0.mat 
    
elseif nargin>=6
    da = varargin{1};
    
%     da.Xmat=[da.Xmat xt];
%     da.fa = [da.fa; ynew];
%     da.nf = nf;
%     da.invKmat = inv(Kmat+sigy^2*eye(nf))

    gbest = da.gbest;
    v0 = da.v0;
end

w = 0.4; %gset_mopso.w;
c1 = 1.0; %gset_mopso.c1;
c2 = 1.0; %gset_mopso.c2;


iter = 0;
while iter < Ngen
    iter = iter + 1;
    
    f0(:,Nvar+1:end) = [];
    
        
%         f0 = mopsomain(@(f,M,V)mass_eval_GP(f,da,M,V),Npop,10,Nobj,Nvar);
    if 0 %random
        f0 = zeros(Npop,Nvar+Nobj);
        x0 = mean(gbest(:,1:Nvar));
        for ii=1:Npop
           dx(ii) = norm(gbest(ii,1:Nvar)'-x0);
        end
        dx_max = max(dx);
        Nt = 200;
        ft = (1-2*rand(Nt,Nvar))/sqrt(Nvar)*sqrt(dx_max*1.5)*0.2;
        for jj=Nt:-1:1
           if norm(ft(jj,:))>dx_max*1.5
               ft(jj,:) = [];
           end
        end
        fprintf('%d out of %d survived\n',size(ft,1), Nt);
        Nt = size(ft,1);
        ft = ft+ones(Nt,1)*x0;
        ft = mass_eval_GP(ft,da,Nobj,Nvar);
        ft = non_domination_sort_mod(ft, Nobj, Nvar);
        f0 = ft(1:Npop,1:Nvar+Nobj);
    
    elseif 0
            da.bet = da.bet*1.2;
            if da.bet>1
                da.bet = 1.0;
            end
            for ii=1:Npop
                ft = [];
                cnt = 0;
                for jj=1:20
                    r1 = rand; %0.2+0.8*rand;
                    r2 = rand; %0.2+0.8*rand;
                    w =  0.3+0.2*rand;
                    rnd = max(1,round(Npop*0.3*rand));
                    v0jj = w*v0(ii,:)+c1*r1*(pbest(ii,1:Nvar) - f0(ii,1:Nvar))+c2*r2*(gbest(rnd,1:Nvar) - f0(ii,1:Nvar));
                    ft(jj,1:Nvar) = f0(ii,1:Nvar) + v0jj;
                    if rand < 1.0/Nvar
                        %mutation
                        ft(jj,1:Nvar) = mutate(f0(ii,1:Nvar),g_mum);
                    end
                end
                
                ft = mass_eval_GP(ft,da,Nobj,Nvar);
                ft = non_domination_sort_mod(ft, Nobj, Nvar);
                indx1 = find(ft(:,Nobj+Nvar+1)==1);
                f0(ii,1:Nvar) = ft(randi(length(indx1)),1:Nvar);
            
            end
        
    elseif 1
        r1 = rand; %0.5+0.15*randn;
        r2 = rand; %0.5+0.15*randn;
        ft = [];
        cnt = 0;
        for ii=1:Npop
            rnd = max(1,round(Npop*0.3*rand));
            %v0(ii,:) = w*v0(ii,:)+c1*r1*(pbest(ii,1:Nvar) - f0(ii,1:Nvar))+c2*r2*(gbest(rnd,1:Nvar) - f0(ii,1:Nvar));
            v0(ii,:) = w*v0(ii,:)+c2*r2*(gbest(rnd,1:Nvar) - f0(ii,1:Nvar));
            
            ft(ii,1:Nvar) = f0(ii,1:Nvar) + v0(ii,:);
            
        end
        cnt = size(f0,1);
        
        %random offset from each parameter within a sphere
%         cnt = 0;
%         ft = [];
        for ii=1:Npop
           x0 = gbest(ii,1:Nvar);
           for jj=1:20
               cnt = cnt+1;
               ft(cnt,:) = x0+(1-2*rand(1,Nvar))*0.05;
%                ft(cnt,:) = x0+(1-2*rand(1,Nvar))*0.03;
           end
           for jj=1:20
               indx = randi(Npop);
               if indx==ii
                   continue;
               else
                   rdist = rand;
                   cnt = cnt+1;
                   ft(cnt,:) = x0+(gbest(indx,1:Nvar)-x0)*rdist;    
               end
               
           end
            
        end
%         da.bet = da.bet*1.2;
        if da.bet>1
            da.bet = 1.0;
        end
        ft = mass_eval_GP(ft,da,Nobj,Nvar);
        ft = non_domination_sort_mod(ft, Nobj, Nvar);
        cnt = 0;
        f0=[];
        f_indx = 1;
        while 1 %cnt<Npop
            indx_f = find(ft(:,Nobj+Nvar+1)==f_indx);    
            if cnt+length(indx_f)>Npop
                f0 = ft(1:cnt,1:Nvar+Nobj);
                
                [crd_s, indx_scrd] = sort(ft(indx_f,end),'descend');
                f0 = [f0; ft(indx_scrd(1:Npop-cnt),1:Nvar+Nobj)];
                break;
            else
                cnt = cnt+length(indx_f);
                f_indx = f_indx + 1;
            end
            
            
        end
        
        %original
        %f0 = ft(1:Npop,1:Nvar+Nobj);
        
        
        
        
    else
        ft = mopsomain(@(f,M,V)mass_eval_GP(f,da,M,V),Npop*2,10,Nobj,Nvar);
        ft = non_domination_sort_mod(ft, Nobj, Nvar);
        f0 = ft(1:Npop,1:Nvar+Nobj);
    end
    
%         if rand < 1.0/Nvar
%             %mutation
%             f0(ii,1:Nvar) = mutate(f0(ii,1:Nvar),g_mum);
%         end
        
        %bring all position within range
        for ii=1:Npop
            for iv=1:Nvar
               if f0(ii,iv)<0
                   f0(ii,iv) = 0;
               end
               if f0(ii,iv)>1
                   f0(ii,iv) = 1;
               end
            end
        end
%     f0m = f0; %model f0
    f0=func_mass(f0, Nobj, Nvar);
    
    %update pbest
    for ii=1:Npop
        res = isdominated(f0(ii,Nvar+1:Nvar+Nobj), pbest(ii,Nvar+1:Nvar+Nobj));
        if (res==1) | ((res==0) & (rand>0.5))
            pbest(ii,:) = f0(ii,:);
         end
    end
    
    %update gbest
    gbest_tmp = non_domination_sort_mod([f0(:,1:Nobj+Nvar); gbest(:,1:Nobj+Nvar)], Nobj, Nvar);
    
%     gbest = gbest_tmp(1:Npop,:);
    gbest = replace_chromosome(gbest_tmp, Nobj, Nvar, Npop);
    
    %update GP
    if 1
        fa = [gbest(:,1:Nvar+Nobj); f0(:,1:Nvar+Nobj)];
        da.Xmat=fa(:,1:Nvar)';
        
        da.fa_list = fa(:,Nvar+1:Nvar+Nobj);
        da.mu_prior = mean(da.fa_list);
        da.Sig2_prior = std(da.fa_list).^2;

        da.dim = Nvar;
        %da.nf = size(f0,1);
        da.nf = size(fa,1);

        %theta = 0.1*ones(Nvar,Nobj);
        theta = 0.4;
        da.theta = theta;  %scalar for now, should be Nvar \times Nobj in dimension
        da.gbest = f0; 

        sigy = 0.0001; %for now
        for ii=1:Nobj
            Kmat = da.Sig2_prior(ii)*kernel_matrix(da.Xmat,da.theta); %da.theta(:,ii));
            da.invKmat_list{ii} = pinv(Kmat+sigy^2*eye(da.nf));
        end

    end

    save(['generation_' num2str(iter) '.mat']);
end


end %function


    function [f0,v0,pbest,gbest] = mopso_initialize(func_mass,Npop,Ngen,Nobj,Nvar)
        
    f0 = rand(Npop,Nvar+Nobj); %uniform
    %f0 = (1-2*rand(Npop,Nvar+Nobj))*0.15+0.5; %uniform cube around center
        
        f0(:,Nvar+1:end) = NaN;
        
        v0 = rand(Npop,Nvar)*0.1;
        f0=func_mass(f0, Nobj, Nvar);
        pbest = f0;
        gbest = non_domination_sort_mod([f0(:,1:Nobj+Nvar)], Nobj, Nvar);
    end
    function res = isdominated(f1,f2)
        %compare if f1 and f2 dominate one another
        %res=1, f1 dominate f2  (i.e., all f1 elements are smaller or equal than
        %countparts in f2)
        %res=-1, f2 dominate f1
        %res=0, non-dominated
        d = f1-f2;
        if max(d)<=0
            res = 1;
        elseif min(d)>=0
            res = -1;
        else
            res = 0;
        end
        
    end
function xn = mutate(x0,mum)
        %perform mutation on chromosome x0
        
        xn = x0;
        
        for j = 1 : length(x0)
            r(j) = rand(1);
            if r(j) < 0.5
                delta(j) = (2*r(j))^(1/(mum+1)) - 1;
            else
                delta(j) = 1 - (2*(1 - r(j)))^(1/(mum+1));
            end
            % Generate the corresponding child element.
            xn(j) = x0(j) + delta(j);
            % Make sure that the generated element is within the decision
            % space.
            if xn(j) > 1
                xn(j) = 1;
            elseif xn(j) < 0
                xn(j) = 0;
            end
        end
        
end
    
    function f = mass_eval_GP(f, da,Nobj,Nvar)
    
%         Nobj = length(da.invKmat_list);
%         Nvar = da.dim;
%         bet = 1.0;
        
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
  
    end
    