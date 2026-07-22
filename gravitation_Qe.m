 %% funkcija Qe za izraèun zunanje sile
    function Qe_g=gravitation_Qe(hh,ne_c,le,g,m_c,ne_i,tipverige,izo)  %tvorjenje relativnega raztezka za korak t-1 (en korak nazaj)
    
    Qe_elementa=[]; %definicija prazne matrike
   ii=1;
for k=1:hh-1
 for i=1:ne_c(k,1)
  
    if k~=hh-1&&i==ne_c(k,1)  % za kombinacijo vodnik-izolator

    Qe_elementa=[Qe_elementa Qg(g,m_c,le(k,i))];
    ii=ii+1;  %% šeštevanje elementov vodnika
 
    %  for j=1:ne_i %izraèun masne matrike elementa izolatorja
         %tipberige=0- ni verige
         %tipverige=1- I veriga
         %tipverige=2- V veriga
      switch tipverige(k+1,1)
          case 0

         case 1
       Qe_elementa=[Qe_elementa  Qg(g,izo.izo_i(1,2),izo.izo_i(1,1))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
         case 2
       Qe_elementa=[Qe_elementa Qg(g,izo.izo_V(1,2),izo.izo_V(1,1))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa Qg(g,izo.izo_V(1,2),izo.izo_V(1,1))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
        case 3
       Qe_elementa=[Qe_elementa Qg(g,izo.izo_B(1,2),izo.izo_B(1,1))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa Qg(g,izo.izo_P(1,2),izo.izo_P(1,1))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       case 4
       Qe_elementa=[Qe_elementa Qg(g,izo.izo_B(1,2),izo.izo_B(1,1))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa Qg(g,izo.izo_P(1,2),izo.izo_P(1,1))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa Qg(g,izo.st_pole(1,2),izo.izo_glava)];      
       ii=ii+1;  %% šeštevanje elementov glava
       Qe_elementa=[Qe_elementa Qg(g,izo.st_pole(1,2),izo.st_pole(1,1))];      
       ii=ii+1;  %% šeštevanje elementov spo del pole
       case 5
       Qe_elementa=[Qe_elementa Qg(g,izo.izo_A(1,2),izo.izo_A(1,1))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa Qg(g,izo.izo_A(1,2),izo.izo_A(1,1))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa Qg(g,izo.izo_A(1,6),izo.izo_A(1,5))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       case 6
       Qe_elementa=[Qe_elementa Qg(g,izo.izo_IB(1,2),izo.izo_IB(1,1))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa Qg(g,izo.izo_IP(1,2),izo.izo_IP(1,1))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       
      end
      
     % end
    else  % % za kombinacijo vodnik-vodnik (vse)

    Qe_elementa=[Qe_elementa Qg(g,m_c,le(k,i))];
    ii=ii+1;  %% šeštevanje elementov vodnika
    end
 end
 
end

% pretvorba iz vrstice v stolpec
Qe_g=Qe_elementa';


 
 %stop

   

end

