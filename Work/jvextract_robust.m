Setup.Size = [   0.0444;   0.0444;   0.9113];
T = {'UrbPerc'   0.3104 55; 'InfUrbPerc'    0.6421 55};
name = 'Baseline'; 
count = 41;
mcrobusti(Setup,time,T,name,f,count,n);
n = n+1;

Setup.Size = [   0.0537;   0.0537;   0.8926];
T = {'UrbPerc'   0.3352 55; 'InfUrbPerc'    0.6137 55};
name = '1950 Urbanization $\leq$ 30\%'; 
count = 46;
mcrobusti(Setup,time,T,name,f,count,n);
n = n+1;

Setup.Size = [   0.0689;   0.0689;   0.8621];
T = {'UrbPerc'   0.3805 55; 'InfUrbPerc'    0.5828 55};
name = '1950 Urbanization $\leq$ 40\%'; 
count = 53;
mcrobusti(Setup,time,T,name,f,count,n);
n = n+1;

Setup.Size = [   0.0453;   0.0453;   0.9095];
T = {'UrbPerc'   0.3119 55; 'InfUrbPerc'    0.6330 55};
name = 'Max. slum share $\geq$ 20\%'; 
count = 42;
mcrobusti(Setup,time,T,name,f,count,n);
n = n+1;

Setup.Size = [   0.0455;   0.0455;   0.9091];
T = {'UrbPerc'   0.3126 55; 'InfUrbPerc'    0.6224 55};
name = 'Max. slum share $\geq$ 10\%'; 
count = 43;
mcrobusti(Setup,time,T,name,f,count,n);
n = n+1;

Setup.Size = [   0.0883;   0.0883;   0.8235];
T = {'UrbPerc'   0.4360 55; 'InfUrbPerc'    0.4934 55};
name = '$\Delta CDR_{50,80} \leq -7$'; 
count = 59;
mcrobusti(Setup,time,T,name,f,count,n);
n = n+1;

Setup.Size = [   0.0864;   0.0864;   0.8272];
T = {'UrbPerc'   0.4476 55; 'InfUrbPerc'    0.4713 55};
name = '$\Delta CDR_{50,80} \leq -12$'; 
count = 26;
mcrobusti(Setup,time,T,name,f,count,n);
n = n+1;

Setup.Size = [   0.0736;   0.0736;   0.8529];
T = {'UrbPerc'   0.4715 55; 'InfUrbPerc'    0.4734 55};
name = '$\Delta CDR_{50,80} \leq -16$'; 
count = 8;
mcrobusti(Setup,time,T,name,f,count,n);
n = n+1;

Setup.Size = [   0.0429;   0.0429;   0.9141];
T = {'UrbPerc'   0.3079 55; 'InfUrbPerc'    0.6577 55};
name = 'ex-China and India'; 
count = 39;
mcrobusti(Setup,time,T,name,f,count,n);
n = n+1;

Setup.Size = [   0.0449;   0.0449;   0.9102];
T = {'UrbPerc'   0.3115 55; 'InfUrbPerc'    0.6469 55};
name = 'ex-Communist'; 
count = 27;
mcrobusti(Setup,time,T,name,f,count,n);
n = n+1;
