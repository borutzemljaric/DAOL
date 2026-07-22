function Ut=wind_scenario_hammer(t,omega,Uw)
% Calculate wind velocity function as positive half-period sine wave (hammer shape).
% 
%     Parameters:
%     -----------
%     t : float or array-like
%         Time value(s)
%     omega : float
%         Angular frequency
%     Uw : float
%         Wind velocity amplitude

n=2:2:10;
del=cos(n*omega*t)./(n.^2-1);
Ut=Uw/pi()+Uw*sin(omega*t)/2-2*Uw*sum(del)/pi();




%%  za risanje grafa

% 
% k=1
% U=20
% w=0.392
% for t=0:0.1:40
% n=2:2:10
% 
% del=cos(n*w*t)./(n.^2-1);
% Ut(k)=U/pi()+U*sin(w*t)/2-2*U*sum(del)/pi();
% tt(k)=t;
% k=k+1;
% end
% plot (tt,Ut,'-k','LineWidth',1.5)
%  ylabel('Hitrost vetra (m/s)','fontsize',12)
%  xlabel('Èas (s)','fontsize',12)
%  ylabel('Wind velocity (m/s)','fontsize',12)
%  xlabel('Time (s)','fontsize',12)
 