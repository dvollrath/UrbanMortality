%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calibrate model to various robustness scenarios - for inclusion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mcrich(Setup,time,name)
    % Open and read calibration targets and initial values from file
    f = fopen('../Work/jvextract_rich.txt','r');
    I = textscan(f,'%s%f%f%f%f%f%f','Delimiter',',');
    Cal = table;
    Cal.Name = I{1,1};
    Cal.Count = I{1,2};
    Cal.UrbPerc = I{1,3};
    Cal.InfUrbPerc = I{1,4};
    Cal.InitFormal = I{1,5};
    Cal.InitInformal = I{1,6};
    Cal.InitRural = I{1,7};
    fclose(f);

    filename = sprintf('../Drafts/table_jv_robust_%s.txt',name);
    f = fopen(filename,'w');

    % Sample changes
    fprintf(f,' \\\\ \n');
    fprintf(f,'\\multicolumn{7}{c}{\\textit{Rich samples:}} \\\\ \n');

    Alt = Setup;
    % Reset setup parameters for rich countries
    Alt.CBR = [.025; .025; .025];
    Alt.PostCDR = [.0075; .0075; .010];
    Alt.PreCDR = [.015; .015; .010];
    Alt.CBRMin = Alt.PostCDR;
    Alt.Growth = [.05; .025; .025];
    Alt.UMT = [.4; 50; 0];
    Alt.Tau = [-.0002; 0; 0]; 
    
    for j = 1:height(Cal) % for every row in the calibration scenarios
        % Set targets for scenario
        T = {'UrbPerc' Cal{j,'UrbPerc'} time; ...
                'InfUrbPerc' Cal{j,'InfUrbPerc'} time};
       
        % Set initial conditions for scenario
        Alt.Size = [Cal{j,'InitFormal'}; Cal{j,'InitInformal'}; Cal{j,'InitRural'}];
        % Call routine to calibrate and write results of scenario
        name = char(Cal{j,'Name'})
        mcrobusti(Setup,time,T,name,f,Cal{j,'Count'},j);
    end

    fclose(f);
end