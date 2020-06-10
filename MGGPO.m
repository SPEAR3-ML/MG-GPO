function gbest = MGGPO(evaluate,predict,Npop,Ngen,Nobj,Nvar,varargin)
% main function for Multi-Geneartion Gaussian Process Optimizer (MG-GPO)
% created by X. Huang, 6/18/2019

global g_mum
if isempty(g_mum)
    g_mum = 60;
end

if nargin == 6
    % intialize and evaluate
    M = Nobj;
    V = Nvar;
    vrange1 = ones(Nvar,1)*[0,1,1e-6]*1;  %*5
    l_limit = vrange1(:,1);
    u_limit = vrange1(:,2);
    delta_range = vrange1(:,3);
    [f0,v0,pbest,gbest] = mopso_initialize(evaluate,Npop,Nobj,Nvar);
    da.Xmat=f0(:,1:Nvar)';
    da.fa_list = f0(:,Nvar+1:Nvar+Nobj);
    da.mu_prior = mean(da.fa_list);
    da.Sig2_prior = std(da.fa_list).^2;
    da.v0 = v0;
    da.dim = Nvar;
    da.nf = size(f0,1);
    %     da.bet = 2;
    ffa = [f0(:,Nvar+1), f0(:,Nvar+2)];
    Xmat = da.Xmat';
    
    %theta = 0.1*ones(Nvar,Nobj);
    theta = 0.4;
    da.theta = theta;  %scalar for now, should be Nvar \times Nobj in dimension
    da.pbest = pbest;
    da.gbest = f0;
    
    %     sigy = 0; %for now
    %     for ii=1:Nobj
    %         Kmat = da.Sig2_prior(ii)*kernel_matrix(da.Xmat,da.theta); %da.theta(:,ii));
    %         da.invKmat_list{ii} = inv(Kmat+sigy^2*eye(da.nf));
    %     end
    %     save generation_0.mat
    save('generation_0.mat','-regexp','^(?!(cleanUp|evaluate|predict|teeport)$).');
elseif nargin > 6
    da = varargin{1};
    
    %     da.Xmat=[da.Xmat xt];
    %     da.fa = [da.fa; ynew];
    %     da.nf = nf;
    %     da.invKmat = inv(Kmat+sigy^2*eye(nf))
    
    gbest = da.gbest;
    v0 = da.v0;
end

iter = 0;
while iter < Ngen
    iter = iter + 1;
    fprintf('working on generation %d/%d...\n',iter,Ngen);
    da.bet = 2*0.85^(iter-1); % defien the kappa
    f0(:,Nvar+1:end) = [];
    %   f0 = mopsomain(@(f,M,V)mass_eval_GP(f,da,M,V),Npop,10,Nobj,Nvar);
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
        %******************Using PSO to generate trial solutions*******************
        % w = 0.4; %gset_mopso.w;
        % c1 = 1.0; %gset_mopso.c1;
        % c2 = 1.0; %gset_mopso.c2;
        w_max = 0.9; w_min = 0.4;
        c1_max = 2.5; c2_max = 2.5;
        c1_min = 0.5; c2_min = 0.5;
        r1 = 1; %0.5+0.15*randn;
        r2 = 1; %0.5+0.15*randn;
        ft = [];
        cnt = 0;
        w = w_max - (w_max - w_min) * iter / Ngen;
        c1 = (c1_min - c1_max) * iter / Ngen + c1_max;
        c2 = (c2_max - c2_min) * iter / Ngen + c2_min;
        for ii=1:Npop
            rnd = max(1,round(Npop*0.3*rand));
            %v0(ii,:) = w*v0(ii,:)+c1*r1*(pbest(ii,1:Nvar) - f0(ii,1:Nvar))+c2*r2*(gbest(rnd,1:Nvar) - f0(ii,1:Nvar));
            v0(ii,:) = w*v0(ii,:)+c2*r2*(gbest(rnd,1:Nvar) - f0(ii,1:Nvar));
            ft(ii,1:Nvar) = f0(ii,1:Nvar) + v0(ii,:);
        end
        cnt = size(ft,1);
        %**************************************************************************
        % random offset from each parameter within a sphere
        % cnt = 0;
        % ft = [];
        mu = 20;
        mum = 20;
        for ii=1:Npop
            x0 = gbest(ii,1:Nvar);
            %*************************Using PLM to generate trial solutions********
            for jj=1:20
                cnt = cnt+1;
                for j = 1 : size(x0,2)
                    r(j) = rand(1);
                    if r(j) < 0.5
                        delta(j) = (2*r(j)+(1-2*r(j))*(1-(x0(j)-l_limit(j))/(u_limit(j)-l_limit(j)))^(mum+1))^(1/(mum+1)) - 1;
                    else
                        delta(j) = 1 - (2*(1-r(j))+2*(r(j)-0.5)*(1-(u_limit(j)-x0(j))/(u_limit(j)-l_limit(j)))^(mum+1))^(1/(mum+1));
                    end
                end
                ft(cnt,:) = x0+delta;
                %                ft(cnt,:) = x0+(1-2*rand(1,Nvar))*0.05;
                %                ft(cnt,:) = x0+(1-2*rand(1,Nvar))*0.03;
            end
            %**************************************************************************
            %************************Using SBX to generate trial solutions*************
            for jj=1:10
                indx = randi(Npop);
                if indx==ii
                    continue;
                else
                    rdist = rand;
                    cnt = cnt+2;
                    m = cnt - 1;
                    n = cnt;
                    parent_1 = x0;
                    parent_2 = gbest(indx,1:Nvar);
                    
                    uuu=zeros(1,size(x0,2));
                    uuuu=zeros(1,size(x0,2));
                    for j = 1 : size(x0,2)
                        u(j) = rand(1);
                        if u(j) <= 0.5
                            bq(j) = (2*u(j))^(1/(mu+1));
                        else
                            bq(j) = (1/(2*(1 - u(j))))^(1/(mu+1));
                        end
                        bq(j) = bq(j)*(-1)^randi([0,1]);
%                         uu(j) = rand(1);
%                         if uu(j) < 0.5
%                             bq(j) = 1;
%                         end
%                         uuu(j) = rand(1);
%                         uuuu(j) = uuu(1);
%                         if uuuu(j) > 0.5
%                             bq(j) = 1;
%                         end
                        child_1(j) = 0.5*(((1 + bq(j))*parent_1(j)) + (1 - bq(j))*parent_2(j));
                        child_2(j) = 0.5*(((1 - bq(j))*parent_1(j)) + (1 + bq(j))*parent_2(j));
                    end
                    ft(m,:) = child_1;
                    ft(n,:) = child_2;
%                     ft(cnt,:) = x0+(gbest(indx,1:Nvar)-x0)*rdist;
                end
            end
            %**********************************************************************
        end
        %*************************bring all trial solutions into range*********
        for ii=1:length(ft)
            for iv=1:Nvar
                if ft(ii,iv)<0
                    ft(ii,iv) = 0;
                end
                if ft(ii,iv)>1
                    ft(ii,iv) = 1;
                end
            end
        end
        %**********************GPy: Send to GPy and then take output***************s
        C = load(['generation_' num2str(iter-1) '.mat'],'Xmat', 'ffa');
        C1 = {C.Xmat, C.ffa};
        Y1 = {{C1,ft}};
        ft_obj = predict(Y1);
        ft_mu = reshape(ft_obj(1,:,:),[],2);
        ft_sig = reshape(ft_obj(2,:,:),[],2);
        ft = [ft,ft_mu-da.bet.*ft_sig,ft_sig];
        %**************************************************************************
%         ft = mass_eval_GP(ft,da,Nobj,Nvar);
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
        % original
        % f0 = ft(1:Npop,1:Nvar+Nobj);
    else
        ft = mopsomain(@(f,M,V)mass_eval_GP(f,da,M,V),Npop*2,10,Nobj,Nvar);
        ft = non_domination_sort_mod(ft, Nobj, Nvar);
        f0 = ft(1:Npop,1:Nvar+Nobj);
    end
    %         if rand < 1.0/Nvar
    %             %mutation
    %             f0(ii,1:Nvar) = mutate(f0(ii,1:Nvar),g_mum);
    %         end
    %********************bring all position within range***********************
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
    %**************************************************************************
    f0m = f0; % model predicted solutions
    X = f0(:,1:Nvar);
    Y = evaluate(X);
    f0(:,Nvar+1:Nvar+Nobj) = Y;
    %     f0=func_mass(f0, Nobj, Nvar); % evaluted solutions
    
    %update pbest
    for ii=1:Npop
        res = isdominated(f0(ii,Nvar+1:Nvar+Nobj), pbest(ii,Nvar+1:Nvar+Nobj));
        if (res==1) | ((res==0) & (rand>0.5))
            pbest(ii,:) = f0(ii,:);
        end
    end
    
    %update gbest
    gbest_tmp = non_domination_sort_mod([f0(:,1:Nobj+Nvar); gbest(:,1:Nobj+Nvar)], Nobj, Nvar);
    %   gbest = gbest_tmp(1:Npop,:);
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
        ffa = [fa(:,Nvar+1), fa(:,Nvar+2)];
        Xmat = da.Xmat';
        
        %theta = 0.1*ones(Nvar,Nobj);
        theta = 0.4;
        da.theta = theta;  %scalar for now, should be Nvar \times Nobj in dimension
        da.gbest = f0;
        
        %         sigy = 1e-4; %for now
        %         for ii=1:Nobj
        %             Kmat = da.Sig2_prior(ii)*kernel_matrix(da.Xmat,da.theta); %da.theta(:,ii));
        %             da.invKmat_list{ii} = pinv(Kmat+sigy^2*eye(da.nf));
        %         end
    end
    %     save test -regexp ^(?!(variableToExclude1|variableToExclude2)$).
    save(['generation_' num2str(iter) '.mat'],'-regexp','^(?!(cleanUp|evaluate|predict|teeport)$).');
end
