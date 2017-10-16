%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Try to match European historical situation with slow UMT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mcelastic(fitted,Setup,name,T,time)

    filename = sprintf('../Drafts/table_jv_%s_elastic.txt',name);
    f = fopen(filename,'w');

    % Baseline model
    n = 1;
    name = 'Baseline';
    mcrobusth(Setup,time,fitted,name,f,n);
    
    fprintf(f,'\\multicolumn{7}{l}{Elasticites set exogenously:} \\\\ \n');
    % Run results for exact given elasticities
    n= n + 1; 
    name = 'Elasticities set by factor shares';
    Alt = Setup;
    Shares = [0.6; 0.3; 0.56]; %Estimated factor shares
    Alt.Epsilon = Shares; % set to factor shares
    fitted(1) = Alt{'Formal','Epsilon'};
    fitted(2) = Alt{'Informal','Epsilon'};
    mcrobusth(Alt,time,fitted,name,f,n);

    n= n + 1; 
    name = 'Elasticities set by factor shares, plus formal agglom';
    Alt = Setup;
    Agglomeration = [0.1; 0; 0]; % Estimated agglomeration effects
    Alt.Epsilon = Shares + Agglomeration; % 
    fitted(1) = Alt{'Formal','Epsilon'};
    fitted(2) = Alt{'Informal','Epsilon'};
    mcrobusth(Alt,time,fitted,name,f,n);

    n= n + 1; 
    name = 'Elas. set by factor shares, plus urban agglom, plus housing';
    Alt = Setup;
    Housing = [0.091; 0.039; 0.039]; % Estimated housing elasticities
    Alt.Epsilon = Shares + Agglomeration + Housing;
    fitted(1) = Alt{'Formal','Epsilon'};
    fitted(2) = Alt{'Informal','Epsilon'};
    mcrobusth(Alt,time,fitted,name,f,n);
    
    fprintf(f,'\\multicolumn{7}{l}{Rural elasticity set, other calibrated:} \\\\ \n');

    % Run results calibrating to a given rural elasticity
    n= n + 1;
    name = 'Matching exogenous rural elasticity';
    Alt = Setup;
    Alt.Epsilon = Shares + Agglomeration + Housing;
    mcrobustg(Alt,time,T,name,f,n);
    
    
    fclose(f); 

end
