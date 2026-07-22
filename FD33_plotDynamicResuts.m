function FD33_plotDynamicResuts

% Note:
% There are too many options for plotting results. 
% For example, there are options for the number of spans and scenarios to be compared, 
% as well as which spans to plot. Perhaps more files should be presented. 
% For this reason, the PLOT section should be tailored to your particular needs.
% 
% In this code, only z and x displacements are provided. 
% For the other cases, only hints on how to code are provided. 
% However, they should be carefully revisited according to your particular needs.



% List of files, in this case up to five 
  ime_datoteke1='TestFileSingle.txt'  
  ime_datoteke2='TestFile.txt' 
  ime_datoteke3='TestFile_V.txt' 
  ime_datoteke4='TestFile_3spans.txt'
  ime_datoteke5='dummy.txt' 


 [~, ime_datoteke_1, ~] = fileparts(ime_datoteke4);  % filename without extension
 [~, ime_datoteke_2, ~] = fileparts(ime_datoteke2);  % filename without extension
 [~, ime_datoteke_3, ~] = fileparts(ime_datoteke3);  % filename without extension
 [~, ime_datoteke_4, ~] = fileparts(ime_datoteke4);  % filename without extension
 [~, ime_datoteke_5, ~] = fileparts(ime_datoteke5);  % filename without extension







%% Plotting settings
% izbiraš med sredino razpetine
k=1  % span index to plot
n_krivulj=1  %number of curves to plot- (if the comparison of different scenarios is necessary, be carefull that filenames are appropriate
tip_grafa=8 % type of graph/ see bellow

    % # 1- z displacement
    % # 2 x displacement
    % # 3 zx displacement (vertical and horizontal)
    % # 4 insulator displacement Y
    % # 5 insulator displacement x
    % # 6 time display (pressing adds graph one second at a time)
    % # 7 time display for first ten seconds (simultaneous plot)
    % # 8 forces at supports Left Right
    % # 9 pole tip displacement
    % # 10 forces in insulators
    % # 11 insulator displacement in Y direction / for all insulators in span
    




%% branje datotek
 
% poenostavljeno da jemlje dva vhodna podatka
 if n_krivulj==1
 [t X_1 Y_1 Z_1 insX_1 insY_1 insZ_1 spX1 spY1]=branje(ime_datoteke_1);
 [t Flevo1 Fdesno1 Flevoins1 Fdesnoins1]=branjeSile(ime_datoteke_1);
 [Xt, Yt, Zt ]=branjeSpans(ime_datoteke_1);
 elseif n_krivulj==2 
 % za drugi graf
 [t X_1 Y_1 Z_1 insX_1 insY_1 insZ_1 spX1 spY1]=branje(ime_datoteke_1);
 [t X_2 Y_2 Z_2 insX_2 insY_2 insZ_2 spX2 spY2]=branje(ime_datoteke_2);
 [t Flevo1 Fdesno1 Flevoins1 Fdesnoins1]=branjeSile(ime_datoteke_1);
 [t Flevo2 Fdesno2 Flevoins2 Fdesnoins2]=branjeSile(ime_datoteke_2);
 elseif n_krivulj==3
 [t X_1 Y_1 Z_1 insX_1 insY_1 insZ_1 spX1 spY1]=branje(ime_datoteke_1);
 [t X_2 Y_2 Z_2 insX_2 insY_2 insZ_2 spX2 spY2]=branje(ime_datoteke_2);
 [t X_3 Y_3 Z_3 insX_3 insY_3 insZ_3 spX3 spY3]=branje(ime_datoteke_3);
  [t Flevo1 Fdesno1 Flevoins1 Fdesnoins1]=branjeSile(ime_datoteke_1);
  [t Flevo2 Fdesno2 Flevoins2 Fdesnoins2]=branjeSile(ime_datoteke_2);
  [t Flevo3 Fdesno3 Flevoins3 Fdesnoins3]=branjeSile(ime_datoteke_3);
 elseif n_krivulj==5
 % za drugi graf
 [t X_1 Y_1 Z_1 insX_1 insY_1 insZ_1 spX1 spY1]=branje(ime_datoteke_1);
 [t X_2 Y_2 Z_2 insX_2 insY_2 insZ_2 spX2 spY2]=branje(ime_datoteke_2);
 [t X_3 Y_3 Z_3 insX_3 insY_3 insZ_3 spX3 spY3]=branje(ime_datoteke_3);
 [t X_4 Y_4 Z_4 insX_4 insY_4 insZ_4 spX4 spY4]=branje(ime_datoteke_4);
 [t X_5 Y_5 Z_5 insX_5 insY_5 insZ_5 spX5 spY5]=branje(ime_datoteke_5);
  [t Flevo1 Fdesno1 Flevoins1 Fdesnoins1]=branjeSile(ime_datoteke_1);
  [t Flevo2 Fdesno2 Flevoins2 Fdesnoins2]=branjeSile(ime_datoteke_2);
  [t Flevo3 Fdesno3 Flevoins3 Fdesnoins3]=branjeSile(ime_datoteke_3);
  % could be added two more lines if needed
 else
 disp('pass, rearrange to particular need)')
 
end


mejagrafa=max(t); %pomožno da avtomatsko doloci dolžino abscise


%%  Plots

%plot(t,Z(:,k)) % p z osi
switch tip_grafa
    case 1
  hold on
   plot(t,Z_1(:,k),'-k','LineWidth',1.5) % po z osi
   plot(t,Z_1(:,k+1),'--m','LineWidth',1.5) % po z osi , uncomment if you
   plot(t,Z_1(:,k+2),'--b','LineWidth',1.5) % po z osi , uncomment if you
  % want to show the two adjacent spans
   if n_krivulj==2 
   hold on
   plot(t,Z_2(:,k),'-m','LineWidth',1.5) % po z osi 
 %  plot(t,Z_2(:,k+1),'-.og') % po z osi
   elseif n_krivulj==3 
   hold on
   plot(t,Z_2(:,k),'-m','LineWidth',1.5) % po z osi 
%   plot(t,Z_2(:,k+1),'-.og') % po z osi
   plot(t,Z_3(:,k),'-k','LineWidth',1.5) % po z osi 
%    plot(t,Z_3(:,k+1),'-.xb') % po z osi
   elseif n_krivulj==5 
   hold on
   plot(t,Z_2(:,k),'xr','LineWidth',1.5) % po z osi 
%   plot(t,Z_2(:,k+1),'-.og') % po z osi
   plot(t,Z_3(:,k),'-.b','LineWidth',1.5) % po z osi 
   plot(t,Z_4(:,k),'--m','LineWidth',1.5) % po z osi 
   plot(t,Z_5(:,k),':g','LineWidth',1.5) % po z osi 
%    plot(t,Z_3(:,k+1),'-.xb') % po z osi
  end
  %title(['Conductor displacement-midspan No.- ', num2str(k)]);
%   ylabel('Displacement z (m)','fontsize',12)
%   xlabel('Time (s)','fontsize',12)
   legend('- mid-span 1','- mid-span 2','- mid-span 3');

  ylabel('Displacement Z (m)','fontsize',12)
  xlabel('Time (s)','fontsize',12)
  %legend(strcat('span ',num2str(k))); % change if more curves is plotted
     
  set(gca,'XTick',0:2:mejagrafa)
  set(gca,'XGrid','on','YGrid','on','ZGrid','on')  
  hold off
  

    case 2
  hold on
  plot(t,X_1(:,k),'-k','LineWidth',1.5) % po x osi 
  % plot(t,X_1(:,k+1),'--k') % po x osi

  if n_krivulj==2 
    hold on
  plot(t,X_2(:,k),'--m','LineWidth',1.5) % po x osi
 % plot(t,X_2(:,k+1),'-.g') % po x osi
 elseif n_krivulj==5 
   hold on
   plot(t,X_2(:,k),'xr','LineWidth',1.5) % po z osi 
%   plot(t,Z_2(:,k+1),'-.og') % po z osi
   plot(t,X_3(:,k),'-.b','LineWidth',1.5) % po z osi 
   plot(t,X_4(:,k),'--m','LineWidth',1.5) % po z osi 
   plot(t,X_5(:,k),':g','LineWidth',1.5) % po z osi 
%    plot(t,Z_3(:,k+1),'-.xb') % po z osi
  end
 % title(['Conductor displacement-midspan No.- ', num2str(k)]);
  ylabel('Displacement X (m)','fontsize',12)
  xlabel('Time (s)','fontsize',12)

  legend(strcat('span ',num2str(k)));
 
  set(gca,'XTick',0:2:mejagrafa)
  set(gca,'XGrid','on','YGrid','on','ZGrid','on')  
  hold off
  

  case 3
  hold on
 % risanje xz grafa s narašèanjem èasa (barvno oznaèen)
  PP=zeros(size(X_1(:,k)));
  col=t;
  surface([X_1(:,k),X_1(:,k)],[Z_1(:,k),Z_1(:,k)],[PP,PP],[col,col], 'facecol','no', 'edgecol','interp','linew',2) % po x osi 
 

%   title(['Conductor displacement in midspan']);
  ylabel('Displacement Z (m)','fontsize',12)
  xlabel('Displacement X (m)','fontsize',12)
  %legend('fill as needed');
  
  %set(gca,'XTick',0:1:15)
  set(gca,'XGrid','on','YGrid','on','ZGrid','on')  
  hold off

      case 4
 % plot(t,insY_1(:,k),'-b','linewidth',1.7) % po y osi 
  plot(t,insZ_1(:,k),'-b','linewidth',1.5) % po y osi 
  if n_krivulj==2 
    hold on
 % plot(t,insY_2(:,k),'-m','linewidth',1.5) % po y osi 
  plot(t,insZ_2(:,k),'-m','linewidth',1.5) % po y osi    
  end
%   title(['Insulator displacement-No.- ', num2str(k)]);
%   ylabel('Displacement y (m)','fontsize',10)
%  %  ylabel('Displacement z (m)','fontsize',10)
  set(gca,'XGrid','on','YGrid','on','ZGrid','on')  
  hold off
  
        case 5
  plot(t,insX_1(:,k),'-b','linewidth',1.5) % po x osi
  if n_krivulj==2 
    hold on
  plot(t,insX_2(:,k),'--.m') % po x osi    
  end
%   title(['Insulator displacement-No.- ', num2str(k)]);
%   ylabel('Displacement x (m)','fontsize',10)
%   xlabel('Time (s)','fontsize',10)
%      title(['Pomik izolatorja-Št. ', num2str(k)]);
  ylabel('Displacement X (m)','fontsize',10)
  xlabel('Time (s)','fontsize',10)
 % legend('fill as needed')
  set(gca,'XTick',0:1:mejagrafa)
  set(gca,'XGrid','on','YGrid','on','ZGrid','on')  
  hold off
          
    case 6
  % inicializacija grafa
  % press space to step one time step forward

  plot(Yt(1,:),Zt(1,:)) % po y osi
  title(['Conductor displacement-No.- ', num2str(k)]);
  ylabel('Displacement z (m)','fontsize',10)
  xlabel('Time (s)','fontsize',10)
  set(gca,'XGrid','on','YGrid','on','ZGrid','on')
              
 for tt=1:numel(t) 
  hold on
  plot(Yt(tt,:),Zt(tt,:)) % po y osi
  legend(num2str(t(tt)));
  %plot(t,insY_1(:,k),'-r') % po y osi
  pause 
   
 end

          case 7
%   %tega sem predeèal da sem izrisaè razliène povese-treba špredelati nazaj
%  inicializacija grafa za 10 èasovnih trenutkov
%   % prirejeno za 10 sekund, risanje na vsako sekundo
disp(numel(t))
  tt=1:10:numel(t)
disp(numel(t))

  hold on
   % plot(Yt(tt(1),:),Zt(tt(1),:)+3,'-k','linewidth',1.5) % po y osi
   % text(Yt(tt(1),3),Zt(tt(1),3),strcat(num2str(t(tt(1))),'s'),'fontsize',12)
  plot(Yt(tt(1),:),Zt(tt(1),:),'--k','linewidth',1.5) % po y osi
  text(Yt(tt(1),2),Zt(tt(1),2),strcat(num2str(t(tt(1))),'s'),'fontsize',12)
  plot(Yt(tt(2),:),Zt(tt(2),:),'-r') % po y osi
  text(Yt(tt(2),2),Zt(tt(2),2),strcat(num2str(t(tt(2))),'s'),'fontsize',12)
  plot(Yt(tt(3),:),Zt(tt(3),:),'--.g') % po y osi
  text(Yt(tt(3),2),Zt(tt(3),2),strcat(num2str(t(tt(3))),'s'),'fontsize',12)
  plot(Yt(tt(4),:),Zt(tt(4),:),'-b') % po y osi
  text(Yt(tt(4),2),Zt(tt(4),2),strcat(num2str(t(tt(4))),'s'),'fontsize',12) 
  plot(Yt(tt(5),:),Zt(tt(5),:),'-c') % po y osi
  text(Yt(tt(5),2),Zt(tt(5),2),strcat(num2str(t(tt(5))),'s'),'fontsize',12)
  plot(Yt(tt(6),:),Zt(tt(6),:),'-m') % po y osi
  text(Yt(tt(6),3),Zt(tt(6),3),strcat(num2str(t(tt(6))),'s'),'fontsize',12)  
  plot(Yt(tt(7),:),Zt(tt(7),:),'--r') % po y osi
  text(Yt(tt(7),3),Zt(tt(7),3),strcat(num2str(t(tt(7))),'s'),'fontsize',12)   
  plot(Yt(tt(8),:),Zt(tt(8),:),'--m','linewidth',1.5) % po y osi
  text(Yt(tt(8),3),Zt(tt(8),3),strcat(num2str(t(tt(8))),'s'),'fontsize',12)   
  plot(Yt(tt(9),:),Zt(tt(9),:),'--b') % po y osi
  text(Yt(tt(9),3),Zt(tt(9),3),strcat(num2str(t(tt(9))),'s'),'fontsize',12)  
  plot(Yt(tt(10),:),Zt(tt(10),:),'--m') % po y osi
  text(Yt(tt(10),3),Zt(tt(10),3),strcat(num2str(t(tt(10))),'s'),'fontsize',12)  

 % title('Time histories ');
  ylabel('Poves Z (m)','fontsize',12)
  xlabel('Y (m)','fontsize',12)
  set(gca,'XTick')
  set(gca,'XGrid','on','YGrid','on','ZGrid','on')
  
  case 8 %risanje sil v obesišèih vodnika na koncih napenjalnega polja
  hold on
  plot(t,Fdesno1,'-b','LineWidth',1.) % levo obesišèe
  plot(t,Flevo1,'--m','MarkerSize',4,'LineWidth',1) % desno obesišèe
%   plot(t,Flevoins1,'-r','LineWidth',1) % izolator
%   
 
   if n_krivulj==2 
   hold on
   plot(t,Z_2(:,k),'-k') % po z osi   
  end
  %title(['Conductor displacement-midspan No.- ', num2str(k)]);
   ylabel('Absolute force(N)','fontsize',12)
   xlabel('Time (s)','fontsize',12)
   legend('Right tower T1','Left tower T2');

  
  set(gca,'XTick',0:1:mejagrafa)
  set(gca,'XGrid','on','YGrid','on','ZGrid','on')  
  hold off
   
  case 9

  hold on
 % display(spX1)
   plot(t,spX1(:,k),'-b','linewidth',1.5) % po z osi
%   plot(t,spX2(:,k),'-m') % po z osi
%   plot(t,spX3(:,k),'-k') % po z osi
 plot(t,spY1(:,k),'-r','linewidth',1.5) % po z osi

   if n_krivulj==2 
%    hold on
%    plot(t,Z_2(:,k),'-b') % po z osi 
%    plot(t,Z_2(:,k+1),'--g') % po z osi
  end
  %title(['Conductor displacement-midspan No.- ', num2str(k)]);
  ylabel('Pomik (m)','fontsize',12)
  xlabel('Èas (s)','fontsize',12)
  legend('-smer X','-smer Y','-smer Z',1);
  
  set(gca,'XTick',0:2:mejagrafa)
  set(gca,'XGrid','on','YGrid','on','ZGrid','on')  
  hold off
  
  if n_krivulj==2 
 % legend('-1 mid-span-M1','-1 mid-span-M2','-2 mid-span-M1','-2 mid-span-M2',1);
  end
%   set(gca,'XTick',0:1:mejagrafa)
%   set(gca,'XGrid','on','YGrid','on','ZGrid','on')  
%   hold off
  
  case 10 %risanje sil v obesišèih izolatorja
      
 plot(t,Flevoins1(:,k),'-b','linewidth',1.5) % P izolator
% hold on
 plot(t,Fdesnoins1(:,k),'-ob','linewidth',1.5) % B izolator
  
   if n_krivulj==2 
   hold on
   plot(t,Flevoins2(:,k),'-m','linewidth',1.5) % po velja za I del sestava
   plot(t,Fdesnoins2(:,k),'-om','linewidth',1.5) % po za B del sestava
  
  %Fdesnoins
  end
 % title(['Insulator assembly No.- ', num2str(k)]);
  ylabel('Absolutna sila v obesišèu na stebru (N)','fontsize',12)
  xlabel('Èas (s)','fontsize',12)
 % legend('Tower-Insulator point p',1);
  %legend(leg_1,leg_2,1);
  legend('-P-M1','-P-M2');
  %legend('-B-M1','-B-M2');
 % legend('-B');
  %legend('-P');
  xlim([00 20]) 
  set(gca,'XTick',0:1:mejagrafa)
  set(gca,'XGrid','on','YGrid','on','ZGrid','on')  
  hold off
  
  case 11   %pomik izolatorja v Y smeri/ za vse izolatorje v razpetini
            % roèno zamenjaj Y ali X smer (treba dodelati v prihodnosti)
  plot(t,insY_1) % po Y osi 
%   plot(t,insX_1) % po X osi 
%   plot(t,Z_1) % po Z osi velja za sredino razpetine
%   plot(t,X_1) % po Z osi velja za sredino razpetine
  if n_krivulj==2 
    hold on
  plot(t,insY_2) % po y osi
  plot(t,insX_2) % po X osi 
  end
 % title(['Insulator displacement-No.- ', num2str(k)]);
  ylabel('Displacement y (m)','fontsize',10)
 %  ylabel('Displacement z (m)','fontsize',10)
 % ylabel('Displacement x (m)','fontsize',10)
  xlabel('Time (s)','fontsize',10)
   legend('insulator I1','insulator I2','insulator I3',1);   %poenostavim ker vem da so trije
   legend('mid-span No.1','mid-span No.2','mid-span No.3','mid-span No.4',1);   %poenostavim ker vem da so trije

   set(gca,'XTick',0:1:mejagrafa)
  set(gca,'XGrid','on','YGrid','on','ZGrid','on')  
  hold off

  
end




%% a function that determines coordinate indices
   function[t, X, Y, Z, insX, insY, insZ, spX, spY]=branje(ime_datoteke)
 %odpiranje 'dinamika_POST_'
ime_datoteke_load=strcat('yDYNpost_',ime_datoteke); %assemble file name for data load
load(ime_datoteke_load, 'hh','ne_c','tipverige','zacpog','zacpog_db','t','izhod_e_a');  %shranjevanje variabel v to datoteko

% stevilo elementov
v=numel(zacpog); %zacpog je podan v stolpcu
n=v/12; % število elementov (elementi vodnika+ elementi izolatorjev)


% Doloèitev zap števila koordinate ki se izriše v grafu
 i=1:hh-1;

 % klic zunanje funkcije
 % vhod 12 mora biti ker imam koordinate
[X1,insX1,insX1dA,spX1,insX1levi,insX1desni]=indeksiKoordinat(tipverige,hh,ne_c,12);

%% prepis izbranih koordinat v posebno tabelo
% X1 velja za sredino razpetine
% insX1 velja za koordinato verige
  
% koordinate ki obravnava sredino razpetine
X=izhod_e_a(:,X1+0);
Y=izhod_e_a(:,X1+1); 
Z=izhod_e_a(:,X1+2);

%Koordinate ki obravnavajo konico V obešanja ali I
insX=izhod_e_a(:,insX1+0);
insY=izhod_e_a(:,insX1+1);
insZ=izhod_e_a(:,insX1+2);

% koordinate ki obravnavajo konico pola (vzeto kot druga stan brace
% izolatorja)
spX=izhod_e_a(:,spX1+0);
spY=izhod_e_a(:,spX1+1);
spZ=izhod_e_a(:,spX1+2);

% relativni odmik za koordinate Z
Z_zacetni=zacpog(X1+2);%Z_0=Z(1,:); % prepis prvega (statiènega ) rezultata v neodlonjenem stanju
Z_0= repmat(Z_zacetni',numel(t),1); % razmnožitev na velikost matrike

% Z_zacetni=zacpog_db(X1+2)-zacpog(X1+2);%Z_0=Z(1,:); % prepis prvega (statiènega ) rezultata v neodlonjenem stanju
% Z_nicelni= repmat(Z_zacetni',numel(t),1); % razmnožitev na velikost matrike
% Z=Z-Z_nicelni; %  za primer Morgan odštevanje da dobim relativno razliko %her je z drugaèe v absolutnih koordinatah

Z=Z-Z_0; % odštevanje da dobim relativno razliko %her je z drugaèe v absolutnih koordinatah

% relativni odmik za koordinate X
X_zacetni=zacpog(X1+0);%Z_0=Z(1,:); % prepis prvega (statiènega ) rezultata v neodlonjenem stanju
X_0= repmat(X_zacetni',numel(t),1); % razmnožitev na velikost matrike
X=X-X_0; % odštevanje da dobim relativno razliko %her je z drugaèe v absolutnih koordinatah

if hh>2  % insulators are only in multiple stan tension field
% relativni odmik za koordinate izolatorja insZ
insZ_zacetni=zacpog(insX1+2); % prepis prvega (statiènega ) rezultata
insZ_0= repmat(insZ_zacetni',numel(t),1); % razmnožitev na velikost matrike
insZ=insZ-insZ_0; % odštevanje da dobim relativno razliko %her je z drugaèe v absolutnih koordinatah

% relativni odmik za koordinate izolatorja insy
insY_zacetni=zacpog(insX1+1);%Z_0=Z(1,:); % prepis prvega (statiènega ) rezultata v neodlonjenem stanju
insY_0= repmat(insY_zacetni',numel(t),1); % razmnožitev na velikost matrike
insY=insY-insY_0; % odštevanje da dobim relativno razliko %her je z drugaèe v absolutnih koordinatah
end


%ta del je treba predelati da bo ustrezal SP primeru
if tip_grafa==9 % zanka ki racuna samo za steel pole primer
% relativni odmik za koordinate stel pole spX
spX_zacetni=zacpog(spX1+0); % prepis prvega (statiènega ) rezultata
spX_0= repmat(spX_zacetni',numel(t),1); % razmnožitev na velikost matrike
spX=spX-spX_0; % odštevanje da dobim relativno razliko %her je z drugaèe v absolutnih koordinatah
% relativni odmik za koordinate izolatorja SPY
spY_zacetni=zacpog(spX1+1);%Z_0=Z(1,:); % prepis prvega (statiènega ) rezultata v neodlonjenem stanju
spY_0= repmat(spY_zacetni',numel(t),1); % razmnožitev na velikost matrike
spY=spY-spY_0; % odštevanje da dobim relativno razliko %her je z drugaèe v absolutnih koordinatah
%
spZ_zacetni=zacpog(spX1+2);%Z_0=Z(1,:); % prepis prvega (statiènega ) rezultata v neodlonjenem stanju
spZ_0= repmat(spZ_zacetni',numel(t),1); % razmnožitev na velikost matrike
spZ1=spZ-spZ_0; % odštevanje da dobim relativno razliko %her je z drugaèe v absolutnih koordinatah
%
else
spX=[];
spY=[];
end
%  display(size(t))
%  display(size(Z))
   end


%% funkcija ki doloèi indekse  za izpis sil
   function[t ,Flevo, Fdesno, Flevoins, Fdesnoins]=branjeSile(ime_datoteke)
 %odpiranje 'dinamika_POST_'
ime_datoteke_load=strcat('yDYNpost_',ime_datoteke); %assemble file name for data load
load(ime_datoteke_load, 'ime_datoteke1','hh','ne_c','tipverige','zacpog','zacpog_db','t','izhod_Flevo','izhod_Fdesno');  %shranjevanje variabel v to datoteko

%% stevilo elementov
 v=numel(izhod_Flevo(1,:)); %število elementov, (sil v levem delu elementa)
% i=1:hh-1; % stevilo razpetin
% 
%Za sile v vrvi se zaenkrat odloèim da jih izpisem samo na zacetku in koncu napenjalnega poolja, torej skrajno levo in skrajno desno
% dodam še skrajno desnega
Xlevo=1; % 
Xdesno=v-2;

 % klic zunanje funkcije
 % vhod 3 mora biti ker imam sile
[X1,insX1,insX1dA,spX1,insX1levi,insX1desni]=indeksiKoordinat(tipverige,hh,ne_c,3);

%% prepis izbranih koordinat v posebno tabelo
% X1 velja za sredino razpetine
% insX1 velja za koordinato verige

%% velja za levo in desno stran napenjalnega polja
% sile v posamezni smeri (xyz)
FXlevo=izhod_Flevo(:,Xlevo+0);
FYlevo=izhod_Flevo(:,Xlevo+1);
FZlevo=izhod_Flevo(:,Xlevo+2);

FXdesno=izhod_Fdesno(:,Xdesno+0);
FYdesno=izhod_Fdesno(:,Xdesno+1);
FZdesno=izhod_Fdesno(:,Xdesno+2);

% absolutne vrednosti sil levo in desno obesišèe napenjalnega polja
Flevo=(FXlevo.^2+FYlevo.^2+FZlevo.^2).^(1/2);
Fdesno=(FXdesno.^2+FYdesno.^2+FZdesno.^2).^(1/2);


%% velja za izolatorje
 FinsX=[];
 FinsY=[];
 FinsZ=[];
 Flevoins=[];
 Fdesnoins=[];

% za obesišèe izolatorja na steber za A verigo 
for i=1:(hh-1)-1
if tipverige(i+1)==5
 FinsX=izhod_Fdesno(:,insX1levi(i)+0)+izhod_Fdesno(:,insX1desni(i)+0);
 FinsY=izhod_Fdesno(:,insX1levi(i)+1)+izhod_Fdesno(:,insX1desni(i)+1);
 FinsZ=izhod_Fdesno(:,insX1levi(i)+2)+izhod_Fdesno(:,insX1desni(i)+2);
  FinsX=izhod_Fdesno(:,insX1desni(i)+0);
 FinsY=izhod_Fdesno(:,insX1desni(i)+1);
 FinsZ=izhod_Fdesno(:,insX1desni(i)+2); 
%  display([izhod_Fdesno(1,insX1levi(i)+0) izhod_Fdesno(1,insX1desni(i)+0)])
%      display([izhod_Fdesno(1,insX1levi(i)+1) izhod_Fdesno(1,insX1desni(i)+1)])
%      display([izhod_Fdesno(1,insX1levi(i)+2) izhod_Fdesno(1,insX1desni(i)+2)])
%      st
 Flevoins(:,i)=(FinsX.^2+FinsY.^2+FinsZ.^2).^(1/2); 
elseif tipverige(i+1)==6||tipverige(i+1)==3

%  FinsX=izhod_Fdesno(:,insX1levi(i)+0);
%  FinsY=izhod_Fdesno(:,insX1levi(i)+1);
%  FinsZ=izhod_Fdesno(:,insX1levi(i)+2); 
%  Flevoins(:,i)=(FinsX.^2+FinsY.^2+FinsZ.^2).^(1/2);
%  FinsX=izhod_Fdesno(:,insX1desni(i)+0);
%  FinsY=izhod_Fdesno(:,insX1desni(i)+1);
%  FinsZ=izhod_Fdesno(:,insX1desni(i)+2); 
%  Fdesnoins(:,i)=(FinsX.^2+FinsY.^2+FinsZ.^2).^(1/2);

 FinsX=izhod_Fdesno(:,insX1levi(i)+0);
 FinsY=izhod_Fdesno(:,insX1levi(i)+1);
 FinsZ=izhod_Fdesno(:,insX1levi(i)+2); 
 Flevoins(:,i)=(FinsX.^2+FinsY.^2+FinsZ.^2).^(1/2);
 FinsX=izhod_Fdesno(:,insX1desni(i)+0);
 FinsY=izhod_Fdesno(:,insX1desni(i)+1);
 FinsZ=izhod_Fdesno(:,insX1desni(i)+2); 
 Fdesnoins(:,i)=(FinsX.^2+FinsY.^2+FinsZ.^2).^(1/2);
 elseif tipverige(i+1)==4
insX1levi(i)=insX1(i)+3;
insX1desni(i)=insX1(i);
  FinsX=izhod_Fdesno(:,insX1levi(i)+0);
 FinsY=izhod_Fdesno(:,insX1levi(i)+1);
 FinsZ=izhod_Fdesno(:,insX1levi(i)+2); 
 Flevoins(:,i)=(FinsX.^2+FinsY.^2+FinsZ.^2).^(1/2);
 FinsX=izhod_Fdesno(:,insX1desni(i)+0);
 FinsY=izhod_Fdesno(:,insX1desni(i)+1);
 FinsZ=izhod_Fdesno(:,insX1desni(i)+2); 
 Fdesnoins(:,i)=(FinsX.^2+FinsY.^2+FinsZ.^2).^(1/2);
else  % velja za I verigo
 % sila na levem delu izolatorja (vpetišèe na vodnik)
% FinsX=izhod_Flevo(:,insX1(i)+0);
% FinsY=izhod_Flevo(:,insX1(i)+1);
% FinsZ=izhod_Flevo(:,insX1(i)+2);

% sila (v bistvu reakcija) na vpetišèu izolatorja na steber
FinsX=izhod_Fdesno(:,insX1(i)+0);
FinsY=izhod_Fdesno(:,insX1(i)+1);
FinsZ=izhod_Fdesno(:,insX1(i)+2);   
Flevoins(:,i)=(FinsX.^2+FinsY.^2+FinsZ.^2).^(1/2);   
end
end
    
   end


%% funkcija ki doloèi koordinate vodnika skozi vcelotno napenjalno polje
% za vizualizacijo posameznih trenutkov simulacije
   function[Xt, Yt, Zt ]=branjeSpans(ime_datoteke)
 %odpiranje 'dinamika_POST_'
ime_datoteke_load=strcat('yDYNpost_',ime_datoteke); %assemble file name for data load
load(ime_datoteke_load, 'zacpog','izhod_e_a');  %shranjevanje variabel v to datoteko

%% stevilo elementov
v=numel(zacpog); %zacpog je podan v stolpcu
n=v/12; % število elementov (elementi vodnika+ elementi izolatorjev)


%% Doloèitev zap števila koordinate ki se izriše v grafu
i=1:n;

%zaporedna številka koordinate X Y Z
qI=(i-1)*12+1;   %število vozlišè elementov vodnika 
% dodati moram še zadnje vozlišèe
X1=[qI (n-1)*12+7];

% koordinate vozlišè
Xt=izhod_e_a(:,X1+0);
Yt=izhod_e_a(:,X1+1);
Zt=izhod_e_a(:,X1+2);

   end

end

