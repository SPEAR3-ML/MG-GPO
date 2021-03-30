# Multi-Generation Gaussian Process Optimizer

This is the Matlab version of the MG-GPO algorithm. Currently MG-GPO has only been implemented in Matlab.

If you'd like to use it in your research or project, please cite the following paper:

- [Multi-objective multi-generation Gaussian process optimizer for design optimization](https://arxiv.org/abs/1907.00250)
  > Huang, Xiaobiao, Minghao Song, and Zhe Zhang. "Multi-objective multi-generation Gaussian process optimizer for design optimization." arXiv preprint arXiv:1907.00250 (2019).

## Prerequisites  

The following setup is not necessary but highly recommended if you want to archive a similar performance as shown in the MG-GPO paper.

### Download and install the GPML Matlab code 
To download and install the GPML Matlab code, please follow the official instructions [here](http://www.gaussianprocess.org/gpml/code/matlab/doc/).

You can change the mean function, covariance function and Gaussian likelihood in the `GPML/GPML_predict.m` script as you need. More options can be found in the manual of GPML Matlab code. 

## Usage

### Test run

1. Execute the `run.m` script within Matlab

The test run will optimize the 30D ZDT2 problem with MG-GPO + local GP. The test run should be done in 1 min.

### Optimize your own objective function

To optimize your own objective function, you'll have to implement the function in Matlab as a `.m` script, and put it into the `evaluators` folder.

The signature of the function should be like:

```matlab
function obj = YOUR_BADASS_PROBLEM(x)
```

Please refer to the demo objective functions Rosenbrock (single objective) and ZDT2 (multi-objective) that located in the `evaluators` folder to get more details.

After completing your objective function setup, tune the MG-GPO settings to your needs. The settings of MG-GPO are located at the **Configs** section of the `run.m` script. They are:

```matlab
problem = @ZDT2; % the objective funtion to be minimized
Nobj = 2;        % the number of the objectives
Nvar = 30;       % the number of the input variables
Npop = 10;       % the population size of each generation in MG-GPO
Ngen = 10;       % the total number of generations to evolve in MG-GPO
useGPML = 0;     % if use the GPML package
                 % set to 0 to use the local GP module with a cost of
                 % decreased performance
                 % set to 1 to use the GPML package with a better performance
                 % You should addpath for GPML package or run the startup.m
                 % script in the GPML package
```

Set `problem` to the name of your problem, and change `Nobj` and `Nvar` accordingly. The settings for `Npop` and `Ngen` depend on the problem to be optimized, but `Npop = 80` and `Ngen = 100` are usually a good starting point. Set `useGPML = 1` to get the better performance of MG-GPO.

### Access and visualize the history runs data

The data (all the varaible values at every generation) of each run will be saved as `generation_*.mat` file and put into the `data/yyyymmdd_HHMMSS` folder in the root directory, where the datetime string shows the starting time of the run. To visualize the evolution of the optmization process, in Matlab command line, run:

```matlab
pl_solution 'data/yyyymmdd_HHMMSS' [[start] end]
```

This command will show the Pareto fronts from the `start` generation to the `end` generation for the run started at `yyyymmdd_HHMMSS`.

If `start` is not specified, the start generation is 1; If both the `start` and `end` are not specified, it will only show the Pareto front of the first generation in the run.

Here are some examples:

```matlab
pl_solution 'data/20200610_004036' % visualize generation 1
pl_solution 'data/20200610_004036' 10 % visualize generation 1 to 10
pl_solution 'data/20200610_004036' 5 10 % visualize generation 5 to 10
```

## For developers

**WIP**
