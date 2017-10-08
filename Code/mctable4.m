function mctable4(fitted,Setup,name,comp1,comp2) 
    
    filename = sprintf('../Drafts/table_jv_%s_4.txt',name);
    f = fopen(filename,'w');
    
    % Call model for at least comp2 periods with floor of initial CBR
    Alt = Setup;
    Alt.CBRMin = Alt.CBR;
    R = mcfix(comp2+1,fitted,Alt);
    v1 = R{comp1,'Welfare'};
    v2 = R{comp2,'Welfare'};
    fprintf(f,'1. With UMT, CBR floor & %9.1f & %9.1f & %9.1f & %9.1f & %9.2f & %9.1f & %9.1f & %9.1f & %9.1f & %9.2f \\tabularnewline[+0.015in] \n', ...
        100*R{comp1,'UrbPerc'},R{comp1,'RelUrbSize'},100*R{comp1,'InfUrbPerc'},R{comp1,'RelInfSize'},1, ...
        100*R{comp2,'UrbPerc'},R{comp2,'RelUrbSize'},100*R{comp2,'InfUrbPerc'},R{comp2,'RelInfSize'},1);

    % Call model with UMT and with endogenous fertility
    Alt = Setup;
    Alt.Fertility = [-.3; -.3; 1]; % use endogenous fert responses
    Alt.Tau = [0; 0; 0]; % no change in CBR over time
    %Alt.Epsilon = (Setup{1,'UMT'} + 1.0*Setup{1,'Fertility'})*Setup.Epsilon;
    %Alt.Growth = (Setup{1,'UMT'} + 1.0*Setup{1,'Fertility'})*Setup.Growth;
    R = mcfix(comp2+1,fitted,Alt);
    fprintf(f,'2. With UMT, endog fertility & %9.1f & %9.1f & %9.1f & %9.1f & %9.2f & %9.1f & %9.1f & %9.1f & %9.1f & %9.2f \\tabularnewline[+0.015in] \n', ...
        100*R{comp1,'UrbPerc'},R{comp1,'RelUrbSize'},100*R{comp1,'InfUrbPerc'},R{comp1,'RelInfSize'},R{comp1,'Welfare'}/v1, ...
        100*R{comp2,'UrbPerc'},R{comp2,'RelUrbSize'},100*R{comp2,'InfUrbPerc'},R{comp2,'RelInfSize'},R{comp2,'Welfare'}/v2);    
    
    % Call model with floor of initial CBR and no UMT
    Alt = Setup;
    Alt.CBRMin = Alt.CBR;
    Alt.PostCDR = Alt.PreCDR; % no change in CDR
    R = mcfix(comp2+1,fitted,Alt);
    fprintf(f,'3. Without UMT, CBR floor & %9.1f & %9.1f & %9.1f & %9.1f & %9.2f & %9.1f & %9.1f & %9.1f & %9.1f & %9.2f \\tabularnewline[+0.015in] \n', ...
        100*R{comp1,'UrbPerc'},R{comp1,'RelUrbSize'},100*R{comp1,'InfUrbPerc'},R{comp1,'RelInfSize'},R{comp1,'Welfare'}/v1, ...
        100*R{comp2,'UrbPerc'},R{comp2,'RelUrbSize'},100*R{comp2,'InfUrbPerc'},R{comp2,'RelInfSize'},R{comp2,'Welfare'}/v2);

    % Call model with no change in CBR and no UMT
    Alt = Setup;
    Alt.PostCDR = Alt.PreCDR; % no change in CDR
    Alt.Tau = [0; 0; 0]; % no change in CBR over time
    R = mcfix(comp2+1,fitted,Alt);
    fprintf(f,'4. Without UMT, no change in CBR & %9.1f & %9.1f & %9.1f & %9.1f & %9.2f & %9.1f & %9.1f & %9.1f & %9.1f & %9.2f \\tabularnewline[+0.015in] \n', ...
        100*R{comp1,'UrbPerc'},R{comp1,'RelUrbSize'},100*R{comp1,'InfUrbPerc'},R{comp1,'RelInfSize'},R{comp1,'Welfare'}/v1, ...
        100*R{comp2,'UrbPerc'},R{comp2,'RelUrbSize'},100*R{comp2,'InfUrbPerc'},R{comp2,'RelInfSize'},R{comp2,'Welfare'}/v2);
    
    % Call model without UMT and with endogenous fertility
    Alt = Setup;
    Alt.PostCDR = Alt.PreCDR; % no change in CDR
    Alt.Fertility = [-.3; -.3; 1]; % use endogenous fert responses
    Alt.Tau = [0; 0; 0]; % no change in CBR over time
    %Alt.Epsilon = (Setup{1,'UMT'} + 1.0*Setup{1,'Fertility'})*Setup.Epsilon;
    %Alt.Growth = (Setup{1,'UMT'} + 1.0*Setup{1,'Fertility'})*Setup.Growth;
    R = mcfix(comp2+1,fitted,Alt);
    fprintf(f,'5. Without UMT, endog fertility & %9.1f & %9.1f & %9.1f & %9.1f & %9.2f & %9.1f & %9.1f & %9.1f & %9.1f & %9.2f \\tabularnewline[+0.015in] \n', ...
        100*R{comp1,'UrbPerc'},R{comp1,'RelUrbSize'},100*R{comp1,'InfUrbPerc'},R{comp1,'RelInfSize'},R{comp1,'Welfare'}/v1, ...
        100*R{comp2,'UrbPerc'},R{comp2,'RelUrbSize'},100*R{comp2,'InfUrbPerc'},R{comp2,'RelInfSize'},R{comp2,'Welfare'}/v2);

       
    fclose(f);    
end
