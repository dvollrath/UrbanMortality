%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Try to match European historical situation with slow UMT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
name = 'rich17501940';
Alt = Setup;
Alt.Size = [.0625; .0625; .875];
Alt.CBR = [.0325; .0375; .040];
Alt.CBRMin = [.03; .03; 0.035];
Alt.PreCDR = [.0325; .0425; .025];
Alt.PostCDR = [.020; .030; .020];
Alt.UMT = [.41; 30; 0]; % longer mortality transition
T = {'UrbPerc' 0.50 190; 'InfUrbPerc' 0.20 190};
AltTargets = cell2table(T,'VariableNames', {'Metric','Value','Period'});
mctable3(fitted,Alt,190,AltTargets,name);

name = 'rich18001900';
Alt = Setup;
Alt.Size = [.0625; .0625; .875];
Alt.CBR = [.0325; .0375; .040];
Alt.CBRMin = [.03; .03; 0.035];
Alt.PreCDR = [.0325; .0425; .025];
Alt.PostCDR = [.020; .030; .020];
Alt.UMT = [.41; 30; 0]; % longer mortality transition
T = {'UrbPerc' 0.40 100; 'InfUrbPerc' 0.30 100};
AltTargets = cell2table(T,'VariableNames', {'Metric','Value','Period'});
mctable3(fitted,Alt,100,AltTargets,name);

name = 'rich18001950';
Alt = Setup;
Alt.Size = [.0625; .0625; .875];
Alt.CBR = [.0325; .0375; .040];
Alt.CBRMin = [.03; .03; 0.035];
Alt.PreCDR = [.0325; .0425; .025];
Alt.PostCDR = [.020; .030; .020];
Alt.UMT = [.41; 30; 0]; % longer mortality transition
T = {'UrbPerc' 0.50 150; 'InfUrbPerc' 0.20 150};
AltTargets = cell2table(T,'VariableNames', {'Metric','Value','Period'});
mctable3(fitted,Alt,150,AltTargets,name);