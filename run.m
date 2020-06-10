% Run the MG-GPO algorithm
% Created by X. Huang, 1/8/2014
% Modified by M. Song and Z. Zhang, 6/9/2020
clear;

addpath EA;
addpath evaluators;
addpath utils;

%% Configs
problem = @ZDT2;
Nobj = 2;
Nvar = 30;
Npop = 10;
Ngen = 10;
useTeeport = 1;
plotResults = 1;

%% Initialization
global g_sigy g_cnt g_data;
g_sigy = 0.0; % define the noise
g_data = [];
g_cnt = 0;

%% Run
if useTeeport ~= 0
    % Read the platform settings
    fid = fopen('.teeport');
    url = fgetl(fid);
    if url == -1
        fclose(fid);
        error('Cannot read the url of the platform.')
    end
    processorId = fgetl(fid);
    if processorId == -1
        fclose(fid);
        error('Cannot read the id of the GPy processor on the platform.')
    end
    fclose(fid);
    
    % Connect to the platform
    teeport = Teeport(url);
    evaluate = teeport.useEvaluator(problem);
    predict = teeport.useProcessor(processorId);
    
    gbest = MGGPO(evaluate,predict,Npop,Ngen,Nobj,Nvar);
    teeport.cleanUp(); % disconnect from the platform
else
    addpath GP;
    evaluate = problem;
    predict = @GP_predict;
    
    gbest = MGGPO(evaluate,predict,Npop,Ngen,Nobj,Nvar);
end
% diary off

%% Save data
% save tmpmgGPdata
% save(['mgGPdata_pt' num2str(g_sigy*1000,'%03d')])
% !rm gen*.mat

%% Plot results
if plotResults == 1
    % print out some stuff for debug
    % [data_1,xm,fm] = process_scandata(g_data(:,2:end),Nvar,vrange,'plot');
    % [xm(:)', fm]
    pl_solution('.',Ngen);
elseif plotResults == 2
    figure;
    Nmax = Ngen*Npop;
    plot(1:Nmax,g_data(1:Nmax,Nvar+2),'-o',1:NMAX,g_data(1:NMAX,Nvar+3),'-');
elseif plotResults == 3
    figure;
    plot(g_data(1:end,Nvar+2), g_data(1:end,Nvar+3),'.');
    title('MG-GPO');
    xlabel('obj1');
    ylabel('obj2');
elseif plotResults == 4
    figure;
    plot(g_data(:,Nvar+2));
    title('obj1');
    xlabel('count');
    
    figure;
    plot(g_data(:,Nvar+3));
    title('obj2');
    xlabel('count');
elseif plotResults == 5
    figure;
    gbest = non_domination_sort_mod(g_data(:,2:Nvar+1+Nobj), Nobj, Nvar);
    gbest = gbest(1:Npop*1,:);
    plot(gbest(:,Nvar+1), gbest(:,Nvar+2),'.');
    xlabel('obj1');
    ylabel('obj2');
end

%% Clean up
dir = 'data';
mkdir(dir);
eval(['!mv gen*.mat ' dir]);
% eval(['!cp *.m ' dir]);
% eval(['!cp *.mat ' dir]);
% eval(['!mv pl*test2*.fig ' dir]);
