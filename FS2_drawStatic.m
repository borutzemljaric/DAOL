function FS2_drawStatic
clear;
 %[ime_datoteke2, pathname] = ...
  %   uigetfile({'*.mat';'*.*'},'File Selector');  %vneseš datoteko z vhodnimi podatki

% CHOSE YOUR FILE
  ime_datoteke1='TestFileSingle.txt'  
  %ime_datoteke1='TestFile.txt' 
  %ime_datoteke1='TestFile_V.txt' 
  ime_datoteke1='TestFile_3spans.txt' 
  

[pathstr, ime_datoteke2, ext] = fileparts(ime_datoteke1);  % filename without extension
ime_datoteke2=strcat('ySTAT_',ime_datoteke2,'.mat'); %sestavljanje imena datoteke in koncnice

load(ime_datoteke2, 'izo','hh','ne_c','tipverige','zacpog','zacpog_db','zacpog_db_W','Flevo','Fdesno','Folevo','Fodesno','e_zp','le');  %shranjevanje variabel v to datoteko

zacpog_0=zacpog;  %samo prepis da ohranim izvorne datoteke (to so rezultati raèuna)
e_zp_0=e_zp; %samo prepis da ohranim izvorne datoteke (to so vhodni podatki za raèun)


%% èe želim izpisati sile nièelnega stanja(naprimer za zaèetno kontrolo)
%postavim pogoj na 1, drugaèe ga postavi na katerokoli drugo vrednost
pogoj=0;
if pogoj==1
    Flevo=Folevo;
    Fdesno=Fodesno;
end


%% indeksi verižnice in indeksi izolatojev
 ec=[]; % indeks za vodnik
 ci=[]; %indeks za izolatorje
 csp=[]; % indeks za pole
 Fec=[]; %indeks za izloèitev sil
 Fci=[]; %indeks za izloèitev sil
 Fsp=[]; %indeks za izloèitev sil pole
ii=1;  %pomožni indeks
 for k=1:hh-1
 for i=1:ne_c(k,1)
 
     ec=[ec,((ii-1)*12+1):((ii-1)*12+12)]; %vpis  koordinat za predmetni element, samo od-do po 12 koordinat
     Fec=[Fec,((ii-1)*3+1):((ii-1)*3+3)]; %vpis  koordinat za predmetni element za sile  samo od-do po 3 koordinat
 
     if k~=hh-1&&i==ne_c(k,1)
    ei1=((ii-1)*12+1+12):((ii-1)*12+12+12); %vpis dodatnih koordinat za izolator
    ei2=((ii-1)*12+1+24):((ii-1)*12+12+24); %vpis dodatnih koordinat za izolator
    esp1=(((ii-1)*12+1+36):((ii-1)*12+12+36)); %vpis dodatnih koordinat za izolator
    esp2=(((ii-1)*12+1+48):((ii-1)*12+12+48)); %vpis dodatnih koordinat za izolator
    Fei1=((ii-1)*3+1+3):((ii-1)*3+3+3); %vpis dodatnih koordinat za izolator
    Fei2=((ii-1)*3+1+6):((ii-1)*3+3+6); %vpis dodatnih koordinat za izolator
    Fsp1=((ii-1)*3+1+9):((ii-1)*3+3+9); %vpis dodatnih koordinat za izolator
    Fsp2=((ii-1)*3+1+12):((ii-1)*3+3+12); %vpis dodatnih koordinat za izolator
    ii=ii+1;  %% šeštevanje elementov vodnika
      
      switch tipverige(k+1,1)
          case 0
          case 1
       ci=[ci,ei1];
       Fci=[Fci,Fei1];
        ii=ii+1;  %% šeštevanje elementov izolatorja
         case 2
     ci=[ci,ei1,ei2];
     Fci=[Fci,Fei1,Fei2];
       ii=ii+2;  %% šeštevanje elementov izolatorja
         case 3
     ci=[ci,ei1,ei2];
     Fci=[Fci,Fei1,Fei2];
       ii=ii+2;  %% šeštevanje elementov izolatorja
         case 4
     ci=[ci,ei1,ei2];
     Fci=[Fci,Fei1,Fei2];
     csp=[csp,esp1,esp2];
     Fsp=[Fsp,Fsp1,Fsp2];
       ii=ii+4;  %% šeštevanje elementov izolatorja
        case 5  % velja za A verigo
     ci=[ci,ei1,ei2];
     Fci=[Fci,Fei1,Fei2];
        ii=ii+3;  %% šeštevanje elementov izolatorja
        case 6 % velja za IB verigo
     ci=[ci,ei1,ei2];
     Fci=[Fci,Fei1,Fei2];
       ii=ii+2;  %% šeštevanje elementov izolatorja
      end
     
     % pause
    %  display('b')
    else
 
    ii=ii+1;  %% šeštevanje elementov vodnika
    end
 end
 
end
  display(ec) %index verižnice
  display(ci) %index izolacije
  display(Fci) %index izolacije

%display(insulator)



%index tock verižnice
[t1 t2]=size(ec);
tocke_x=[ec(1:12:t2),ec(t2-5)];
tocke_y=[ec(2:12:t2),ec(t2-4)];
tocke_z=[ec(3:12:t2), ec(t2-3)];

%index tock izolacije
[ti1 ti2]=size(ci);
% tocke_xi=[ci(1:6:ti2),ci(ti2-5)]
% tocke_yi=[ci(2:6:ti2),ci(ti2-4)]
% tocke_zi=[ci(3:6:ti2), ci(ti2-3)]
tocke_xi=[ci(1:6:ti2)];
tocke_yi=[ci(2:6:ti2)];
tocke_zi=[ci(3:6:ti2)];




%% graf risanje
% risanje vodnika /draw cable
%
plot3(zacpog(tocke_x),zacpog(tocke_y),zacpog(tocke_z),'-.r*');  %Zero state

%legend('nicelno','koncno');
hold on
% vodnik v 'konènem'stanju
plot3(zacpog_db_W(tocke_x),zacpog_db_W(tocke_y),zacpog_db_W(tocke_z),'-.m*');
%legend('nicelno','izhodiscno','koncno');

hold on
% dorisani izolatorji/ draw insulators
plot3(zacpog(tocke_xi),zacpog(tocke_yi),zacpog(tocke_zi),'-.g*',zacpog_db(tocke_xi),zacpog_db(tocke_yi),zacpog_db(tocke_zi),'-.y+');
legend('cable- init.','cable- load+wind','insu-init.','insu-load+wind');
%ylim([0 30])
%title('Cable and insulators');
zlabel('z (m)','fontsize',10)
ylabel('y (m)','fontsize',10)
xlabel('x (m)','fontsize',10)
% myfile=strcat(ime_datoteke1,'_Razpetina_',num2str(k));
% %display(myfile)
% print ('-djpeg100', myfile)
axis ij
hold off



%% izpis sil
%display ('sile levo in desno');
display ('Forces left and right');
%display(Fec)
[b a]=size(Fec);
%Sile v levem 'obesiscu elementa
%index tock verižnice
indF_x=[Fec(1:3:a-2)];
indF_y=[Fec(2:3:a-1)];
indF_z=[Fec(3:3:a)];
[b a]=size(Fci);
%index tock izolacije
indF_xi=[Fci(1:3:a-2)];
indF_yi=[Fci(2:3:a-1)];
indF_zi=[Fci(3:3:a)];



% Sile leva stran elementov vodnikov
display('Forces- left side of cable elements')
Fprecno=Flevo(indF_x,1) % Velja za sile v vodniku na mestu izolatorja(koluta) in zadnjem obesišèu
Fvodoravno=Flevo(indF_y,1) % Velja za sile v vodniku na mestu izolatorja(koluta) in zadnjem obesišèu
Fnavpicno=Flevo(indF_z,1)
Fskupna=sqrt(Fprecno.^2+Fvodoravno.^2+Fnavpicno.^2)
display('----------------------------------')

% Sile desna stran elementov vodnikov
display('Forces- right side of cable elements')
Fprecno=Fdesno(indF_x,1) % Velja za sile v vodniku na mestu izolatorja(koluta) in zadnjem obesišèu
Fvodoravno=Fdesno(indF_y,1) % Velja za sile v vodniku na mestu izolatorja(koluta) in zadnjem obesišèu
Fnavpicno=Fdesno(indF_z,1)
Fskupna=sqrt(Fprecno.^2+Fvodoravno.^2+Fnavpicno.^2)
display('----------------------------------')


% Sile leva stran elementov izolatorjev
display('Forces- left side of insulators elements')
Fprecno=Flevo(indF_xi,1) % Velja za sile v vodniku na mestu izolatorja(koluta) in zadnjem obesišèu
Fvodoravno=Flevo(indF_yi,1) % Velja za sile v vodniku na mestu izolatorja(koluta) in zadnjem obesišèu
Fnavpicno=Flevo(indF_zi,1)
Fskupna=sqrt(Fprecno.^2+Fvodoravno.^2+Fnavpicno.^2)
display('----------------------------------')

% Sile desna stran elementov izolatorjev
display('Forces- right side of insulators elements')
Fprecno=Fdesno(indF_xi,1) % Velja za sile v vodniku na mestu izolatorja(koluta) in zadnjem obesišèu
Fvodoravno=Fdesno(indF_yi,1) % Velja za sile v vodniku na mestu izolatorja(koluta) in zadnjem obesišèu
Fnavpicno=Fdesno(indF_zi,1)
Fskupna=sqrt(Fprecno.^2+Fvodoravno.^2+Fnavpicno.^2)
display('----------------------------------')


   
if hh>2
% koti z db brez vetra
[alfa,beta,p_x, p_y, p_z]=koti(hh,zacpog_db,izo);

display('angle beta without wind (direction y) (°) are')
display(beta)
display('angle alfa without wind (direction x) (°) are')
display(alfa)
display('displacements (m) direction x y z')
display([p_x p_y p_z])

% koti z db in vetrom vetra
[alfa,beta,p_x_W, p_y_W, p_z_W]=koti(hh,zacpog_db_W,izo);

display('angle beta with wind (direction y) (°) are')
display(beta)
display('angle alfa with wind (direction x) (°) are')
display(alfa)
display('displacments (with wind) (m) direction x y z')
display([p_x_W p_y_W p_z_W])

else % samo za eno razpetino
    
   display('no angles (only one span)')
 
end

display('End of list')

 function [alfa,beta,p_x_W, p_y_W, p_z_W]=koti(hh,zacpog_db,izo)
%% izraèun kotov raèunam samo vzdolžni kot glede na 'nièelno pozicijo'

%index tock izolacije- definirane so na zaèetku te funkcije!
%display( tocke_xi)
% tocke_yi
% tocke_zi
a=0; %pomožno da lahko izraèunam vsako drugo šrevilo pri v izolaciji
for i=1:hh-2
    if tipverige(i+1)==1
    delta_x=zacpog_db(tocke_xi(i*2-1))-zacpog_db(tocke_xi(i*2));
    delta_y=zacpog_db(tocke_yi(i*2-1))-zacpog_db(tocke_yi(i*2));
    delta_z=zacpog_db(tocke_zi(i*2-1))-zacpog_db(tocke_zi(i*2));
    p_x(i,1)=delta_x; % premiki
    p_y(i,1)=delta_y;
    p_z(i,1)=-zacpog(tocke_zi(i*2-1+a))+zacpog_db(tocke_zi(i*2-1+a));
    
    % za izpis pomikov konca izolatorja z vetrom
    p_z_W(i,1)=-zacpog(tocke_zi(i*2-1+a))+zacpog_db_W(tocke_zi(i*2-1+a));
    p_y_W(i,1)=-zacpog(tocke_yi(i*2-1+a))+zacpog_db_W(tocke_yi(i*2-1+a));
    p_x_W(i,1)=-zacpog(tocke_xi(i*2-1+a))+zacpog_db_W(tocke_xi(i*2-1+a));
    
    beta(i,1)=atand(delta_y/delta_z);  % offest se izraèuna v zunanji funkciji 
    alfa(i,1)=atand(delta_x/delta_z);  % offest se izraèuna v zunanji funkciji
    
    
    
    elseif tipverige(i+1)==5  % A veriga
        
  %ime_datoteke3=strcat('segmentacija_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice 
  %load(ime_datoteke3, 'izo');  %shranjevanje variabel v to datoteko
  % nicelni kot A verige
   epsilon=asind(izo.izo_A(1,5)/2/izo.izo_A(1,1));

  % naklon izolatorja
    delta_x=zacpog_db(tocke_xi(i*2-1))-zacpog_db(tocke_xi(i*2));
    delta_y=zacpog_db(tocke_yi(i*2-1))-zacpog_db(tocke_yi(i*2));
    delta_z=zacpog_db(tocke_zi(i*2-1))-zacpog_db(tocke_zi(i*2));
    p_x(i,1)=delta_x; % premiki
    p_y(i,1)=delta_y;
    % skupaj naklon osi trikotnika 
    p_z(i,1)=-zacpog(tocke_zi(i*2-1+a))+zacpog_db(tocke_zi(i*2-1+a));
    beta(i,1)=atand(delta_y/delta_z)-epsilon;  % offest se izraèuna v zunanji funkciji 
    alfa(i,1)=atand(delta_x/delta_z);  % offest se izraèuna v zunanji funkciji
    
    else
    delta_x=zacpog_db(tocke_xi(i*2-1+a))-zacpog_db(tocke_xi(i*2+a));
    delta_y=zacpog_db(tocke_yi(i*2-1+a))-zacpog_db(tocke_yi(i*2+a));
    delta_z=zacpog_db(tocke_zi(i*2-1+a))-zacpog_db(tocke_zi(i*2+a));
    p_x(i,1)=delta_x; % premiki
    p_y(i,1)=delta_y;
    p_z(i,1)=-zacpog(tocke_zi(i*2-1+a))+zacpog_db(tocke_zi(i*2-1+a));
    
    % za izpis pomikov konca izolatorja
    p_z_W(i,1)=-zacpog(tocke_zi(i*2-1+a))+zacpog_db_W(tocke_zi(i*2-1+a));
    p_y_W(i,1)=-zacpog(tocke_yi(i*2-1+a))+zacpog_db_W(tocke_yi(i*2-1+a));
    p_x_W(i,1)=-zacpog(tocke_xi(i*2-1+a))+zacpog_db_W(tocke_xi(i*2-1+a));
    
    
    
    
    beta(i,1)=atand(delta_y/delta_z);  % koti
    alfa(i,1)=atand(delta_x/delta_z);  % offest se izraèuna v zunanji funkciji
    a=a+2;
    end
end
    end


end