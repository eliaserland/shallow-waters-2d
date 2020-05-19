% 2-Dimensional Shallow Water Equations, Lax-Friedrich.
% Elias Olofsson, F17, 2019-09-17.
clear all; clf; clc; 

%Hardcoded for square regions
M = 350;                                            %cell count per side
model_length = 1;                                   %length of side
% lambda = 0.054;                                     %dt/dx
lambda = 0.054;                                     %dt/dx
T = 0.5;                                              %time
g = 9.82;

dx = model_length/M;                                %dx=dy
dt = lambda*dx;                 
Ntimesteps = floor(T/dt);                           %Number of timesteps

x_cc = [ones(M,1)]*[dx/2:dx:model_length-dx/2];     %cell centers
y_cc = x_cc';

% initial conditions on h: 
% h0 = @(x,y) 10+4*sin(2*pi*x)+2*cos(pi*y);                
% h0 = @(x,y) 10+2*sin(4*pi*x)+2*sin(pi*y);               
% h0 = @(x,y) 10 + 6*( sqrt((x-0.3).^2+(y-0.4).^2) < 0.15); 
% h0 = @(x,y) 10 + 6*(x>0.8).*(y<0.2) ; 
h0 = @(x,y) 10 + 6*(x>0.4).*(x<0.6).*(y>0.4).*(y<0.6) ; 

% w_c = [0.5 0.5];   %pos of wave peak in h0 below
% w_c = [0.6 0.3];   %pos of wave peak in h0 below
% h0 = @(x,y) 10 + 7*cos(4*pi*sqrt((x-w_c(1)).^2+(y-w_c(2)).^2))...
%             .*exp(-((x-w_c(1)).^2+(y-w_c(2)).^2)*15);

ax = [0 1 0 1 0 25];                                %figure axis


vx0 = @(x) 0;                                       %init cond vx,vy
vy0 = @(y) 0;
qx0 = @(x,y) h0(x,y).*vx0(x);                            
qy0 = @(x,y) h0(x,y).*vy0(y);

u = zeros(M,M,3);                                   %pre-allocation

u(:,:,1) = h0(x_cc,y_cc);                           %discrete init cond
u(:,:,2) = qx0(x_cc,y_cc);
u(:,:,3) = qy0(x_cc,y_cc);

f_h  = @(h,qx,qy)   qx;                             %flux f
f_qx = @(h,qx,qy)   qx.^2./h + 0.5*g*h.^2;          
f_qy = @(h,qx,qy)   qx.*qy./h;                      

g_h  = @(h,qx,qy)   qy;                             %flux g
g_qx = @(h,qx,qy)   qx.*qy./h;                      
g_qy = @(h,qx,qy)   qy.^2./h + 0.5*g*h.^2;          

f = @(u,i) [  f_h(u(:,:,1),u(:,:,2),u(:,:,3))*(i==1) + ...
              f_qx(u(:,:,1),u(:,:,2),u(:,:,3))*(i==2) + ...
              f_qy(u(:,:,1),u(:,:,2),u(:,:,3))*(i==3)         ]; 

g = @(u,i) [  g_h(u(:,:,1),u(:,:,2),u(:,:,3))*(i==1) + ...
              g_qx(u(:,:,1),u(:,:,2),u(:,:,3))*(i==2) + ...
              g_qy(u(:,:,1),u(:,:,2),u(:,:,3))*(i==3)         ]; 
         
%BC implemented with ghost cells
for i = 1:Ntimesteps
    
    h  = u(:,:,1);
    qx = u(:,:,2); 
    qy = u(:,:,3); 
    
    u_gh(:,:,1) = [0 		   , 2*h(1,:)-h(2,:)       , 0 		     	   ;
                   2*h(:,1)-h(:,2) , h                     , 2*h(:,end)-h(:,end-1) ;
                   0 		   , 2*h(end,:)-h(end-1,:) , 0                     ];  
                                  
    u_gh(:,:,2) = [0 		    , -qx(1,:)   , 0 		           ;
                   2*qx(:,1)-qx(:,2), qx         , 2*qx(:,end)-qx(:,end-1) ;
                   0 		    , -qx(end,:) , 0            	   ];
                       
    u_gh(:,:,3) = [0 	    , 2*qy(1,:)-qy(2,:)       , 0 	   ;
                   -qy(:,1) , qy 		      , -qy(:,end) ;
                   0 	    , 2*qy(end,:)-qy(end-1,:) , 0          ];
                       
 
    for n = 1:3
     
        u(:,:,n) = u_gh(2:end-1,2:end-1,n) + 1/4*(u_gh(3:end,2:end-1,n)...
            - 2*u_gh(2:end-1,2:end-1,n) + u_gh(1:end-2,2:end-1,n))...
            - lambda/2*( f(u_gh(3:end,2:end-1,:),n) - f(u_gh(1:end-2,2:end-1,:),n) )...
            + 1/4*(u_gh(2:end-1,3:end,n) - 2*u_gh(2:end-1,2:end-1,n) + 	u_gh(2:end-1,1:end-2,n))...
            - lambda/2*( g(u_gh(2:end-1,3:end,:),n) - g(u_gh(2:end-1,1:end-2,:),n));
        
    end
    
    u_saved(:,:,i) = u(:,:,1);      %save h solution for animation
    
end

%% Animation and Video Generation

type = 'LiveAnimation';
% type = 'VideoGeneration';

filename = 'waves7.avi';
framerate = 60;

modulus = 1;                        %pick every n:th frame       
fraction_of_Nsteps = 1;             %fraction of timesteps to animate
cax = [6 14];
map = gray;

switch type
    case 'LiveAnimation'
        for i = 1:floor(Ntimesteps*fraction_of_Nsteps)
            if mod(i,modulus)==0
                figure(1)
                mesh(x_cc,y_cc,u_saved(:,:,i))
                axis(ax) 
                caxis(cax)
                colormap(map)
            end    
        end
   
    case 'VideoGeneration'
        writerObj = VideoWriter(filename);
        writerObj.FrameRate = framerate;
        open(writerObj)
        for i = 1:floor(Ntimesteps*fraction_of_Nsteps)
            if mod(i,modulus)==0
                figure(1)
                mesh(x_cc,y_cc,u_saved(:,:,i))
                axis(ax)    
                caxis(cax)
                colormap(map)
                frame = getframe(gcf);
                writeVideo(writerObj, frame)
            end    
        end
        close(writerObj)     
end
