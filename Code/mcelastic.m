%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Try different definitions of the elasticities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mcelastic(fitted,Setup,name,T,time,Emean,Emedian)

    filename = sprintf('../Drafts/table_jv_%s_elastic.txt',name);
    f = fopen(filename,'w');

    Shares = [0.6; 0.3; 0.56]; %Estimated factor shares
    Agglomeration = [-0.036; -0.075; 0]; % Estimated agglomeration effects
    Housing = [0.1*4; 0.1*2;  0.1*2]; % Estimated housing elasticities
    Addition = [0; 0.20; 0];
    
    % Baseline model
    n = 1;
    name = 'Baseline';
    mcrobusth(Setup,time,fitted,name,f,n);

    fprintf(f,'\\multicolumn{7}{l}{Calibrating to each individual country:} \\\\ \n');
    n = n+1;
    name = 'Mean elasticities';
    fitted(1) = Emean(1);
    fitted(2) = Emean(2);
    mcrobusth(Setup,time,fitted,name,f,n);

    n = n+1;
    name = 'Median elasticities';
    fitted(1) = Emedian(1);
    fitted(2) = Emedian(2);
    mcrobusth(Setup,time,fitted,name,f,n);
    
    fprintf(f,'\\multicolumn{7}{l}{Alternative rural elasticities, calibrating formal and informal elasticities:} \\\\ \n');

    % Run results calibrating to a given rural elasticity
    n= n + 1;
    name = 'Higher value from Lee';
    Alt = Setup;
    Alt.Epsilon = [0.5; 0.5; 1.6];
    mcrobustg(Alt,time,T,name,f,n);

    n= n + 1;
    name = 'Lower value from Lee';
    Alt = Setup;
    Alt.Epsilon = [0.5; 0.5; 1.0];
    mcrobustg(Alt,time,T,name,f,n);

    n= n + 1;
    name = 'Rural elasticity from factor shares:';
    Alt = Setup;
    Alt.Epsilon = [0.5; 0.5; Shares(3)];
    mcrobustg(Alt,time,T,name,f,n);
    
    n= n + 1;
    name = 'Rural elasticity from factor shares and housing:';
    Alt = Setup;
    Alt.Epsilon = [0.5; 0.5; Shares(3) + Housing(3)];
    mcrobustg(Alt,time,T,name,f,n);

    fprintf(f,'\\multicolumn{7}{l}{Alternatives for all elasticities:} \\\\ \n');
    
    n = n+1;
    name = 'All elasticities inferred from factor shares, housing, agglom.:';
    Alt = Setup;
    Alt.Epsilon = Shares + Agglomeration + Housing;
    fitted(1) = Alt.Epsilon(1);
    fitted(2) = Alt.Epsilon(2);
    mcrobusth(Alt,time,fitted,name,f,n);

    n = n+1;
    name = 'Increase informal elasticity by 0.20:';
    Alt = Setup;
    Alt.Epsilon = Shares + Agglomeration + Housing + Addition;
    fitted(1) = Alt.Epsilon(1);
    fitted(2) = Alt.Epsilon(2);
    mcrobusth(Alt,time,fitted,name,f,n);
          
    fclose(f); 

end
