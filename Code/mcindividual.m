%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calibrate model to individual country data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Emean,Emedian] = mcindividual(Setup,time,name)
    
    % Open and read calibration targets and initial values from file
    f = fopen('../Work/jvextract_individual.txt','r');
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
    
    filename = sprintf('../Drafts/table_jv_%s_ind.txt',name);
    f = fopen(filename,'w');
    csvname = sprintf('../Drafts/table_jv_%s_ind.csv',name);
    g = fopen(csvname,'w');
    fprintf(f,'\\multicolumn{7}{c}{\\textit{Individual countries:}} \\\\ \n');
    
    Alt = Setup;
    
    for j = 1:height(Cal) % for every row in the calibration scenarios
        % Set targets for scenario
        T = {'UrbPerc' Cal{j,'UrbPerc'} time; ...
                'InfUrbPerc' Cal{j,'InfUrbPerc'} time};
       
        % Set initial conditions for scenario
        Alt.Size = [Cal{j,'InitFormal'}; Cal{j,'InitInformal'}; Cal{j,'InitRural'}];
        % Call routine to calibrate and write results of scenario
        name = char(Cal{j,'Name'})
        E = mcrobusti(Setup,time,T,name,f,Cal{j,'Count'},j);
        Eps(j,1) = E(1); % save formal elasticity
        Eps(j,2) = E(2); % save informal elasticity
        fprintf(g,'%s, %9.3f, %9.3f \n', name, E(1), E(2));
    end
    
    fclose(g); % close csv file
    n = j+1; % set counter for remaining rows
    
    fitted = median(Eps); % use median of the accumulated elasticities
    count = height(Cal);
    name = 'Median elasticities';
    mcrobustj(Setup,time,fitted,name,f,count,n)
    n = n+1;
    
    fitted = mean(Eps); % use median of the accumulated elasticities
    count = height(Cal);
    name = 'Mean elasticities';
    mcrobustj(Setup,time,fitted,name,f,count,n)
    n = n+1;
    
    Esort = sortrows(Eps,1);  % sort by formal   
    fitted = mean(Esort(1:30,:)); % only the 30 lowest formal elasticities
    count = 30;
    name = 'Lowest 30 formal';
    mcrobustj(Setup,time,fitted,name,f,count,n)
    n = n+1;
    
    Esort = sortrows(Eps,-1);  % sort by formal   
    fitted = mean(Esort(1:30,:)); % only the 30 highest formal elasticities
    count = 30;
    name = 'Highest 30 formal';
    mcrobustj(Setup,time,fitted,name,f,count,n)
    n = n+1;
    
    Esort = sortrows(Eps,2);  % sort by informal   
    fitted = mean(Esort(1:30,:)); % only the 30 lowest informal elasticities
    count = 30;
    name = 'Lowest 30 informal';
    mcrobustj(Setup,time,fitted,name,f,count,n)
    n = n+1;
    
    Esort = sortrows(Eps,-2);  % sort by informal   
    fitted = mean(Esort(1:30,:)); % only the 30 highest informal elasticities
    count = 30;
    name = 'Highest 30 informal';
    mcrobustj(Setup,time,fitted,name,f,count,n)
     
    Esort = sortrows(Eps,1); % get minimum formal elasticity
    fitted = Esort(1,:);
    count = height(Cal);
    name = 'Lowest formal elasticity';
    mcrobustj(Setup,time,fitted,name,f,count,n)

    Esort = sortrows(Eps,-2); % get maximum informal elasticity
    fitted = Esort(1,:);
    count = height(Cal);
    name = 'Highest informal elasticity';
    mcrobustj(Setup,time,fitted,name,f,count,n)
    
    fclose(f);  

    Emean = mean(Eps);
    Emedian = median(Eps);
end