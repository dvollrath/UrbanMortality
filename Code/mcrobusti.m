%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calibrate elasticities to given targets, write results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function E = mcrobusti(Setup,time,T,name,f,count,n)
    Targets = cell2table(T,'VariableNames', {'Metric','Value','Period'});

    name % print name to show progress
    
    % Solve for fitted values of epsilon's with the given settings
    initial = [Setup{'Formal','Epsilon'}, Setup{'Informal','Epsilon'}];
    options = optimset('MaxFunEvals',5000); % allow for enough iterations
    
    [fitted, fval, exitflag] = fminsearch(@(param) ... 
        mceval(param, time, Setup, Targets),initial,options);
    R = mcfix(time,fitted,Setup); % solve the model with the fitted values
    
    Alt = Setup; 
    Alt.PostCDR = Alt.PreCDR; % alt has no difference in pre/post CDR
    S = mcfix(time,fitted,Alt); % solve the model without UMT
    
    % Use results of R and S to print difference in outcomes w/ and w/o UMT
    fprintf(f,'%9.0f. %s & %9.0f & %9.1f & %9.1f & %9.2f & %9.3f & %9.3f \\\\ \n', ...
        n, ...
        name, ...
        count, ...
        100*S{time,'UrbPerc'} - 100*R{time,'UrbPerc'}, ...
        100*S{time,'InfUrbPerc'} - 100*R{time,'InfUrbPerc'}, ...
        S{time,'Welfare'}/R{time,'Welfare'}, ...
        fitted(1), fitted(2));
    
    % Return values of fitted elasticities
    E(1) = fitted(1);
    E(2) = fitted(2);
end