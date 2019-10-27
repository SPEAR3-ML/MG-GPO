clear

% dire_pso = ['D:\mgGP_NP=50_NG_50_THETA_0.3\ga_dama_1510_616_11cm_6x'];
% 
% dire_ga = ['.\MOGA_dama' filesep '.'];


%dire_pso = ['case_bet_pt15_vary'];

%dire_gp = 'case_pop_50_beta=1';
dire_gp = '.';

load([dire_gp filesep 'generation_1.mat'],'Nvar','Nobj');
genl = 0:5;
for ig=1:length(genl)
%     if genl(ig)==0
%         load([dire_ga filesep 'data_cnt_100']);
%         chromosome = data_cnt_100(:,4:Nvar+Nobj+3);
%     else
%         load([dire_ga filesep 'generation_' num2str(genl(ig)) '.mat'],'chromosome');
%     end
%     d.gbest = chromosome;
%     d.gen = genl(ig);
%     dga(ig) = d;
   
   
%     if genl(ig)==0
%         load([dire_pso filesep 'data_cnt_100']);
%         gbest = data_cnt_100(:,4:Nvar+Nobj+3);
%     else
%         load([dire_pso filesep 'generation_' num2str(genl(ig)) '.mat'],'gbest');
%     end
%    d.gbest = gbest;
%    d.gen = genl(ig);
%    dpso(ig) = d;
   
    load([dire_gp  filesep 'generation_' num2str(genl(ig)) '.mat'],'gbest','Nvar','Nobj');
%    if ig<18
%     load([dire_gp filesep 'gen_1-17' filesep 'generation_' num2str(genl(ig)) '.mat'],'gbest','Nvar','Nobj');
%    else
%        load([dire_gp filesep 'gen_18' filesep 'generation_' num2str(genl(ig-17)) '.mat'],'gbest','Nvar','Nobj');
%    end
   d.gbest = gbest;
   d.gen = genl(ig);
   dgp(ig) = d;
   
   cstr{ig} = ['gen ', num2str(d.gen)];
   
end

%%

cl = colormap;

figure(201)
clf;
vid = VideoWriter('cmp_gbest.avi');
set(vid,'FrameRate',4);
open(vid);


for ii=1:length(genl)
    clf
% h1(ii) = plot(dga(ii).gbest(:,Nvar+1),dga(ii).gbest(:,Nvar+2),'s'); hold on
% h2(ii) = plot(dpso(ii).gbest(:,Nvar+1),dpso(ii).gbest(:,Nvar+2),'o'); hold on
h3(ii) = plot(dgp(ii).gbest(:,Nvar+1),dgp(ii).gbest(:,Nvar+2),'*'); 

% set(h1(ii),'color',cl(ii*8,:));
% set(h2(ii),'color',cl(ii*8,:));
% set(h3(ii),'color',cl(ii*8,:));
title(['gen ' num2str(dgp(ii).gen)]);
% set(gca,'xscale','log','yscale','log')

set(gca,'xlim',[0, 1],'ylim',[0,10]);


%  set(gca,'xlim',[-0.025,-0.016],'ylim',[-52,-40]);
%  legend([h1(ii), h2(ii), h3(ii)],'GA','PSO','GP');
 legend([h3(ii)],'GP');
% legend([ h2(ii), h3(ii)],'PSO','GP');
xlabel('obj 1')
ylabel('obj 2')
text(-0.018,-45,['gen ' num2str(genl(ii))]);

curFrame = getframe;
    writeVideo(vid, curFrame);
pause(0.2);
 %pause

end
hold off
xlabel('obj 1')
ylabel('obj 2')
title('gbest')
% legend(h1, cstr);

close(vid);



