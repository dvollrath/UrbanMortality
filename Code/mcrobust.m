%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calibrate model to various robustness scenarios - for inclusion
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
Alt.Growth = [.05; .025; 0.015];
name = 'Rural growth $G_r = .015$';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Growth = [.04; .015; 0.025];
name = 'Urban growth lower $G_f = 0.04$ and $G_l = 0.015$';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Growth = [.04; .015; 0.015];
name = 'All growth lower -1\%';
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
Alt.Epsilon = [.5; .5; .6];
Alt.Fertility = [-.3; -.3; 1];
Alt.Tau = [0; 0; 0];
name = 'Rural elas $\epsilon_r = .6$ and endog fert.';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Epsilon = [.5; .5; .4];
name = 'Rural elasticity $\epsilon_r = .4$';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Epsilon = [.5; .5; .4];
Alt.Fertility = [-.3; -.3; 1];
Alt.Tau = [0; 0; 0];
name = 'Rural elas $\epsilon_r = .4$ and endog fert.';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

Alt = Setup;
Alt.Epsilon = [.5; .5; .6];
Alt.Growth = [.04; .025; .025];
name = 'Formal growth $G_f = 0.04$ and rural elas = .6';
mcrobusti(Alt,time,T,name,f,count,n);
n = n + 1;

% Close main robustness file for table
fclose(f);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calibrate model to various robustness scenarios - not for inclusion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = sprintf('../Drafts/table_jv_rob_extra.txt');
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

% Other urbanization samples
fprintf(f,' \\\\ \n');
fprintf(f,'\\multicolumn{7}{c}{\\textit{Other samples:}} \\\\ \n');

% Call the robust script written by Stata to evaluate diff samples
run('../Work/jvextract_limits.m');

% Rich countries
fprintf(f,' \\\\ \n');
fprintf(f,'\\multicolumn{7}{c}{\\textit{Rich country samples:}} \\\\ \n');

% Reset setup parameters for rich countries
Setup.CBR = [.025; .025; .025];
Setup.PostCDR = [.0075; .0075; .010];
Setup.PreCDR = [.015; .015; .010];
Setup.CDRSpeed = [1; 1; 1];
Setup.CBRMin = Setup.PostCDR;
Setup.Growth = [.05; .025; .025];
Setup.UMT = [.4; 50; 0];
Setup.Tau = [-.0002; 0; 0]; 

% Call the robust script written by Stata to evaluate diff samples
run('../Work/jvextract_rich.m');

fclose(f);   