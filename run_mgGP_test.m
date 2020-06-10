%test the mgGP algorithm
%created by X. Huang, 1/8/2014
clear

Nobj = 2;
Nvar = 30;

Npop = 10;
Ngen = 20;

NMAX = (Ngen)*Npop;

global vrange g_sigy g_cnt g_data evaluate GPy_output cleanup
vrange = ones(Nvar,1)*[0, 1,1e-6]*1; %define the range
g_sigy = 0.0; %define the nosie
g_data=[];
g_cnt = 0;


addpath GP
%% 
teeport = Teeport('ws://lambda-sp3:8090/');
evaluate = teeport.useEvaluator(@evaluate_ZDT2);
GPy_output = teeport.useProcessor('Tv10tpVPM');
cleanup = @teeport.cleanUp;
gbest=mgGPmain(Npop,Ngen,Nobj,Nvar);
% diary off

% save tmpmgGPdata
save(['mgGPdata_pt' num2str(g_sigy*1000,'%03d')])
% !rm gen*.mat

figure %(42)
% plot(1:NMAX, g_data(1:NMAX,Nvar+2),'-o',1:NMAX, g_data(1:NMAX,Nvar+3),'-')
plot(g_data(1:end,Nvar+2), g_data(1:end,Nvar+3),'.')
title('mgGP')
xlabel('obj1'); ylabel('obj2');

if 0
figure; plot(g_data(:,Nvar+2));
title('obj1')
xlabel('count')

figure; plot(g_data(:,Nvar+3))
title('obj2')
xlabel('count')
end

gbest = non_domination_sort_mod(g_data(:,2:Nvar+1+Nobj), Nobj, Nvar);
gbest = gbest(1:Npop*1,:);
figure;
plot(gbest(:,Nvar+1), gbest(:,Nvar+2),'.');
xlabel('obj1'); ylabel('obj2');

return
%% 
[data_1,xm,fm] = process_scandata2(g_data(:,2:end),Nvar,vrange,'plot');
[xm(:)', fm]

pl_solution

return
%%
dire = 'ZDT1_pop80_gen50';
mkdir(dire);
eval(['!mv gen*.mat ' dire]);
eval(['!cp *.m ' dire]);
eval(['!cp *.mat ' dire]);
eval(['!mv pl*test2*.fig ' dire]);

