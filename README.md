# Multi-Generation Gaussian Process Optimizer

This is the Matlab version of the MG-GPO algorithm. Currently MG-GPO has only been implemented in Matlab.

If you'd like to use it in your research or project, please cite the following paper:

- MG-GPO  
	[Multi-objective multi-generation Gaussian process optimizer for design optimization](https://arxiv.org/abs/1907.00250)

## Prerequisites  

The following setup is not necessary but highly recommended if you want to archive the same performance as shown in the MG-GPO paper.

### Install the Teeport client for Matlab

The [Teeport client for Matlab](https://github.com/SPEAR3-ML/teeport-client-matlab) is the Matlab client of the algorithm testing/benchmarking/optimizing platform **Teeport**. With the client installed, you can talk to the Teeport platform and use the optimizers/evaluators/processors provided by the platform within you Matlab optimize/evaulate code. The better GP modeling/prediction module in MG-GPO makes use of the **GPy processor** on the platform. 

To install the client, clone the repo:

```bash
git clone https://github.com/SPEAR3-ML/teeport-client-matlab.git
```

And follow the instructions in the README.

**Note that the Teeport platform can only be accessed within the SLAC network (on-site or vpn)!**

## Usage

### Test run

1. Install the Teeport client for Matlab (and activate it in Matlab, of course)
2. Make sure you're connecting to the SLAC network
3. Place the `.teeport` file obtained from the authors in the root of the repo
4. Execute the `run.m` script within Matlab

The test run will optimize the 30D ZDT2 problem with MG-GPO. The test run should be completed in 1 min.

### Optimize your own objective function

To optimize your own objective function, you'll have to implement the function in Matlab as a `.m` script, and put it into the `evaluators` folder.

The signature of the function should be like:

```matlab
function obj = YOUR_BADASS_PROBLEM(x)
```

Please refer to the demo objective function ZDT2 that locates in the `evaluators` folder to get more details.

After completing your objective function setup, tune the MG-GPO settings to your needs. The settings of MG-GPO are located at the **Configs** section of the `run.m` script. They are:

```matlab
problem = @ZDT2; % the objective funtion to be minimized
Nobj = 2; % the number of the objectives
Nvar = 30; % the number of the input variables
Npop = 10; % the population size of each generation in MG-GPO
Ngen = 10; % the total number of generations to evolve in MG-GPO
useTeeport = 1; % if use the Teeport platform
                % set to 0 to use the local GP module with a cost of decreasing performance
plotResults = 1; % which type of the results should be visualized after the run
                 % set to 0 to disable the plotting feature
```

Set `problem` to the name of your problem, and change `Nobj` and `Nvar` accordingly. The settings for `Npop` and `Ngen` depend on the problem to be optimized, but `Npop = 80` and `Ngen = 100` are usually a good starting point. Set `useTeeport = 1` to get the best performance of MG-GPO.

### Visualize the results of the history runs

The data (all the varaible values at every generation) of each run will be put into a sub-folder in the `data` folder of the root and named as `yyyymmdd_HHMMSS`, where the datetime string shows the starting time of the run. To visualize it, in Matlab command line, run:

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
