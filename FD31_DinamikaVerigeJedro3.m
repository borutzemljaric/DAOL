function FD31_DinamikaVerigeJedro3
%  modul ki izvaja dimamièni izraèun
clear

%% Branje vhodnih datotek s podatki
%  [ime_datoteke1, pathname] = ...
%       uigetfile({'*.txt','*.*'},'File Selector');  %izbereš datoteko z vhodnimi podatki 
%  [~, ime_datoteke1, ext] = fileparts(ime_datoteke1);  % odrežem extension od imena datoteke

% CHOSE YOUR FILE
  %ime_datoteke1='TestFileSingle.txt'  
  %ime_datoteke1='TestFile.txt' 
  %ime_datoteke1='TestFile_V.txt' 
  ime_datoteke1='TestFile_3spans.txt' 
  

[~, ime_datoteke2, ~] = fileparts(ime_datoteke1);  % filename without extension
ime_datoteke_pure=ime_datoteke2; %filename without extension used at saving simulation results
ime_datoteke2=strcat('ySTAT_',ime_datoteke2,'.mat'); %assemble file name for data load
 
load(ime_datoteke2, 'ime_datoteke1','hh','ne_c','m_c','d_c','le','db',...
    'ne_i','izo','E_c','A_c','tipverige','DK');  %read
 
load(ime_datoteke2,'Ce_active','Ce_1_active','konstante'); %read 

load(ime_datoteke2,'Bdi','U','V','Cdi','Ced');   %read 

load(ime_datoteke2,'M');  %read

load(ime_datoteke2, 'zacpog','zacpog_db','zacpog_db_W','Qe','Qe_g','Qe_db');



g=9.81; % pospešek m/s2



%%  Time parameters
 tstart=0;  %Start always at 0 seconds!
 tfinal=10;  %Simulation length( s)
 tsim=.5; % Time delay, real start of simulation (left of that time is static for better visualize simulation start)
 interval=2; %Splitting whole simulation time into more shorter intervals, for better efficiency (v s)
 ste_delitev=round(tfinal/interval);  % Calculated number of divisions, rounded (n=tfinal/interval)
 korak=0.1; %Time step to save in results file (ode function)


 % Time parameters for load shedding scenarios
 time.s=tsim; % Start of shedding (s), given already in tsim
 time.d=0.005; %Time of ice shedding (s)
 
 
 %Wind parameters for hammer case
 % Uw=20; % wind speed in m/s
 % alfa=2*pi()/5; %angle of attack in rad
 % omega=0.392;  % angular velocity in s-1

 
%% tvorjenje zaèetnih pogojev za reševanje ODE
  %tvorjenja vektorja zaèetnih pogojev za dinamièno simulacijo koordinata + zaèetna hitrost
  ni=numel(V);  % število neodvisni koordinat in parametrov
  nd=numel(U);  % število odvisnih koordinat in parametrov
  i=1:ni;   %tvorim indeks  števila koordinat
 
  % prepis iz skupne spremenljivke v loèene po neodvisnih in odvisnih
  % koordinatah
  %brez vetra
  %neodvisneV=zacpog_db(V',1);
  %odvisneU=zacpog_db(U',1);
  %z vetrom
  neodvisneV=zacpog_db_W(V',1);
  odvisneU=zacpog_db_W(U',1);
  
  neodvisneVdot=zeros(ni,1); % definiram da miruje pri zacetku simulacije (hitrost je enaka 0)
  odvisneUdot=zeros(nd,1); % prepisani zaèetni pogoji hitrosti, ponovo vzamemm da miruje
  e_zp=zacpog; % potrebujem za doloèitev konstant, samo prepisem da v nadaljevanju voim pod svojo spremenljivko zaradi preglednosti
  

  % pogoje prenesem iz statike
  zacpog_ode(2*i-1,1)= neodvisneV;%zaèetni pogoji zapisani v vsako drugo vrstico, stolpièni vektor
  zacpog_ode(2*i,1)= neodvisneVdot;%zaèetni pogoji zapisani v vsako drugo vrstico, stolpicni vektor
  
  %% ker imam opraviti s konstantnimi omejitvami in isto razporeditvijo
  % odvisne- neodvisne koordinate lahko pišem naslednje matrike (se skozi
  % simulacijo ne spreminjajo)
  %osnovne matrike so v 'izvornem' vrstnem redu zato pretvorba v odvisne-neodvisne
  Ce=Ce_active(:,[U V]); % zamenjava elementov matrike v vrstni red odvisne-neodvisne 
  
  
  % the meaning of the loads Qe, Qe_g, Qe_db -those are read from STATIC calculation   
  % Qe: full weight  - additional load + conductor self-weight at start (t=0)
  % Qe_g: pure conductor and insulators generalised force
  % Qe_db: additional load at the end of simulation (remaining part of load after shedding -if exist!)) 


  Qe_breme=Qe-Qe_g; %  Qe prior simulation, Qe_g only conductor, subtraction gives PURE ICE LOAD (Qe_breme) at the start of simulation
  Qe_gg=Qe_g+Qe_db; % final load (conductor self-weight + final additional load that stays on conductor (if there is any!)

  % zamenjava vrstnega reda
  Qe=Qe([U'; V'],1);
  Qe_breme=Qe_breme([U'; V'],1);
  Qe_gg=Qe_gg([U'; V'],1);
  
  M=M(:,[U';V']); %zamenjava stolpcev v vrstni red V,U,konst
  M=M([U';V'],:); %zamenjava vrstic v vrstni red V,U,konst
  
  % odvod omejitev po koordinati in nato po èasu
  qc=zeros(nd,1); % ta je enak nic zaradi karakterja omejitev
  qv=0; % in ANCF Cariolis force is zero

 
  
  %% Loop that solve equation of motions
 t_o=0;
 for uu=1:ste_delitev 
  tspan=t_o:korak:t_o+interval; % èasovni razpon s korakom 
  display(strcat('interval -',num2str(uu),' of -  ', num2str(ste_delitev))) %obvestilo da vemo kje je izraèun

  %diferencialna enaèba za reševanje dif enaèb gibanja
  %options=odeset('AbsTol',1e-4,'Refine',1);
 %[t,Z] = ode45(@sistem_enacb,tspan,zacpog_ode');  %izraèun dif enaèb
 [t,Z] = ode15s(@sistem_enacb,tspan,zacpog_ode);  %izraèun dif enaèb

[q,u]=size(Z); %da vzamem zadnji stolpec kot zaèetne pogoje, èe se razdelil naq veè intervalov
r=1:u/2;
display('End of Integration')
lamb=0; %pustim zaenkrat rabim v nadaljevanju

 

%postavitev novih zaèetnih pogojev


 % end

 ime_datoteke2=strcat(num2str(uu),'e_dinamicni_',ime_datoteke_pure,'.mat'); %sestavljanje imena datoteke in koncnice
 %ime_datoteke2=strcat(num2str(uu),ime_datoteke1); %sestavljanje imena datoteke in koncnice
%ime_datoteke2=strcat(num2str(zapis),ime_datoteke1); %sestavljanje imena datoteke in koncnice
%save(ime_datoteke2, 'ime_datoteke1','pari_kontakt','ne_c','index','zacpog','zacpog_ode','t','Z','lamb','V','se');  %shranjevanje variabel v to datoteko
save(ime_datoteke2, 'ime_datoteke1','Z','t','ste_delitev');  %shranjevanje variabel v to datoteko

zacpog_ode=Z(q,1:u)';  %prepis izraèuna koordinat in zaèetnih odvodov ob koncu intervala v datoteko zaèetnih pogojev
t_o=t_o+interval;
clear Z t;

 end

 %add information about time data and load scenarios into first file
ime_datoteke2=strcat('1','e_dinamicni_',ime_datoteke_pure,'.mat'); %sestavljanje imena datoteke in koncnice
save(ime_datoteke2, 'time','-append');  %shranjevanje variabel v to datoteko 

disp('-------------------------------------------');  
disp('End of dynamic calculation');
disp('Proceed with post-processing calculation');

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


function dz=sistem_enacb(t,z)

   % i=1:ni;  %iz vrstice 31
    e_a(U',1)=odvisneU; % odvisne koordinate, sestava vektorja e_a
    e_a(V',1)=z(2*i-1); % neodvisne koordinate, sestava vektorja e_a   
    neodvisneV=z(2*i-1); % samo prepis zaradi delovanja programa
    neodvisneVdot=z(2*i);  % hitrosti tekom iteracij
     %neodvisneVdot(:,1)=z(2*i);  % hitrosti tekom iteracij
     %??????????????????????????????????????????????
%pause  
%display(t)
% sv=numel(e_a);
% ttt=1:12:sv;
% tocke_x=[(ttt+1)';sv-4];
% tocke_y=[(ttt+2)';sv-3];
% plot(e_a(tocke_x),e_a(tocke_y),'-.r*',e_zp(tocke_x),e_zp(tocke_y),'-.bx',zacpog_db(tocke_x),zacpog_db(tocke_y),'-.g+');
% hold on
% %pause



% sestava vektorja hitrosti- v originalni vrstni red 
 qdot(U',1)=odvisneUdot;
 qdot(V',1)=neodvisneVdot;
 % najprej izraèunam nove odvisne in jih vstavim v e_a
 odvisneU=odvi_U(odvisneU,hh,ne_c,neodvisneV,V,U,tipverige,e_zp);
 e_a(U',1)=odvisneU;  % vpišem nove vrednosti za odvisneU , neodvisne še vedno smatram kot neodvisne

 % e_zp so vse koordinate, urejene po vrstnem redu vodnik-omejitve-parameri
 % e_a so trenutne vrednosti zato se znotraj programa trenutno obrnejo


%% 4 ponovni izracun Ce
 % ker so omejitve èasovno konstantne  preberem že v statiki izracunane 
% 'Cdi','Ced'

%odvod Ct in odvod Ctt je sta enaka nic in jih v nadaljevanju ne obravnavam
%Ct=0
%Ctt=0
 

%% 5 %izraèun odvisnih hitrosti qdot
% izracun odvisnih hitrosti
%odvisneUdot=Cdi*neodvisneVdot-Ced\Ct;
odvisneUdot=Cdi*neodvisneVdot; %ker je Ct=0
%display(odvisneUdot)
% 
% pause



%% 6 izracun masne matrike, zunanjih in elasiènih sil, ter sestava sistema enacb po Shabana, Sany

%Ce prebran zgoraj
%Qe- skupaj z dodatnim bremenom
%Qe_g samo lastna masa vodnika

% WIND SCENARIOS  /uncomment if dealing with this scenario 
% [Qeg_0,DK]=wind_scenario_hammer(t,omega,Uw,DK,Qe)


% LOAD SCENARIOS
Qeg_0=load_scenario_1(t, time, Qe, Qe_g, Qe_breme, Qe_gg);

 % funkcija qkqt ter spodaj še za veter in dušenje qwqd
qkqt=elastic_Qk_Qt_verige(neodvisneV,odvisneU,V,U,hh,ne_c,E_c,A_c,le,d_c,ne_i,tipverige,izo);
qwqd=damp_wind_Qd_Qw_verige(neodvisneV,odvisneU,neodvisneVdot,odvisneUdot,V,U,hh,ne_c,E_c,A_c,le,d_c,m_c,tipverige,izo,DK);  %tvorjenje relativnega raztezka za korak t-1 (en korak nazaj)
%  display(size(qkqt))
%  display(size(qwqd))
%  st
qkqt=qkqt-qwqd; %Šeštejem elastièno in dušilne sile
% funkcija ki
% 2a: sedaj  izvedem zamenjavo v vrstni red odvisne neodvisne
qkqt=qkqt([U'; V'],1);
%M prebran zgoraj
 %display(M)

%% 7 izraèun pospeška koordinat in lagrangeovih koeficientov
%augment

[pdotdot, lambda ]=pdotdot_lagrange(M,Qeg_0,qkqt,qv,qc,Ce);
%stop
% display([full(pdotdot)  [U'; V']])
% pause

%% 8 izraèun reakcij
%Qreakcije=-Ce.'*lambda
%stop

%% 9 doloèitev neodvisnih koordinat

%y=[neodvisneV; neodvisneVdot]

 %tvorjenje matrike pospeškov s prehodom na sistem dif enaèb 1 reda
dz = zeros(2*ni,1);
%i=1:ni; 
%display(i) 
dz(2*i-1)=z(2*i);  %koordinata z prva enaèba enaèba
dz(2*i)=pdotdot(nd+1:nd+ni,1); %koordinata z druga enaèba


end  % konec funkcije sistem enaèb



end

