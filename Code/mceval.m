function val = mceval(param, time, Setup, Targets) 

T = Targets{:,'Value'}; % get numeric target values
[M,N] = size(Targets); % get number of targets
Results = zeros(M,1); % set up results vector

% Run model given the passed parameters, find results
R = mcfix(time,param,Setup); % call model

for i = 1:M % for each row in table
    % Look up result in returned table, add to results vector
    Results(i,1) = R{Targets{i,'Period'},Targets{i,'Metric'}};
end

val = (Results - T).'*(Results - T); % sum of squared residuals
