%test the mgGP algorithm
%created by X. Huang, 1/8/2014

clear
t0 = datestr(clock,'YYYY/mm/dd HH:MM:SS.FFF');
save intial_time.mat
Nobj = 2;
Nvar = 30;

Npop = 80;
Ngen = 50;

NMAX = (Ngen)*Npop;

global vrange
%vrange = ones(Nvar,1)*[-1, 1,1e-6]*2;  %*5
vrange = ones(Nvar,1)*[0, 1,1e-6]*1;  %*5

p0=zeros(Nvar,1)+.0;
p0(1) = -0.5; %-0.5;
p0(3) = -0.5;

x0 = (p0-vrange(:,1))./(vrange(:,2)-vrange(:,1));

range0 = [zeros(Nvar,1)+0.2, ones(Nvar,1)-0.2, 0.01*ones(Nvar,1)];
global g_sigy;
g_sigy = 0.001; % 0.1; %0.1; %0.0002; %0.002*2*2;
global g_noise
g_noise = g_sigy;

global g_cnt g_data
g_data=[];
g_cnt = 0;

addpath GP
% addpath PSO


%% 

g_sigy = 0.0; 

global g_cnt g_data
g_data=[];
g_cnt = 0;

gbest=mgGPmain(@mass_evaluate,Npop,Ngen,Nobj,Nvar,vrange);
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


dire = 'test1_ZDT1_pop100_gen100_bet=pt5';
mkdir(dire);
eval(['!mv gen*.mat ' dire]);
eval(['!cp *.m ' dire]);
eval(['!cp *.mat ' dire]);
eval(['!mv pl*test2*.fig ' dire]);




