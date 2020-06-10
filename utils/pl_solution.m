function pl_solution(varargin)

if nargin == 3
    dir = varargin{1};
    genl = str2num(varargin{2}):str2num(varargin{3});
elseif nargin == 2
    dir = varargin{1};
    genl = 1:str2num(varargin{2});
elseif nargin == 1
    dir = varargin{1};
    genl = 1:1;
elseif nargin == 0
    dir = '.';
    genl = 1:1;
end

for ig=1:length(genl)
    load([dir filesep 'generation_' num2str(genl(ig)) '.mat']);
    d.f0 = f0;
    %    d.pbest = pbest;
    d.gbest = gbest;
    d.v0 = v0;
    d.gen = genl(ig);
    fprintf('norm(v0) %f, at gen %d\n',norm(v0), d.gen);
    dall(ig) = d;
    cstr{ig} = ['gen ', num2str(d.gen)];
end

%% plot
cl = colormap;

figure(206)
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

figure(203)
for ii=1:length(genl)
    h(ii) = plot(dall(ii).f0(:,Nvar+1),dall(ii).f0(:,Nvar+2),'s');
%     set(h(ii),'color',cl(ii*7,:));
    
    hold on
end
% hold off
xlabel('obj 1')
ylabel('obj 2')
title('f0')

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