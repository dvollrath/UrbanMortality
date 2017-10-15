%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Try to match European historical situation with slow UMT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mchistory(fitted,Setup,name)

    filename = sprintf('../Drafts/table_jv_%s_history.txt',name);
    f = fopen(filename,'w');

    % 1800 to 1950
    fprintf(f,'1. \\emph{Observed data:} & 12.6 & 50.0 & 1.0 & 37.9 & 30.0 & 7.7 & 57.9 & 15.0 & 14.7 \\\\ \n');

    % Reset some settings to European starting conditions and demographics
    Setup.Size = [.5*.126; .5*.126; 1-.126];
    Setup.CBR = [.03; .035; .0375];
    Setup.CBRMin = [.0175; .0225; 0.0225];
    Setup.PreCDR = [.035; .0425; .025];
    Setup.PostCDR = [.0125; .020; .010];
    Setup.UMT = [.41; 50; 0]; % longer mortality transition
    time = 150;
    
    Alt = Setup;
    n = 2;
    name = 'Calibrated model, exog. fert.';
    mcrobustk(Alt,time,fitted,name,f,n);

    Alt = Setup;
    Alt.Fertility = [-.3; -.3; 1]; % use endogenous fert responses
    Alt.Tau = [0; 0; 0]; % no change in CBR over time
    n = 3;
    name = 'Calibrated model, endog. fert.';
    mcrobustk(Alt,time,fitted,name,f,n);

    % With short UMT    
    fprintf(f,'\\midrule \n');

    Alt = Setup;
    Alt.UMT = [.41; 3; 0]; % short mortality transition
    n = 4;
    name = 'Calibrated model, exog. fert., fast UMT';
    mcrobustk(Alt,time,fitted,name,f,n);

    Alt = Setup;
    Alt.Fertility = [-.3; -.3; 1]; % use endogenous fert responses
    Alt.Tau = [0; 0; 0]; % no change in CBR over time
    Alt.UMT = [.41; 3; 0]; % short mortality transition
    n = 5;
    name = 'Calibrated model, endog. fert., fast UMT';
    mcrobustk(Alt,time,fitted,name,f,n);

    fclose(f); 

end
