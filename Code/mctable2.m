function mctable2(fitted,Setup,name)

    filename = sprintf('../Drafts/table_jv_%s_2a.txt',name);
    f = fopen(filename,'w');
    
    fprintf(f,'Initial rural CBR (per 000) & %9.0f & Location-level data, 1960s \\tabularnewline[+0.03215in] \n', ...
        1000*Setup{'Rural','CBR'});
    fprintf(f,'Initial informal CBR (per 000) & %9.0f & Location-level data, 1960s \\tabularnewline[+0.03215in] \n', ... 
        1000*Setup{'Informal','CBR'});
    fprintf(f,'Initial formal CBR (per 000) & %9.0f & Location-level data, 1960s \\tabularnewline[+0.03215in] \n', ...
        1000*Setup{'Formal','CBR'});
    fprintf(f,'Initial rural CDR (per 000) & %9.0f & Location-level data, 1960s \\tabularnewline[+0.03215in] \n', ... 
        1000*Setup{'Rural','PreCDR'});
    fprintf(f,'Pre-UMT formal CDR (per 000) & %9.0f & Location-level data, 1900s \\tabularnewline[+0.03215in] \n', ... 
        1000*Setup{'Formal','PreCDR'});
    fprintf(f,'Pre-UMT informal CDR (per 000) & %9.0f & Location-level data, 1900s \\tabularnewline[+0.03215in] \n', ...
        1000*Setup{'Informal','PreCDR'});
    fprintf(f,'Post-UMT formal CDR (per 000) & %9.0f & Location-level data, 2000s \\tabularnewline[+0.03215in] \n', ... 
        1000*Setup{'Formal','PostCDR'});
    fprintf(f,'Post-UMT informal CDR (per 000) & %9.0f & Location-level data, 2000s \\tabularnewline[+0.03215in] \n', ...
        1000*Setup{'Informal','PostCDR'});
    fprintf(f,'UMT half-life & %9.0f & Location-level data, 1960s \\tabularnewline[+0.03215in] \n', ...
        Setup{2,'UMT'});
    fprintf(f,'Rural congestion elasticity ($\\epsilon_r$) & %9.2f & See text for details \\tabularnewline[+0.03215in] \n', ... 
        Setup{'Rural','Epsilon'});
    fprintf(f,'Urbanization rate (\\%%) in 1950 & %9.1f & Sample average \\tabularnewline[+0.03215in] \n', ...
        100*(Setup{'Formal','Size'} + Setup{'Informal','Size'})/sum(Setup{:,'Size'}));
    fprintf(f,'Informal share of urban areas (\\%%) in 1950 & %9.1f & See text for details \\tabularnewline[+0.03215in] \n', ...
        100*Setup{'Informal','Size'}/(Setup{'Formal','Size'} + Setup{'Informal','Size'}));
    fprintf(f,'Initial population size in 1950 & 1.0 & Normalization \\tabularnewline[+0.03215in] \n');
    fprintf(f,'Informal prod./amenity growth ($G_l$) & %9.2f & See text for details \\tabularnewline[+0.03215in] \n', ...
        Setup{'Informal','Growth'});
    fprintf(f,'Rural prod./amenity growth ($G_r$) & %9.2f & See text for details \\tabularnewline[+0.03215in] \n', ...
        Setup{'Rural','Growth'});
    fprintf(f,'Formal prod./amenity growth ($G_f$) & %9.2f & See text for details \\tabularnewline[+0.03215in] \n', ...
        Setup{'Formal','Growth'});
    fprintf(f,'Preference parameters ($\\beta$) & %9.2f & From Becker et al (2005) \\tabularnewline[+0.03215in] \n', ...
        Setup{1,'UMT'});

    fclose(f);

    filename = sprintf('../Drafts/table_jv_%s_2b.txt',name);
    f = fopen(filename,'w');
    
    %fprintf(f,'Formal prod./amenity growth ($\\hat{\\alpha}_f$) & %9.3f & Relative urban size in 2005 (15.2) \\tabularnewline[+0.03215in] \n', fitted(3));
    %fprintf(f,'Preference weight on CDR ($\\beta_D$) & %9.2f & Relative urban population 2005 (17.25) \\tabularnewline[+0.03215in] \n', fitted(4));
    fprintf(f,'Formal congestion elasticity ($\\epsilon_f$) & %9.2f & Urbanization rate in 2005 (mean 31.0\\%%) \\tabularnewline[+0.03215in] \n', fitted(1));
    fprintf(f,'Informal congestion elasticity ($\\epsilon_l$) & %9.2f & Informal share in 2005 (mean 64.2\\%%) \\tabularnewline[+0.03215in] \n', fitted(2));
    %fprintf(f,'CBR cost parameter ($\\phi_1$) & %9.2f & CRNI in 1985 (mean 28.8) \\tabularnewline[+0.03215in] \n', 1000*fitted(3));
    %fprintf(f,'CBR cost parameter ($\\phi_2$) & %9.2f & CRNI in 2005 (mean 25.2) \\tabularnewline[+0.03215in] \n', 1000*fitted(4));
    
    fclose(f);

end