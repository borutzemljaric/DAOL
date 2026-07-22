

%% podatki o èasih simulacije 
 tstart=0;
 tfinal=20;  %Èas simulacije (v s)
 tw=[5 10 15]; %intervali delovanja vetra
 Wp=5; %hitrost vetra smer y/ samo prepis da lahko izvajam intervale
t=1:0.1:tfinal
 for i=1:numel(t)
% sledi pogoj intervalov delovanja vetra
% odlocim se za fiksni interval po 5 s, s tem da zacnem s polnim vetrom
if t(i)<tw(1)
W(i)=0; %hitrost vetra smer y/ samo prepis da lahko izvajam intervale
elseif t(i)>=tw(1)&& t(i)<tw(2)
W(i)=Wp; %hitrost vetra smer y/ samo prepis da lahko izvajam intervale
elseif t(i)>=tw(2)&& t(i)<tw(3)
W(i)=0; %hitrost vetra smer y/ samo prepis da lahko izvajam intervale
else 
W(i)=Wp; %hitrost vetra smer y/ samo prepis da lahko izvajam intervale
end
end

  plot(t,W,'-ok') % izolator
  

  ylabel('Hitrost vetra (m/s)','fontsize',12)
  xlabel('Time (s)','fontsize',12)
%   legend('Tower-Insulator point p',1);
%   legend('U=5m/s');
  set(gca,'XTick',0:1:20)
  set(gca,'XGrid','on','YGrid','on','ZGrid','on')  
  hold off


