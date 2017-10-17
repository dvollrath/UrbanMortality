%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calibrate model to various robustness scenarios - for inclusion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mcrobust(Cal,time,Setup,name)
    filename = sprintf('../Drafts/table_jv_%s_robust.txt',name);
    f = fopen(filename,'w');

    % Sample changes
    fprintf(f,' \\\\ \n');
    fprintf(f,'\\multicolumn{7}{c}{\\textit{Samples:}} \\\\ \n');

    for j = 1:height(Cal) % for every row in the calibration scenarios
        % Set targets for scenario
        T = {'UrbPerc' Cal{j,'UrbPerc'} time; ...
                'InfUrbPerc' Cal{j,'InfUrbPerc'} time};
        % Set parameters for scenario
        Alt = Setup;
        % Set initial conditions for scenario
        Alt.Size = [Cal{j,'InitFormal'}; Cal{j,'InitInformal'}; Cal{j,'InitRural'}];
        % Call routine to calibrate and write results of scenario
        name = char(Cal{j,'Name'})
        mcrobusti(Setup,time,T,name,f,Cal{j,'Count'},j);
    end


    % Reset to the baseline model to do sensitivity to parameters
    fprintf(f,' \\\\ \n');
    fprintf(f,'\\multicolumn{7}{c}{\\textit{Parameter Changes:}} \\\\ \n');

    n = j+1; % set counter to label remaining rows
    
    % Reset information and targets to baseline conditions
    count = Cal{1,'Count'};
    T = {'UrbPerc' Cal{1,'UrbPerc'} time; ...
                'InfUrbPerc' Cal{1,'InfUrbPerc'} time};
    Setup.Size = [Cal{1,'InitFormal'}; Cal{1,'InitInformal'}; Cal{1,'InitRural'}];
       
    % Begin individual scenarios
    Alt = Setup;
    Alt.Size = [(Cal{1,'InitFormal'}+Cal{1,'InitInformal'})*.6; (Cal{1,'InitFormal'}+Cal{1,'InitInformal'})*.4; Cal{1,'InitRural'}]; % initial breakdown
    name = 'Initial informal ($s_l$) 40\%';
    mcrobusti(Alt,time,T,name,f,count,n);
    n = n + 1;

    Alt = Setup;
    Alt.Size = [(Cal{1,'InitFormal'}+Cal{1,'InitInformal'})*.4; (Cal{1,'InitFormal'}+Cal{1,'InitInformal'})*.6; Cal{1,'InitRural'}]; % initial breakdown
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

  
    % Close main robustness file for table
    fclose(f);
end