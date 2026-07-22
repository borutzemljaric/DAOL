function F201_postprocesiranje_2
% izraèun reakcij z osnovnim vrstnim redom
%% Branje datotek s podatki 

%doloèitev katero datoteko obdelujem
%  [ime_datoteke1, pathname] = ...
%       uigetfile({'*.txt','*.*'},'File Selector');  %izbereš datoteko z vhodnimi podatki 
%  [~, ime_datoteke1, ext] = fileparts(ime_datoteke1);  % odrežem extension od imena datoteke
  
% CHOSE YOUR FILE
  ime_datoteke1='TestFileSingle.txt'  
  %ime_datoteke1='TestFile.txt' 
  %ime_datoteke1='TestFile_V.txt' 
  ime_datoteke1='TestFile_3spans.txt' 
  
[~, ime_datoteke2, ~] = fileparts(ime_datoteke1);  % filename without extension
ime_datoteke_pure=ime_datoteke2; %filename without extension used at saving simulation results
ime_datoteke2=strcat('ySTAT_',ime_datoteke2,'.mat'); %assemble file name for data load


% % izbor procesirANJE BREME ALI VETER
% izbor_bremeAliVeter=1; %breme
% %izbor_bremeAliVeter=2; % veter
% 
% switch (izbor_bremeAliVeter)
%    case 1
%       disp('prazno')
%    case 2
%    %Podatki vezani na veter% 
%    Uw=20; % hitrost vetra v m/s
%    alfa=2*pi()/5; %kot vpada vetra
%    omega=0.392;  % kotna hitrost s-1
% end


load(ime_datoteke2, 'ime_datoteke1','hh','ne_c','m_c','d_c','le','db',...
    'ne_i','izo','E_c','A_c','tipverige','DK');  %shranjevanje variabel v to datoteko
 
load(ime_datoteke2,'Ce_active','Ce_1_active','konstante');

load(ime_datoteke2,'Bdi','U','V','Cdi','Ced');   %Branje 

load(ime_datoteke2,'M');  %shranjevanje variabel v to datoteko

load(ime_datoteke2, 'zacpog','zacpog_db','zacpog_db_W','Qe','Qe_g','Qe_db');

 %load information about time data
%   information about time data and load scenarios are in the first file
%   from dynamic calculation
ime_datoteke2=strcat('1','e_dinamicni_',ime_datoteke_pure,'.mat'); %sestavljanje imena datoteke in koncnice
load(ime_datoteke2, 'time');  %shranjevanje variabel v to datoteko  

%% sestava vektorja koordinat, ker dinamika zapise v vec datotek zaradi omejitev spomina

% ime_datoteke2=strcat('e_dinamicni_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice
% load(ime_datoteke2, 'ime_datoteke1','Z','t');  %shranjevanje variabel v to datoteko
[Z,t]=zdruzevanjeDatotek(ime_datoteke_pure);  % MERGE results from separate files into common file!

   
 %% preparation
  g=9.81; % pospešek m/s2
  nd=numel(U); % nomber of dependant varibles

  Ce=Ce_active; %just to keep same notation of variables as in preprocessing
  Mo=M;% just to keep same notation of variables as in preprocessing
 
  Qe_breme=Qe-Qe_g; %  Qe prior simulation, Qe_g only conductor, subtraction gives PURE ICE LOAD (Qe_breme) at the start of simulation
  Qe_gg=Qe_g+Qe_db; % final load (conductor self-weight + final additional load that stays on conductor (if there is any!)
%rezultat osnovni vrstni red
 
  


 %% B. izraèun VSEH koordinat preko enaèbe omejitev
  %število simulacij znotraj datoteke  
   nt=numel(t); % preberem iz rezultata èasovnih trenutkov
  e_a=zacpog;
   for ia=1:nt
[e_a, e_dot, edotdot, Qc_izhod]=x_postprocesiranje_Uodvisne(t(ia),Z(ia,:),zacpog,e_a,ne_c,V,U,le,Qe,Qe_g,Mo,DK); % vrnjeni rezultati so vrstice s koordinatami, i je index èasovnih

% t trenutkov
 izhod_e_a(ia,:)=e_a';   % trenutni vrstni red. pretvorba nazaj v vrstico
 izhod_e_dot(ia,:)=e_dot'; %nièelni vrstni red
 izhod_edotdot(ia,:)=edotdot'; %trenutni vrstni red
 Qc_izhod_a(ia,:)=Qc_izhod'; %trenutni vrstni red, pretvorba v vrstico
 %pause
   end
% display(size(izhod_edotdot))   
% display(size(Qc_izhod_a))

 
%% C izracun funkcije za izraèun sil in momentov
%rezultat v stolpcih, vrstice so èasovni trenutki
for s=1:nt
[Flevo, Fdesno ]=sileMomenti(Qc_izhod_a(s,:)');    
izhod_Flevo(s,:)= Flevo;
izhod_Fdesno(s,:)= Fdesno;
end
% rezultat je v originalnem vstnem redu

%% part to extract some values-under constraction
% %   display(zapis)
%  
% izhod_Fskupaj_zp(:,index.ind_e')=sparse(izhod_Fskupaj); % nièelni vrstni red
% izhod_Fskupaj_zp_novo(:,index.ind_e')=sparse(izhod_Fskupaj_novo); % nièelni vrstni red
% 
% % pause
% koordinate_izhod=[koordinate_izhod;  izhod_e_zp(:,izpis)]; %nièelni vrstni red]; % definicja izhodnih matrik za izbrani zapis
% sile_izhod=[sile_izhod; izhod_Fskupaj_zp(:,izpis)]; % definicja izhodnih matrik za izbrani zapis
% sile_izhod_novo=[sile_izhod_novo; izhod_Fskupaj_zp_novo(:,izpis)]; % definicja izhodnih matrik za izbrani zapis
% 
% %pause
% tout_izhod=[tout_izhod; tout]; 
% clear izhod_e_a  izhod_e_zp izhod_Fskupaj izhod_Fskupaj_novo izhod_Fskupaj_zp izhod_Fskupaj_zp_novo tout
% 
% % izloèitev koordinat ki me zanimajo 'izpis'
% % koordinate_izhod=[koordinate_izhod;  izhod_e_zp(:,izpis)] %nièelni vrstni red]; % definicja izhodnih matrik za izbrani zapis
% % sile_izhod=[sile_izhod; izhod_Fskupaj_zp(:,izpis)] % definicja izhodnih matrik za izbrani zapis
% 

% %  
% a=numel(izpis)/2; % polovica ker sta z in y koordinata
% i=1:a;
% sile_izhod_final(:,i)=(sile_izhod(:,i).^2+sile_izhod(:,i+1).^2).^(1/2); %skupna sila
% sile_izhod_final_novo(:,i)=(sile_izhod_novo(:,i).^2+sile_izhod_novo(:,i+1).^2).^(1/2); %skupna sila

%% Saving
  
%ime_datoteke2=strcat('dinamika_POST_',ime_datoteke1); %sestavljanje imena datoteke in koncnice
ime_datoteke2=strcat('yDYNpost_',ime_datoteke_pure); %assemble file name for data load

% save(ime_datoteke2, 'ime_datoteke1','tout_izhod','koordinate_izhod','sile_izhod','sile_izhod_novo',...
%     'izpis','sile_izhod_final', 'sile_izhod_final_novo');  %shranjevanje variabel v to datoteko
save(ime_datoteke2, 'ime_datoteke1','hh','ne_c','tipverige','zacpog','zacpog_db','t','izhod_e_a','izhod_e_dot','izhod_Flevo','izhod_Fdesno');  %shranjevanje variabel v to datoteko

% opomba izhod_e_a so koordinate za posamezen trenutek t

%display(ime_datoteke2)
disp('END of Post-processing ');



    function [e_a, e_dot, edotdot, Qc_izhod]=x_postprocesiranje_Uodvisne(t,Z,zacpog,e_a,ne_c,V,U,le,Qe,Qe_g,M,DK)

 nn=numel(Z); %doloèitev števila noedvisnih kooordinat (število enaèb)
 r=1:nn/2;   %tvorim indeks  števila koordinat
 
 neodvisneV=Z(2*r-1)'; %zaèetni pogoji zapisani v vsako drugo vrstico, pretvorba v stolpièni vektor
 neodvisneVdot=Z(2*r)'; %zaèetni pogoji zapisani v vsako drugo vrstico, pretvorba v stolpièni vektor
 odvisneU=e_a(U',1); % prepišem odvisne koordinate, vzamem zadnje izraèunane iz predhodnega koraka 

%izraèunam odvisne za nove zaèetne pogoje
odvisneU=odvi_U(odvisneU,hh,ne_c,neodvisneV,V,U,tipverige,zacpog);
% display(odvisneU)

%% NAZAJ SESTAVIM VEKTOR e_a po ponovnem izraèunu odvisnih koordinat
% odvisne na novo prirejene tem neodvisnim
  e_a(U',1)=odvisneU;
  e_a(V',1)=neodvisneV;
%vrne izraèunane koordinate v osnovnem vrstnem redu 
  
 %% sedaj izracunam se HITROSTI 
 %odvod Ct in odvod Ctt sta enaka nic
 %izraèun odvisnih hitrosti qdot
odvisneUdot=Cdi*neodvisneVdot;

 % sestava vektorja hitrosti- originalni vrstni red 
 e_dot(U',1)=odvisneUdot;
 e_dot(V',1)=neodvisneVdot;

%% 5.1 izracun Qc
qc=zeros(nd,1); % ta je enak nic zaradi karakterja omejitev
qv=0; % v ANCF so caroliousova sila in   ? enaka niè
%stop
%% 6 izracun masne matrike, zunanjih in elasiènih sil, ter sestava sistema enacb po Shabana, Sany

%Ce prebran zgoraj
%Qe- skupaj z dodatnim bremenom

%--------------------------------------------------------------------
% WIND SCENARIOS  /uncomment if dealing with this scenario 
% [Qeg_0,DK]=wind_scenario_hammer(t,omega,Uw,DK,Qe)

% LOAD SCENARIOS
Qeg_0=load_scenario_1(t, time, Qe, Qe_g, Qe_breme, Qe_gg);
%--------------------------------------------------------------------


 % funkcija qkqt
qkqt=elastic_Qk_Qt_verige(neodvisneV,odvisneU,V,U,hh,ne_c,E_c,A_c,le,d_c,ne_i,tipverige,izo);
qwqd=damp_wind_Qd_Qw_verige(neodvisneV,odvisneU,neodvisneVdot,odvisneUdot,V,U,hh,ne_c,...
         E_c,A_c,le,d_c,m_c,tipverige,izo,DK);  %tvorjenje relativnega raztezka za korak t-1 (en korak nazaj)
qkqt=qkqt-qwqd; %Šeštejem elastièno in dušilne sile


%M prebran zgoraj
 %display(M)

%% 7 izraèun pospeška koordinat in lagrangeovih koeficientov
%augment
[pdotdot lambda ]=pdotdot_lagrange(M,Qeg_0,qkqt,qv,qc,Ce);

Qc_izhod=Ce'*lambda; % rezultat je v stolpcu
%Qc_izhod([U'; V'],1)=Qc_izhod; % zamenjava v originalni vrstni red
%edotdot([U'; V'],1)=pdotdot;%Ce\qc;
edotdot=pdotdot;%Ce\qc;
% display(full([edotdot pdotdot]))
% display(lambda)
% stop
    end



end

