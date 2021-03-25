% Run the MG-GPO algorithm
% Created by X. Huang, 1/8/2014
% Modified by M. Song and Z. Zhang, 6/9/2020
clear;

addpath EA;
addpath evaluators;
addpath utils;

%% Configs
problem = @Rosenbrock;%@ZDT2;
Nobj = 1;
Nvar = 4;
Npop = 80;
Ngen = 15;
useTeeport = 1;
%% Run
if useTeeport == 0
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
elseif useTeeport == 1
    addpath GP;
    evaluate = problem;
    predict = @GP_predict;
    
    gbest = MGGPO(evaluate,predict,Npop,Ngen,Nobj,Nvar);
elseif useTeeport == 2
    addpath GPML;
    evaluate = problem;
    predict = @GPML_predict;
    
    gbest = MGGPO(evaluate,predict,Npop,Ngen,Nobj,Nvar);
end