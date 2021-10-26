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
Npop = 30;
Ngen = 50;
useGPML = 1;

%% Run
if useGPML == 1
    addpath GP;
    evaluate = problem;
    predict = @GP_predict;
    
    if 1 %start from fresh population
    gbest = MGGPO(evaluate,predict,Npop,Ngen,Nobj,Nvar);
    
    else
        %start from a saved earlier population
        load('generation_19.mat','da')
        gbest = MGGPO(evaluate,predict,Npop,Ngen,Nobj,Nvar,da);
    end
elseif useGPML == 1
    addpath GPML;
    evaluate = problem;
    predict = @GPML_predict;
    
    gbest = MGGPO(evaluate,predict,Npop,Ngen,Nobj,Nvar);
end
