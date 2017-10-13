Alt = Setup;
Alt.Size = [   0.4600;   0.1150;   0.4250];
T = {'UrbPerc'   0.7824 55; 'InfUrbPerc'    0.0553 55};
name = 'Urb share $\geq$ 40\% no slum min'; 
count = 31;
mcrobusti(Alt,time,T,name,f,count,n);
n = n+1;

Alt = Setup;
Alt.Size = [   0.5087;   0.1272;   0.3641];
T = {'UrbPerc'   0.8071 55; 'InfUrbPerc'    0.0258 55};
name = 'Urb share $\geq$ 50\% no slum min'; 
count = 21;
mcrobusti(Alt,time,T,name,f,count,n);
n = n+1;

Alt = Setup;
Alt.Size = [   0.5645;   0.1411;   0.2943];
T = {'UrbPerc'   0.8353 55; 'InfUrbPerc'    0.0310 55};
name = 'Urb share $\geq$ 60\% no slum min'; 
count = 12;
mcrobusti(Alt,time,T,name,f,count,n);
n = n+1;

