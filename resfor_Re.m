 %% funkcija Re za izraèun statike
    function RTcrt=resfor_Re(ei,konstanteU,hh,ne_c,V,U,konstante,E_c,A_c,le,...
        d_c,Bdi,pari,Qe,ne_i,tipverige,izo,DK)  %tvorjenje relativnega raztezka za korak t-1 (en korak nazaj)

%pretvorba koordinat v originalni vrstni red (nièelno zaèetno stanje od 1 do n)


%E=[ei;odvisneU;konstanteU]; % sestava vektorja ki ima vrstni red neodvisne,odvisne, konstante
E=[ei;ei(pari.V,:);konstanteU]; % sestava vektorja ki ima vrstni red neodvisne,pari(odvisne), konstante
%U_pom=setdiff(U,konstante); %izloèim konstante iz matrike odvisnih
index=[V';pari.U;konstante'];
E(index,1)=E; %postavitev v osnovni vrstni red

 %    display(E)
%     pause
%    display(size(E))
 %  stop
K_elementa=[]; % preddefiniranje prazne matrike   
Qw=[];
 ii=1;  %pomožni indeks
 
for k=1:hh-1
 for i=1:ne_c(k,1)
 
     e=E(((ii-1)*12+1):((ii-1)*12+12),1); %vpis  koordinat za predmetni element, samo od-do po 12 koordinat
    
%     display(le(k,i))
%    pause
   
    if k~=hh-1&&i==ne_c(k,1)
    e1=E(((ii-1)*12+1+12):((ii-1)*12+12+12),1); %vpis dodatnih koordinat za izolator
    e2=E(((ii-1)*12+1+24):((ii-1)*12+12+24),1); %vpis dodatnih koordinat za izolator
    e3=E(((ii-1)*12+1+36):((ii-1)*12+12+36),1); %vpis dodatnih koordinat za izolator
    e4=E(((ii-1)*12+1+48):((ii-1)*12+12+48),1); %vpis dodatnih koordinat za izolator

    
%     display('izolator')
    K_elementa=[K_elementa;Kl_L1(e,E_c,A_c,le(k,i))+Kt_T1(e,E_c,izo.d_c,le(k,i))];
    Qw=[Qw; Qw_element(DK,d_c(k,i),le(k,i),e,zeros(12,1))];
    ii=ii+1;  %% šeštevanje elementov vodnika
 

    %  for i=1:ne_i %izraèun masne matrike elementa izolatorja
     
      switch tipverige(k+1,1)
          case 0
          case 1
        Ai=pi*(izo.izo_i(1,3)/2)^2; % V mm2
        K_elementa=[K_elementa;h_Qs(e1,izo.izo_i(1,5),Ai,izo.izo_i(1,1))+h_Qb(e1,izo.izo_i(1,5),izo.izo_i(1,3),izo.izo_i(1,1))];

        %display(h_Qs(e1,izo.izo_i(1,5),Ai,izo.izo_i(1,1)))
        %display(h_Qb(e1,izo.izo_i(1,5),izo.izo_i(1,3),izo.izo_i(1,1)))
        
         %         pause
        Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
        ii=ii+1;  %% šeštevanje elementov izolatorja
         case 2
        Ai=pi*(izo.izo_V(1,3)/2)^2;
        K_elementa=[K_elementa;Kl_L1(e1,izo.izo_V(1,5),Ai,izo.izo_V(1,1))+Kt_T1(e1,izo.izo_V(1,5),izo.izo_V(1,3),izo.izo_V(1,1))]; 
        Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
        ii=ii+1;  %% šeštevanje elementov izolatorja
        K_elementa=[K_elementa;Kl_L1(e2,izo.izo_V(1,5),Ai,izo.izo_V(1,1))+Kt_T1(e2,izo.izo_V(1,5),izo.izo_V(1,3),izo.izo_V(1,1))];
        Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
        ii=ii+1;  %% šeštevanje elementov izolatorja
         case 3
        Ai=pi*(izo.izo_B(1,3)/2)^2;
        K_elementa=[K_elementa;Kl_L1(e1,izo.izo_B(1,5),Ai,izo.izo_B(1,1))+Kt_T1(e1,izo.izo_B(1,5),izo.izo_B(1,3),izo.izo_B(1,1))]; 
        Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
        ii=ii+1;  %% šeštevanje elementov izolatorja
        Ai=pi*(izo.izo_P(1,3)/2)^2;
        K_elementa=[K_elementa;h_Qs(e2,izo.izo_P(1,5),Ai,izo.izo_P(1,1))+h_Qb(e2,izo.izo_P(1,5),izo.izo_P(1,3),izo.izo_P(1,1))]; 
        Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
        ii=ii+1;  %% šeštevanje elementov izolatorja
        
          case 4
        Ai=pi*(izo.izo_B(1,3)/2)^2;
        K_elementa=[K_elementa;Kl_L1(e1,izo.izo_B(1,5),Ai,izo.izo_B(1,1))+Kt_T1(e1,izo.izo_B(1,5),izo.izo_B(1,3),izo.izo_B(1,1))]; 
        Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
        ii=ii+1;  %% šeštevanje elementov izolatorja
        Ai=pi*(izo.izo_P(1,3)/2)^2;
        K_elementa=[K_elementa;h_Qs(e2,izo.izo_P(1,5),Ai,izo.izo_P(1,1))+h_Qb(e2,izo.izo_P(1,5),izo.izo_P(1,3),izo.izo_P(1,1))]; 
        Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
        ii=ii+1;  %% šeštevanje elementov izolatorja
        K_elementa=[K_elementa;h_Qs(e3,izo.st_pole(1,5),izo.st_pole(1,4),izo.izo_glava)+h_Qb(e3,izo.st_pole(1,5),izo.st_pole(1,3),izo.izo_glava)]; 
        Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
        ii=ii+1;  %% šeštevanje elementov glave
        K_elementa=[K_elementa;h_Qs(e4,izo.st_pole(1,5),izo.st_pole(1,4),izo.st_pole(1,1))+h_Qb(e4,izo.st_pole(1,5),izo.st_pole(1,3),izo.st_pole(1,1))]; 
        Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
        ii=ii+1;  %% šeštevanje elementov spodnji del pole

        case 5
        Ai=pi*(izo.izo_A(1,3)/2)^2;
      %  K_elementa=[K_elementa;h_Qs(e1,izo.izo_A(1,4),Ai,izo.izo_A(1,1))+h_Qb(e1,izo.izo_A(1,4),izo.izo_A(1,3),izo.izo_A(1,1))];
        K_elementa=[K_elementa;Kl_L1(e1,izo.izo_A(1,4),Ai,izo.izo_A(1,1))+Kt_T1(e1,izo.izo_A(1,4),izo.izo_A(1,3),izo.izo_A(1,1))];
        Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
        ii=ii+1;  %% šeštevanje elementov levega izolatorja od A kraka
    %    K_elementa=[K_elementa;h_Qs(e2,izo.izo_A(1,4),Ai,izo.izo_A(1,1))+h_Qb(e2,izo.izo_A(1,4),izo.izo_A(1,3),izo.izo_A(1,1))];
        K_elementa=[K_elementa;Kl_L1(e2,izo.izo_A(1,4),Ai,izo.izo_A(1,1))+Kt_T1(e2,izo.izo_A(1,4),izo.izo_A(1,3),izo.izo_A(1,1))];
        Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
        ii=ii+1;  %% šeštevanje elementov izolatorja   od denega kraka A      
        Ai=pi*(izo.izo_A(1,7)/2)^2;
  %      K_elementa=[K_elementa;h_Qs(e3,izo.izo_A(1,8),Ai,izo.izo_A(1,5))+h_Qb(e3,izo.izo_A(1,8),izo.izo_A(1,5),izo.izo_A(1,5))]; 
        K_elementa=[K_elementa;Kl_L1(e3,izo.izo_A(1,8),Ai,izo.izo_A(1,5))+Kt_T1(e3,izo.izo_A(1,8),izo.izo_A(1,5),izo.izo_A(1,5))];   
        Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
        ii=ii+1;  %% šeštevanje elementov izolatorja
        case 6
        Ai=pi*(izo.izo_IB(1,3)/2)^2;
        K_elementa=[K_elementa;h_Qs(e1,izo.izo_IB(1,5),Ai,izo.izo_IB(1,1))+h_Qb(e1,izo.izo_IB(1,5),izo.izo_IB(1,3),izo.izo_IB(1,1))]; 
        Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
%         display(e1)
%         display(izo.izo_IB(1,1))
%         risanjeElementa_ANCF(izo.izo_IB(1,1),e1)
%         display(h_Qs(e1,izo.izo_IB(1,5),Ai,izo.izo_IB(1,1)))
%         display(h_Qb(e1,izo.izo_IB(1,5),izo.izo_IB(1,3),izo.izo_IB(1,1)))
% 
%         pause
        ii=ii+1;  %% šeštevanje elementov izolatorja
        Ai=pi*(izo.izo_IP(1,3)/2)^2;
        K_elementa=[K_elementa;h_Qs(e2,izo.izo_IP(1,5),Ai,izo.izo_IP(1,1))+h_Qb(e2,izo.izo_IP(1,5),izo.izo_IP(1,3),izo.izo_IP(1,1))]; 
%              display(h_Qs(e2,izo.izo_IP(1,5),Ai,izo.izo_IP(1,1))+h_Qb(e2,izo.izo_IP(1,5),izo.izo_IP(1,3),izo.izo_IP(1,1)))
%              pause
% 
%         
         Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
        ii=ii+1;  %% šeštevanje elementov izolatorja
      %  pause
      end
    %  end
     % pause
    %  display('b')
    else

    K_elementa=[K_elementa;Kl_L1(e,E_c,A_c,le(k,i))+Kt_T1(e,E_c,izo.d_c,le(k,i))];
    Qw=[Qw; Qw_element(DK,d_c(k,i),le(k,i),e,zeros(12,1))];
%     display(Qw)
%     display(e)
%     display(Kl_L1(e,E_c,A_c,le(k,i)))
%     display(Kt_T1(e,E_c,d_c,le(k,i)))
%     pause
%     pause
    ii=ii+1;  %% šeštevanje elementov vodnika
    end
 end
 
end
%stop
%   display(Qe)
%     display(K_elementa)
%   display(Qw)
%   st
Re=Qe-K_elementa-Qw;
% display(K_crt.\Qg_crt)
 % stop
%Re je še vedno v pravem vrstnem redu 1-n zato 
% se zamenja vrstice po vrstnem redu V U
%display('zamenjavavrstic')
%Rb=sparse(Re)
Re=sparse(Re([V';U'],:));
%Re=sparse(Re([V';pari],:))
% stop
RTcrt=-Bdi.'*Re;
%stop
%   display((RTcrt))
%   st
% pause on
% pause
    
   % stop% raèun za residual force
end

