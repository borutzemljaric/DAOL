    function qkqt=elastic_Qk_Qt_verige(neodvisneV,odvisneU,V,U,hh,ne_c,E_c,A_c,le,d_c,ne_i,tipverige,izo)  %tvorjenje relativnega raztezka za korak t-1 (en korak nazaj)
 % funkcija qkqt za izraèun dinamike
 %izraèuna elastiène generalizirane sile elastiènih raztezkov
 % stanje 18.03.2017
 
%pretvorba koordinat v originalni vrstni red (nièelno zaèetno stanje od 1 do n)
E(V',1)=neodvisneV;
%display(odvisneU);
E(U',1)=odvisneU;
% display(E(37:48))
% display(E(49:60))
%pause
K_elementa=[];
 ii=1;  %pomožni indeks
for k=1:hh-1
 for i=1:ne_c(k,1)
 
     e=E(((ii-1)*12+1):((ii-1)*12+12),1); %vpis  koordinat za predmetni element, samo od-do po 12 koordinat
      
    if k~=hh-1&&i==ne_c(k,1)
    e1=E(((ii-1)*12+1+12):((ii-1)*12+12+12),1); %vpis dodatnih koordinat za izolator
    e2=E(((ii-1)*12+1+24):((ii-1)*12+12+24),1); %vpis dodatnih koordinat za izolator
    e3=E(((ii-1)*12+1+36):((ii-1)*12+12+36),1); %vpis dodatnih koordinat za izolator
    e4=E(((ii-1)*12+1+48):((ii-1)*12+12+48),1); %vpis dodatnih koordinat za izolator
% display(e1)
% display(e2)
    K_elementa=[K_elementa;Kl_L1(e,E_c,A_c,le(k,i))+Kt_T1(e,E_c,d_c,le(k,i))];
    ii=ii+1;  %% šeštevanje elementov vodnika
       
      switch tipverige(k+1,1)
          case 0
          case 1
        Ai=pi*(izo.izo_i(1,3)/2)^2; % V mm2
        K_elementa=[K_elementa;h_Qs(e1,izo.izo_i(1,5),Ai,izo.izo_i(1,1))+h_Qb(e1,izo.izo_i(1,5),izo.izo_i(1,3),izo.izo_i(1,1))]; 
        ii=ii+1;  %% šeštevanje elementov izolatorja
         case 2
        Ai=pi*(izo.izo_V(1,3)/2)^2;
        K_elementa=[K_elementa;Kl_L1(e1,izo.izo_V(1,5),Ai,izo.izo_V(1,1))+Kt_T1(e1,izo.izo_V(1,5),izo.izo_V(1,3),izo.izo_V(1,1))]; 
        ii=ii+1;  %% šeštevanje elementov izolatorja
        K_elementa=[K_elementa;Kl_L1(e2,izo.izo_V(1,5),Ai,izo.izo_V(1,1))+Kt_T1(e2,izo.izo_V(1,5),izo.izo_V(1,3),izo.izo_V(1,1))]; 
        ii=ii+1;  %% šeštevanje elementov izolatorja
         case 3
        Ai=pi*(izo.izo_B(1,3)/2)^2;
        K_elementa=[K_elementa;Kl_L1(e1,izo.izo_B(1,5),Ai,izo.izo_B(1,1))+Kt_T1(e1,izo.izo_B(1,5),izo.izo_B(1,3),izo.izo_B(1,1))]; 
        ii=ii+1;  %% šeštevanje elementov izolatorja
        Ai=pi*(izo.izo_P(1,3)/2)^2;
        K_elementa=[K_elementa;h_Qs(e2,izo.izo_P(1,5),Ai,izo.izo_P(1,1))+h_Qb(e2,izo.izo_P(1,5),izo.izo_P(1,3),izo.izo_P(1,1))]; 
        ii=ii+1;  %% šeštevanje elementov izolatorja
         case 4
        Ai=pi*(izo.izo_B(1,3)/2)^2;
        K_elementa=[K_elementa;Kl_L1(e1,izo.izo_B(1,5),Ai,izo.izo_B(1,1))+Kt_T1(e1,izo.izo_B(1,5),izo.izo_B(1,3),izo.izo_B(1,1))]; 
        ii=ii+1;  %% šeštevanje elementov izolatorja
        Ai=pi*(izo.izo_P(1,3)/2)^2;
        K_elementa=[K_elementa;h_Qs(e2,izo.izo_P(1,5),Ai,izo.izo_P(1,1))+h_Qb(e2,izo.izo_P(1,5),izo.izo_P(1,3),izo.izo_P(1,1))]; 
        ii=ii+1;  %% šeštevanje elementov izolatorja
        K_elementa=[K_elementa;h_Qs(e3,izo.st_pole(1,5),izo.st_pole(1,4),izo.izo_glava)+h_Qb(e3,izo.st_pole(1,5),izo.st_pole(1,3),izo.izo_glava)]; 
        ii=ii+1;  %% šeštevanje elementov glave
        K_elementa=[K_elementa;h_Qs(e4,izo.st_pole(1,5),izo.st_pole(1,4),izo.st_pole(1,1))+h_Qb(e4,izo.st_pole(1,5),izo.st_pole(1,3),izo.st_pole(1,1))]; 
        ii=ii+1;  %% šeštevanje elementov spodnji del pole
        case 5
        Ai=pi*(izo.izo_A(1,3)/2)^2;
        K_elementa=[K_elementa;h_Qs(e1,izo.izo_A(1,4),Ai,izo.izo_A(1,1))+h_Qb(e1,izo.izo_A(1,4),izo.izo_A(1,3),izo.izo_A(1,1))];
        ii=ii+1;  %% šeštevanje elementov levega izolatorja od A kraka
        K_elementa=[K_elementa;h_Qs(e2,izo.izo_A(1,4),Ai,izo.izo_A(1,1))+h_Qb(e2,izo.izo_A(1,4),izo.izo_A(1,3),izo.izo_A(1,1))];
        ii=ii+1;  %% šeštevanje elementov izolatorja   od denega kraka A      
        Ai=pi*(izo.izo_A(1,7)/2)^2;
        K_elementa=[K_elementa;h_Qs(e3,izo.izo_A(1,8),Ai,izo.izo_A(1,5))+h_Qb(e3,izo.izo_A(1,8),izo.izo_A(1,5),izo.izo_A(1,5))];   
        ii=ii+1;  %% šeštevanje elementov izolatorja
         case 6
        Ai=pi*(izo.izo_IB(1,3)/2)^2;
        K_elementa=[K_elementa;h_Qs(e1,izo.izo_IB(1,5),Ai,izo.izo_IB(1,1))+h_Qb(e1,izo.izo_IB(1,5),izo.izo_IB(1,3),izo.izo_IB(1,1))]; 
        ii=ii+1;  %% šeštevanje elementov izolatorja
        Ai=pi*(izo.izo_IP(1,3)/2)^2;
        K_elementa=[K_elementa;h_Qs(e2,izo.izo_IP(1,5),Ai,izo.izo_IP(1,1))+h_Qb(e2,izo.izo_IP(1,5),izo.izo_P(1,3),izo.izo_IP(1,1))]; 
        ii=ii+1;  %% šeštevanje elementov izolatorja
      end

    else

    K_elementa=[K_elementa;Kl_L1(e,E_c,A_c,le(k,i))+Kt_T1(e,E_c,d_c,le(k,i))];
    ii=ii+1;  %% šeštevanje elementov vodnika

    end
 end
 
end

qkqt=sparse(K_elementa); % navpièni vektor
%  display((qkqt))
%  stop
end

