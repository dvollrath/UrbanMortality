%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calibrate model to various scenarios
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = sprintf('../Drafts/table_jv_rob_sample.txt');
f = fopen(filename,'w');

% Set initial parameters and options for minsearch
initial = [Setup{'Formal','Epsilon'}, Setup{'Informal','Epsilon'}];
options = optimset('MaxFunEvals',5000); % allow for enough iterations

% Set initial row counter
n = 1;

% Baseline
count = 41;
Alt = Setup;
name = 'Baseline';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

% Sample changes
fprintf(f,' \\\\ \n');
fprintf(f,'\\multicolumn{7}{c}{\\textit{Sample Changes:}} \\\\ \n');

% Call the robust script written by Stata to evaluate diff samples
run('../Work/jvextract_robust.m');

% Reset to the baseline model to do sensitivity to parameters
fprintf(f,' \\\\ \n');
fprintf(f,'\\multicolumn{7}{c}{\\textit{Parameter Changes:}} \\\\ \n');

count = 41;
T = {'UrbPerc' 0.31 55; 'InfUrbPerc' 0.642 55}; % target breakdown

Alt = Setup;
Alt.Size = [.089*.6; .089*.4; .911]; % initial breakdown
name = 'Initial informal ($s_l$) 40\%';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Size = [.089*.4; .089*.6; .911]; % initial breakdown
name = 'Initial informal ($s_l$) 60\%';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.PreCDR = [.035; .035; .020]; 
name = '1950 Urban CDR = 35';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.PreCDR = [.030; .030; .020]; 
name = '1950 Urban CDR = 30';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.PreCDR = [.030; .040; .020]; 
name = '1950 For./Inf. CDR = 30/40';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.PreCDR = [.040; .040; .040]; 
name = '1950 Rural CDR = 40';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Growth = [.05; .035; .025];
name = 'Informal growth $G_l = 0.035$';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Growth = [.05; .045; .025];
name = 'Informal growth $G_l = 0.045$';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Growth = [.03; .025; .025];
name = 'Formal growth $G_f = 0.03$';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Growth = [.04; .025; .025];
name = 'Formal growth $G_f = 0.04$';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Growth = [.04; .015; .015];
name = 'All growth rate -1\%';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.UMT = [1.56; 3; 0];
name = 'Mortality pref. $\beta = 1.56$';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.UMT = [1.70; 3; 0];
name = 'Mortality pref. $\beta = 1.70$';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Epsilon = [.5; .5; 1];
name = 'Rural elasticity $\epsilon_r = 1.0$';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Epsilon = [.5; .5; 1.6];
name = 'Rural elasticity $\epsilon_r = 1.6$';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Epsilon = [.5; .5; .6];
name = 'Rural elasticity $\epsilon_r = .6$';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Epsilon = [.5; .5; .4];
name = 'Rural elasticity $\epsilon_r = .4$';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Growth = [.015; .01; .01];
name = 'Growth 1.5, 1, and 1 percent';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Epsilon = [.5; .5; .4];
Alt.Growth = [.04; .025; .025];
name = 'Formal growth $G_f = 0.04$ and rural elas = .4';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Epsilon = [.5; .3; .5];
Alt.Growth = [0.015; 0.01; 0.01];
name = 'Set elasticity using factor shares';
mcrobustf(Alt,time,T,name,f,count,n);
n = n + 1;

fclose(f);   