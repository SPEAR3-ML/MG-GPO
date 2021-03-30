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
useGPML = 0;

%% Run
if useGPML == 0
    addpath GP;
    evaluate = problem;
    predict = @GP_predict;
    
    gbest = MGGPO(evaluate,predict,Npop,Ngen,Nobj,Nvar);
elseif useGPML == 1
    addpath GPML;
    evaluate = problem;
    predict = @GPML_predict;
    
    gbest = MGGPO(evaluate,predict,Npop,Ngen,Nobj,Nvar);
end
