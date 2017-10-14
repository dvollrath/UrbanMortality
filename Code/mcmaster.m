%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up targets and initial conditions, housekeeping
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Set the location of your master folder here %%%%
cd /users/dietz/dropbox/project/megacity/urbanmortality/Code

% Put code folder on the Matlab path
addpath('../Code');

% Initialize, set time, set # parameters
clear; % clear matrices for clean run
time = 55; % number of periods to simulate

% Open and read calibration targets and initial values from file
f = fopen('../Work/jvextract_robust.txt','r');
I = textscan(f,'%s%f%f%f%f%f%f%f%f%f%f%f','Delimiter',',');
Cal = table;
Cal.Name = I{1,1};
Cal.Count = I{1,2};
Cal.UrbPerc = I{1,3};
Cal.InfUrbPerc = I{1,4};
Cal.InitFormal = I{1,5};
Cal.InitInformal = I{1,6};
Cal.InitRural = I{1,7};
Cal.RelUrban = I{1,8};
Cal.RelInformal = I{1,9};
Cal.RelRural = I{1,10};
Cal.FertTau1 = I{1,11};
Cal.FertTau2 = I{1,12};
fclose(f);

% Targets - set up cell array with metric/value/period
T = {'UrbPerc' Cal{1,'UrbPerc'} time; ...
     'InfUrbPerc' Cal{1,'InfUrbPerc'} time};
Targets = cell2table(T,'VariableNames', {'Metric','Value','Period'});

% Initialize matrix of starting values and parameters
% All are vectors with Formal, Informal, Rural values
Setup = table;
Setup.Size = [Cal{1,'InitFormal'}; Cal{1,'InitInformal'}; Cal{1,'InitRural'}]; % initial percent of population
Setup.Relative = [Cal{1,'RelUrban'}; Cal{1,'RelInformal'}; Cal{1,'RelRural'}]; % relative size in last period
Setup.CBR = [.038; .043; .043]; % initial crude birth rates
Setup.CBRMin = [0; 0; 0]; % set possible lower bound to CBR
Setup.PostCDR = [.015; .015; .020]; % set long-run CDR after mortality transition
Setup.PreCDR = [.040; .040; .020]; % set initial CDR
Setup.Growth = [.05; .025; .025]; % exogenous growth rate of welfare
Setup.Epsilon = [.5; .5; 1.2]; % initial *guesses* for congestion elasticity
Setup.Lambda = [0; 0; 0]; % parameters for wedges in welfare growth btwn locations

% The following setup parameters are a bit of fudge, as these parameters
% are not sector-specific. Using the Setup vectors, however, makes passing
% them to the main program easier. 
Setup.UMT = [.41; 3; 0]; % parameters controlling speed of UMT
Setup.Fertility = [0; 0; 0]; % control endogenous fertility response
%Setup.Tau = [.000286; -.0000041; 0]; % parameters for exog path of CBR 

Setup.Tau = [Cal{1,'FertTau1'}/1000; Cal{1,'FertTau2'}/1000; 0];
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
mctable5(fitted,Setup,Targets,name); % policy counterfactuals
mcrobust(Cal,time,Setup,name); % perform robustness checks

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Peform individual calibrations by country
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mcindividual(Setup,time,'ind');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run for historical rich countries
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mchistory(fitted,Setup);