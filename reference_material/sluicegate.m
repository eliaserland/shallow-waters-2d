% Lab2 TBV2  Elias Olofsson  2019-09-16
% Sluice Gate - Finite volume method
clear all; 
clc;

M = 2000;                       %number of cells
lambda = 0.049;                 %ratio dt/dx (use lambda<0.05 for stability)
T = 40;                        %time    
model_length = 200;             %length of pool
g = 9.82;                       %g acc

dx = model_length/M;
dt = lambda*dx;                 
Ntimesteps = floor(T/dt);                           %Number of timesteps
xcc = linspace(dx/2,model_length-dx/2,M);           %cell centers 


base = 20;                                          %inital formation
increase = 10;                  
gate_pos = 120;

ax = [0 200 0 base+increase+10];                                  %figure axis

h0 = @(x) base + increase*(x<=gate_pos);            %init cond
v0 = @(x) 0;
q0 = @(x) h0(x).*v0(x);

fh = @(h,q) q;                                      %flux function
fq = @(h,q) q.^2./h + 0.5*g*h.^2;                   %
f = @ (u) [fh(u(1,:),u(2,:)); fq(u(1,:),u(2,:))];   %

u = [h0(xcc); q0(xcc)];                             %discrete init cond

x_distance = 30;
sh_vel = 0;

for i = 1:Ntimesteps
   
    u_1 = 0.5*(u(:,2) + u(:,1)) - 0.5*lambda*(f(u(:,2)) - f(-u(:,1)));
    u_M = 0.5*(u(:,M) + u(:,M-1)) - 0.5*lambda*(f(-u(:,M)) - f(u(:,M)));    
    u(:,2:M-1) = 0.5*(u(:,3:M) + u(:,1:M-2)) - 0.5*lambda*(f(u(:,3:M)) - f(u(:,1:M-2)));
    u(:,[1 end]) = [u_1 u_M];
    
    shock_xpos = dx*find(u(1,:)>base+increase*0.25, 1, 'last');
    if (shock_xpos > gate_pos+x_distance) && (sh_vel == 0)
        sh_vel = (shock_xpos - gate_pos)/(dt*i)
    end
    
    if  mod(i,10)==0
        figure(1)
        area(xcc,u(1,:))
        axis(ax)
    end
%     pause(0.01)
end


