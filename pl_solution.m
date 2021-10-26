clear
clc
%genl = [0:4:19,19];
genl = [0:10:50];
dire = '.';
for ig = 1:length(genl)
   load([dire filesep 'generation_' num2str(genl(ig)) '.mat']);
%    d.f0 = f0;
%    d.pbest = pbest;
   d.gbest = gbest;
%    d.v0 = v0;
   d.gen = genl(ig);
   fprintf('norm(v0) %f, at gen %d\n',norm(v0), d.gen);
   dall(ig) = d;
   cstr{ig} = ['gen ', num2str(d.gen)];
end
%%

figure
for ii=1:length(genl)
h(ii) = plot(dall(ii).gbest(:,Nvar+1),dall(ii).gbest(:,Nvar+2),'.','markersize',20);
hold on
end
xlabel('Obj 1')
ylabel('Obj 2')
title('gbest')
legend(h, cstr);
title(['MG-GPO, gbest, POP=' num2str(Npop)])

return

%%
% 
% global lowlimit highlimit
% vrange = [lowlimit,highlimit];
% [data_1,xm,fm] = process_scandata2(g_data(2:end,Nvar+1:end),Nvar,vrange,'plot');
