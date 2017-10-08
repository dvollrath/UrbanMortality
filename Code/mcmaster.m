%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up targets and initial conditions, housekeeping
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Set the location of your master folder here %%%%
cd /users/dietz/dropbox/project/megacity/urbanmortality

% Put code folder on the Matlab path
addpath('../Code');

% Initialize, set time, set # parameters
clear; % clear matrices for clean run
time = 55; % number of periods to simulate

% Targets - set up cell array with metric/value/period
T = {'UrbPerc' 0.31 55; ...
     'InfUrbPerc' 0.642 55};
Targets = cell2table(T,'VariableNames', {'Metric','Value','Period'});

% Initialize matrix of starting values and parameters
% All are vectors with Formal, Informal, Rural values
Setup = table;
Setup.Size = [.0445; .0445; .911]; % initial percent of population
Setup.CBR = [.038; .043; .043]; % initial crude birth rates
Setup.CBRMin = [0; 0; 0]; % set possible lower bound to CBR
Setup.PostCDR = [.015; .015; .020]; % set long-run CDR after mortality transition
Setup.PreCDR = [.040; .040; .020]; % set initial CDR
Setup.CDRSpeed = [1; 1; 1]; % parameter to control decay of CDR
Setup.Growth = [.05; .025; .025]; % exogenous growth rate of welfare
Setup.Epsilon = [.5; .5; 1.2]; % initial *guesses* for congestion elasticity
Setup.Theta = [0; 0; 0]; % parameters for cross-location congestion
Setup.Lambda = [0; 0; 0]; % parameters for wedges in welfare growth btwn locations

% The following setup parameters are a bit of fudge, as these parameters
% are not sector-specific. Using the Setup vectors, however, makes passing
% them to the main program easier. 
Setup.UMT = [.41; 3; 0]; % parameters controlling speed of UMT
Setup.Fertility = [0; 0; 0]; % control endogenous fertility response
Setup.Tau = [.000286; -.0000041; 0]; % parameters for exog path of CBR 

Setup.Properties.RowNames = {'Formal','Informal','Rural'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calibrate model to targets, finding formal and informal elasticity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial guesses for calibrated parameters
initial = [Setup{'Formal','Epsilon'}, Setup{'Informal','Epsilon'}]; 

% Call minimum search algorithm to find elasticities
options = optimset('MaxFunEvals',5000); % allow for enough iterations
[fitted, fval, exitflag] = fminsearch(@(param) ... 
    mceval(param, time, Setup, Targets),initial,options);

fitted % print out calibrated elasticities

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write results of calibrations to tables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
name = 'sim';
mctable2(fitted,Setup,name); % calibration parameters
mctable3(fitted,Setup,time,Targets,name); % comparison of scenarios

comp1 = 100; % first period of comparison
comp2 = 150; % second period of comparison
mctable4(fitted,Setup,name,comp1,comp2); % long run outcomes

mctable5(fitted,Setup,Targets,name); % policy counterfactuals

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Peform robustness checks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run('../Code/mcrobust.m');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Peform individual calibrations by country
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run('../Code/mcindividual.m');