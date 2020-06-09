clear
% genl = [1:3:14]; % [1:10:51];
% genl = [1:10:100, 100];
genl = [50];
dire = '.';

for ig=1:length(genl)
   load([dire filesep 'generation_' num2str(genl(ig)) '.mat']);
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
Nobj = 2;
Nvar = 8;
Npop = 80;
Ngen = 50;
PF=PF(Nobj,1000);
plot(PF(:,1),PF(:,2),'.','markersize',20)
% set(gca,'yscale','log','xscale','log');

figure(203)
for ii=1:length(genl)
h(ii) = plot(dall(ii).f0(:,Nvar+1),dall(ii).f0(:,Nvar+2),'s');
% set(h(ii),'color',cl(ii*7,:));

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



