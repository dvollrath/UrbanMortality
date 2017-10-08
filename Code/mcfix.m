function Results = mcfix(time,param,Setup) 
%{
Setup table comes in with settings to work with, but table processing is so
slow that pull all information in table out into vectors/matrices. Work
with those to solve model. Similarly, work with matrix in model to hold
results because loading table is slow. Then, at end, transfer matrix of
results to table "Results" to pass back to calling program.
%}

% Decompose Setup into separate vectors
Size = Setup{:,'Size'}.';
CBR = Setup{:,'CBR'}.';
CBRmin = Setup{:,'CBRMin'}.';
CDR = Setup{:,'PostCDR'}.';
CDRI = Setup{:,'PreCDR'}.';
CDRS = Setup{:,'CDRSpeed'}.';
Cross = Setup{:,'Theta'}.';
Lambda = Setup{:,'Lambda'}.';
Tau = Setup{:,'Tau'}.';
beta = Setup{1,'UMT'};
half = Setup{2,'UMT'};
fertw = Setup{1,'Fertility'};
fertcdr = Setup{2,'Fertility'};
fertflag = Setup{3,'Fertility'};
congflag = Setup{3,'UMT'};
Epsilon = Setup{:,'Epsilon'}.';
Growth = Setup{:,'Growth'}.';

Epsilon(1) = param(1); % formal elasticity
Epsilon(2) = param(2); % informal elasticity

% Population initial values in return matrix R
R(1,1) = sum(Size(:)); % Initial population size
R(1,2) = Size(1)/R(1,1); % initial formal percent
R(1,3) = Size(2)/R(1,1); % initial informal percent
R(1,4) = Size(3)/R(1,1); % initial rural percent
R(1,9:11) = CBR - CDRI; % initial CRNI
R(1,16:18) = CBR; % initial CBR
R(1,19:21) = CDRI; % initial CDR
R(1,13)= 1; % initial welfare
R(1,22)= 1;
R(1,23)= 1;
R(1,14)= 1; % initial percent check

for t = 1:(time) % repeat for number of periods
    R(t,5) = R(t,2) + R(t,3); % Urbanization rate
    R(t,6) = R(t,3)/(R(t,2) + R(t,3)); % Informal share of urban population
    R(t,7) = R(t,1)*R(t,5)/(R(1,1)*R(1,5)); % Relative urban size
    R(t,8) = R(t,1)*R(t,3)/(R(1,1)*R(1,3)); % Relative informal size
    
    % Calculate basic current demographics
    P = [R(t,2), R(t,3), R(t,4)]; % vector of pop percents
    Purb = [1-R(t,6),R(t,6)]; % vector of urban composition
    CRNI = [R(t,9), R(t,10), R(t,11)]; % vector of CRNI
    
    % Update CDR's for use in growth rates of welfare
    decay = -log(2)/half;
    R(t+1,19:21) = CDR + (CDRI - CDR).*exp(decay*(t+1));
    Gcdr = (R(t+1,19:21) - R(t,19:21))./R(t,19:21); % CDR growth rates
    G = Growth - beta*Gcdr; % vector of G_i terms
    
    epssum = 1/(sum(P./Epsilon)); % get harmonic mean
    R(t,15) = epssum; % save
    N = P*CRNI.'; % aggregate population growth
    R(t,12) = N; % save
    v = epssum*P*(G./Epsilon).' - epssum*N - epssum*R(t,4)*Lambda(3)/Epsilon(3);
    vhat = ones(1,3)*v + Lambda;
    vhatcdr = epssum*P*(-beta*Gcdr./Epsilon).'; % just CDR welfare
    vhatG = epssum*P*(Growth./Epsilon).' - epssum*N; % just wage/amenity welfare
    if congflag == 0 % normal pop growth by location
        Nhat = (G - vhat)./Epsilon; % location pop growth rates
    else
        Nhat = (G - vhat)./epssum; % spillovers in congestion
    end
        
    R(t+1,1) = (1+R(t,12))*R(t,1); % update total population size
    R(t+1,2:4) = R(t,2:4).*(ones(3,1) + Nhat.' - N*ones(3,1)).'; % update location percents
    R(t+1,14) = R(t,2) + R(t,3) + R(t,4); % check that percents add up
    R(t+1,13) = R(t,13)*(1 + P*vhat.');
    R(t+1,22) = R(t,22)*(1+vhatcdr); % track just CDR welfare
    R(t+1,23) = R(t,23)*(1+vhatG); % track just wage/amenity welfare

    if fertflag == 0 % normal means of handling fertility exogenously
        CBRcalc = [CBRmin; CBR + ones(1,3)*(t*Tau(1)+t^2*Tau(2))]; % build comparison for CBR
        R(t+1,16:18) = max(CBRcalc,[],1);
    else % else endogenous fertility due to vhat and CDR changes
        CBRfert = R(t,16:18)*(1 + fertw*vhatG) + R(t,16:18).*(Gcdr*fertcdr);
        CBRcalc = [CBRmin; CBRfert];
        R(t+1,16:18) = max(CBRcalc,[],1);
    end
    
    R(t+1,9:11) = R(t+1,16:18) - R(t+1,19:21); % update CRNI
end

% Set up results table to contain final information
Results = table; % empty table
Results.Period = [1:time].'; % set up period column to index results
Results.Pop = R(1:time,1);
Results.ForPerc = R(1:time,2);
Results.InfPerc = R(1:time,3);
Results.RurPerc = R(1:time,4);
Results.UrbPerc = R(1:time,5);
Results.InfUrbPerc = R(1:time,6);
Results.RelUrbSize = R(1:time,7);
Results.RelInfSize = R(1:time,8);
Results.ForCRNI = R(1:time,9);
Results.InfCRNI = R(1:time,10);
Results.RurCRNI = R(1:time,11);
Results.AggCRNI = R(1:time,12);
Results.Welfare = R(1:time,13);
Results.Check = R(1:time,14);
Results.AggEps = R(1:time,15);
Results.ForCBR = R(1:time,16);
Results.InfCBR = R(1:time,17);
Results.RurCBR = R(1:time,18);
Results.ForCDR = R(1:time,19);
Results.InfCDR = R(1:time,20);
Results.RurCDR = R(1:time,21);
Results.WCDR = R(1:time,22);
Results.WGrowth = R(1:time,23);