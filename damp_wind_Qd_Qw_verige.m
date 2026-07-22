    function qwqd=damp_wind_Qd_Qw_verige(neodvisneV,odvisneU,neodvisneVdot,odvisneUdot,V,U,hh,ne_c,...
        E_c,A_c,le,d_c,m_c,tipverige,izo,DK)  %tvorjenje relativnega raztezka za korak t-1 (en korak nazaj)
 % funkcija ki iraèna generalizirane sile zaradi vetra in lastnega dušenja za izraèun dinamike
 % stanje 15.04.2017
 % vzamm da vplivajo samo vodniki, deli izolatorji nimajo prispevka

%pretvorba koordinat v originalni vrstni red (nièelno zaèetno stanje od 1 do n)
E(V',1)=neodvisneV;
E(U',1)=odvisneU;
Edot(V',1)=neodvisneVdot;
Edot(U',1)=odvisneUdot;

%pause
%K_elementa=[];
Qw=[]; % predefinicija vrltorja generalizirane sile vetra
Qd=[];
ii=1;  %pomožni indeks
for k=1:hh-1
 for i=1:ne_c(k,1)
 
     e=E(((ii-1)*12+1):((ii-1)*12+12),1); %vpis  koordinat za predmetni element, samo od-do po 12 koordinat
     edot=Edot(((ii-1)*12+1):((ii-1)*12+12),1); %vpis  koordinat za predmetni element, samo od-do po 12 koordinat
      
    if k~=hh-1&&i==ne_c(k,1)
        %KOMENTAR kere ne vplijp jih ne izraèunavam
%     e1=E(((ii-1)*12+1+12):((ii-1)*12+12+12),1); %vpis dodatnih koordinat za izolator
%     e2=E(((ii-1)*12+1+24):((ii-1)*12+12+24),1); %vpis dodatnih koordinat za izolator
%     e1dot=Edot(((ii-1)*12+1+12):((ii-1)*12+12+12),1); %vpis dodatnih koordinat za izolator
%     e2dot=Edot(((ii-1)*12+1+24):((ii-1)*12+12+24),1); %vpis dodatnih koordinat za izolator
% display(e1)
% display(e2)
%    K_elementa=[K_elementa;Kl_L1(e,E_c,A_c,le(k,i))+Kt_T1(e,E_c,d_c,le(k,i))];
    Qw=[Qw; Qw_element(DK,izo.d_c,le(k,i),e,edot)];
    Qd=[Qd; Qd_element_novi(DK,E_c,izo.d_c,le(k,i),m_c,edot,e,A_c)]; %predpostavim da je pritisk vetra na izolator zanemarljiv

    ii=ii+1;  %% šeštevanje elementov vodnika
       
      switch tipverige(k+1,1)
          case 0
          case 1
        %Ai=pi*(izo_i(1,3)/2)^2; % V mm2
       % K_elementa=[K_elementa;Kl_L1(e1,izo_i(1,5),Ai,izo_i(1,1))+Kt_T1(e1,izo_i(1,5),izo_i(1,3),izo_i(1,1))]; 
        Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
        Qd=[Qd; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
        
        ii=ii+1;  %% šeštevanje elementov izolatorja
         case 2
      %  Ai=pi*(izo_V(1,3)/2)^2;
      %  K_elementa=[K_elementa;Kl_L1(e1,izo_V(1,5),Ai,izo_V(1,1))+Kt_T1(e1,izo_V(1,5),izo_V(1,3),izo_V(1,1))]; 
       Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
       Qd=[Qd; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
       ii=ii+1;  %% šeštevanje elementov izolatorja
        Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
       Qd=[Qd; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
          %  K_elementa=[K_elementa;Kl_L1(e2,izo_V(1,5),Ai,izo_V(1,1))+Kt_T1(e2,izo_V(1,5),izo_V(1,3),izo_V(1,1))]; 
        ii=ii+1;  %% šeštevanje elementov izolatorja
         case 3
       % Ai=pi*(izo_B(1,3)/2)^2;
      %  K_elementa=[K_elementa;Kl_L1(e1,izo_B(1,5),Ai,izo_B(1,1))+Kt_T1(e1,izo_B(1,5),izo_B(1,3),izo_B(1,1))]; 
       Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
       Qd=[Qd; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
       ii=ii+1;  %% šeštevanje elementov izolatorja
%        Ai=pi*(izo_P(1,3)/2)^2;
      %  K_elementa=[K_elementa;Kl_L1(e2,izo_P(1,5),Ai,izo_P(1,1))+Kt_T1(e2,izo_P(1,5),izo_P(1,3),izo_P(1,1))]; 
      Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
      Qd=[Qd; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
      ii=ii+1;  %% šeštevanje elementov izolatorja
      case 4
       % Ai=pi*(izo_B(1,3)/2)^2;
      %  K_elementa=[K_elementa;Kl_L1(e1,izo_B(1,5),Ai,izo_B(1,1))+Kt_T1(e1,izo_B(1,5),izo_B(1,3),izo_B(1,1))]; 
       Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
       Qd=[Qd; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
       ii=ii+1;  %% šeštevanje elementov izolatorja
      Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
      Qd=[Qd; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
      ii=ii+1;  %% šeštevanje elementov izolatorja
      Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na steber zanemarljiv
      Qd=[Qd; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na steber zanemarljiv
      ii=ii+1;  %% šeštevanje glave stebra
      Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na steber zanemarljiv
      Qd=[Qd; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na steber zanemarljiv
      ii=ii+1;  %% šeštevanje trupa stebra
       case 5
       % Ai=pi*(izo_B(1,3)/2)^2;
      %  K_elementa=[K_elementa;Kl_L1(e1,izo_B(1,5),Ai,izo_B(1,1))+Kt_T1(e1,izo_B(1,5),izo_B(1,3),izo_B(1,1))]; 
       Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator levi krak A zanemarljiv
       Qd=[Qd; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
       ii=ii+1;  %% šeštevanje elementov izolatorja
      Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra desni krak A na izolator zanemarljiv
      Qd=[Qd; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
      ii=ii+1;  %% šeštevanje elementov izolatorja
      Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na jekleni vmesnik  zanemarljiv
      Qd=[Qd; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na steber zanemarljiv
      ii=ii+1;  %% šeštevanje glave stebra
       case 6
       % Ai=pi*(izo_B(1,3)/2)^2;
      %  K_elementa=[K_elementa;Kl_L1(e1,izo_B(1,5),Ai,izo_B(1,1))+Kt_T1(e1,izo_B(1,5),izo_B(1,3),izo_B(1,1))]; 
       Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
       Qd=[Qd; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
       ii=ii+1;  %% šeštevanje elementov izolatorja
%        Ai=pi*(izo_P(1,3)/2)^2;
      %  K_elementa=[K_elementa;Kl_L1(e2,izo_P(1,5),Ai,izo_P(1,1))+Kt_T1(e2,izo_P(1,5),izo_P(1,3),izo_P(1,1))]; 
      Qw=[Qw; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
      Qd=[Qd; 0;0;0;0;0;0;0;0;0;0;0;0]; %predpostavim da je pritisk vetra na izolator zanemarljiv
      ii=ii+1;  %% šeštevanje elementov izolatorja
      
      end

    else

   % K_elementa=[K_elementa;Kl_L1(e,E_c,A_c,le(k,i))+Kt_T1(e,E_c,d_c,le(k,i))];
    Qw=[Qw; Qw_element(DK,izo.d_c,le(k,i),e,edot)];
   % Qd=[Qd; Qw_element(DK,d_c,le(k,i),e,edot)];
    Qd=[Qd; Qd_element_novi(DK,E_c,izo.d_c,le(k,i),m_c,edot,e,A_c)]; %predpostavim da je pritisk vetra na izolator zanemarljiv

    ii=ii+1;  %% šeštevanje elementov vodnika

    end
 end
 
end
% display(Qw(13:24))
% display(Qd(13:24))
qwqd=sparse(-Qw+Qd); % navpièni vektor
% display(size(qkqt))
% stop
end

