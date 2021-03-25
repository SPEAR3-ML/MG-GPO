function pl_solution(varargin)

if nargin == 4
    dir = varargin{1};
    genl = conv2num(varargin{2}):conv2num(varargin{3});
    type = conv2num(varargin{4});
elseif nargin == 3
    dir = varargin{1};
    genl = conv2num(varargin{2}):conv2num(varargin{3});
    type = 1;
elseif nargin == 2
    dir = varargin{1};
    genl = conv2num(varargin{2});%1:conv2num(varargin{2});
    type = 1;
elseif nargin == 1
    dir = varargin{1};
    genl = 1:1;
    type = 1;
elseif nargin == 0
    dir = '.';
    genl = 1:1;
    type = 1;
end

for ig=1:length(genl)
    load([dir filesep 'generation_' num2str(genl(ig)) '.mat']);
    d.f0 = f0;
    %    d.pbest = pbest;
    d.gbest = gbest;
    d.v0 = v0;
    d.gen = genl(ig);
    if type == 2
        fprintf('norm(v0) %f, at gen %d\n',norm(v0), d.gen);
    end
    dall(ig) = d;
    cstr{ig} = ['gen ', num2str(d.gen)];
end

%% plot

figure;
for ii=1:length(genl)
    h(ii) = plot(dall(ii).gbest(:,Nvar+1),dall(ii).gbest(:,Nvar+2),'.','markersize',20);
    % set(h(ii),'color',cl(ii*7,:));
    
    hold on
end
% hold off
xlabel('obj 1')
ylabel('obj 2')
title('gbest')
legend(h, cstr);
title(['MGGPO, gbest, POP=' num2str(Npop)])
hold on
% set(gca,'yscale','log','xscale','log');

if type == 2
    figure;
    for ii=1:length(genl)
        h(ii) = plot(dall(ii).f0(:,Nvar+1),dall(ii).f0(:,Nvar+2),'s');
        %     set(h(ii),'color',cl(ii*7,:));
        
        hold on
    end
    % hold off
    xlabel('obj 1')
    ylabel('obj 2')
    title('f0')
end

return

%% plot data w/o noise

%  load MOPSOdata_pt001 g_data g_cnt Nvar Nobj
%  load MOPSOdata_pt01 g_data g_cnt Nvar Nobj
load MOPSOdata_pt1 g_data g_cnt Nvar Nobj

% f=non_domination_sort_mod(g_data(:,2:Nvar+Nobj+1),Nobj,Nvar);
f=non_domination_sort_mod(g_data(1:2000,2:Nvar+Nobj+1),Nobj,Nvar);


figure(91);  hold on
% loglog(f(1:Npop*5,Nvar+1), f(1:Npop*5, Nvar+2),'o')
loglog(f(1:Npop,Nvar+1), f(1:Npop, Nvar+2),'o')

box;
xlabel('obj4'); ylabel('Rosen4')
% legend('\sigma=0.001','\sigma=0.01','\sigma=0.1')
