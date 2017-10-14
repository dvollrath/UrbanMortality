%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Try to match European historical situation with slow UMT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mchistory(fitted,Setup)

    f = fopen('../Drafts/table_jv_history_1800.tex','w');

    % 1800 to 1950
    fprintf(f,'1. \\emph{Observed data:} & 12.6 & 50.0 & 1.0 & 37.9 & 30.0 & 7.7 & 57.9 & 15.0 & 14.7 \\\\ \n');

    % Reset to European starting conditions and demographics
    Alt = Setup;
    Alt.Size = [.5*.126; .5*.126; 1-.126];
    Alt.CBR = [.03; .035; .0375];
    Alt.CBRMin = [.0175; .0225; 0.0225];
    Alt.PreCDR = [.035; .0425; .025];
    Alt.PostCDR = [.0125; .020; .010];
    Alt.UMT = [.41; 50; 0]; % longer mortality transition
    time = 150;
    R = mcfix(time,fitted,Alt);
    
    fprintf(f,'2. Calibrated model, exog. fert. & %9.1f & %9.1f & 1.0 & %9.1f & %9.1f & %9.1f & %9.1f & %9.1f & %9.1f \\\\ \n', ...
        100*(Alt{'Formal','Size'} + Alt{'Informal','Size'})/sum(Alt{:,'Size'}), ...
        100*(Alt{'Informal','Size'}/(Alt{'Formal','Size'} + Alt{'Informal','Size'})), ...
        100*R{100,'UrbPerc'},100*R{100,'InfUrbPerc'},R{100,'RelUrbSize'}, ...
        100*R{150,'UrbPerc'},100*R{150,'InfUrbPerc'},R{150,'RelUrbSize'});

    Alt.Fertility = [-.3; -.3; 1]; % use endogenous fert responses
    Alt.Tau = [0; 0; 0]; % no change in CBR over time
    R = mcfix(time,fitted,Alt);
    
    fprintf(f,'3. Calibrated model, endog. fert. & %9.1f & %9.1f & 1.0 & %9.1f & %9.1f & %9.1f & %9.1f & %9.1f & %9.1f \\\\ \n', ...
        100*(Alt{'Formal','Size'} + Alt{'Informal','Size'})/sum(Alt{:,'Size'}), ...
        100*(Alt{'Informal','Size'}/(Alt{'Formal','Size'} + Alt{'Informal','Size'})), ...
        100*R{100,'UrbPerc'},100*R{100,'InfUrbPerc'},R{100,'RelUrbSize'}, ...
        100*R{150,'UrbPerc'},100*R{150,'InfUrbPerc'},R{150,'RelUrbSize'});
    
    fprintf(f,'\\midrule \n')
    
    % With short UMT
    % Reset to European starting conditions and demographics
    Alt = Setup;
    Alt.Size = [.5*.126; .5*.126; 1-.126];
    Alt.CBR = [.03; .035; .0375];
    Alt.CBRMin = [.0175; .0225; 0.0225];
    Alt.PreCDR = [.035; .0425; .025];
    Alt.PostCDR = [.0125; .020; .010];
    Alt.UMT = [.41; 3; 0]; % short mortality transition
    time = 150;
    R = mcfix(time,fitted,Alt);
    fprintf(f,'4. Calibrated model, exog. fert., fast UMT & %9.1f & %9.1f & 1.0 & %9.1f & %9.1f & %9.1f & %9.1f & %9.1f & %9.1f \\\\ \n', ...
        100*(Alt{'Formal','Size'} + Alt{'Informal','Size'})/sum(Alt{:,'Size'}), ...
        100*(Alt{'Informal','Size'}/(Alt{'Formal','Size'} + Alt{'Informal','Size'})), ...
        100*R{100,'UrbPerc'},100*R{100,'InfUrbPerc'},R{100,'RelUrbSize'}, ...
        100*R{150,'UrbPerc'},100*R{150,'InfUrbPerc'},R{150,'RelUrbSize'});
        
    Alt.Fertility = [-.3; -.3; 1]; % use endogenous fert responses
    Alt.Tau = [0; 0; 0]; % no change in CBR over time    
    R = mcfix(time,fitted,Alt);
    fprintf(f,'5. Calibrated model, endog. fert., fast UMT & %9.1f & %9.1f & 1.0 & %9.1f & %9.1f & %9.1f & %9.1f & %9.1f & %9.1f \\\\ \n', ...
        100*(Alt{'Formal','Size'} + Alt{'Informal','Size'})/sum(Alt{:,'Size'}), ...
        100*(Alt{'Informal','Size'}/(Alt{'Formal','Size'} + Alt{'Informal','Size'})), ...
        100*R{100,'UrbPerc'},100*R{100,'InfUrbPerc'},R{100,'RelUrbSize'}, ...
        100*R{150,'UrbPerc'},100*R{150,'InfUrbPerc'},R{150,'RelUrbSize'});

    fclose(f); 

end
