function Cc=constrain_C_C(edd,hh,ne_c,neodvisneV,V,U,tipverige,e_zp)%(constraints)

%postavljene so v osnovni vrstni red!
ed(V',1)=neodvisneV(:,1); %fiksiranje neodvisnih spremenljivk v sistemu enaèb
ed(U',1)=edd(:,1);  %vnos odvisne koordinate kot neznanka v sistem enaèb
a=0;
for k=1:hh-1
 for i=1:ne_c(k,1)
     if k==1&& i==1  % A. spoj steber levo -vodnik
          %opomba- prvih treh ne rabim ker ni zapisan v omenjitvi
          Cq_elementa=[ ed(a+1) - e_zp(a+1);  %levo tocka segmenta ground-vodnik
                        ed(a+2) - e_zp(a+2);
                        ed(a+3) - e_zp(a+3)];           
         Cq_elementa=[Cq_elementa;
                      ed(a+7)-ed(a+12+1);  %desna tocka segmenta prvega
                      ed(a+8)-ed(a+12+2);
                      ed(a+9)-ed(a+12+3);
                      ed(a+10)-ed(a+12+4);
                      ed(a+11)-ed(a+12+5);
                     ed(a+12)-ed(a+12+6)];
       a=a+12; % 
   %    display('a');    
   %    stop
     elseif i>=2 && i~=ne_c(k,1) %&& k~= hh-1 % B. vodnik-vodnik
       
        
        Cq_elementa=[Cq_elementa;
                     ed(a+7)-ed(a+12+1);
                     ed(a+8)-ed(a+12+2);
                     ed(a+9)-ed(a+12+3);
                     ed(a+10)-ed(a+12+4);
                     ed(a+11)-ed(a+12+5);
                     ed(a+12)-ed(a+12+6)];
      a=a+12;
  % display('b');
   
     elseif i>=2 && i==ne_c(k,1) && k~= hh-1 % C. sklop vodnik-vodnik-izolator
          %display(tipverige(k+1,1))
          %tipberige=0- ni verige
         %tipverige=1- I veriga
         %tipverige=2- V veriga
          switch tipverige(k+1,1)
          
          case 0 %tipberige=0- ni verige /pravzaprav ne potrebujem
                   
          case 1 %tipverige=1- I veriga
          Cq_elementa=[Cq_elementa;
                       ed(a+7) - ed(a+24+1);  %sklop vodnik-vodnik za izolatorjem
                       ed(a+8) - ed(a+24+2);
                       ed(a+9) - ed(a+24+3);
                       ed(a+7) - ed(a+12+1);   %sklop vodnik-izolator
                       ed(a+8) - ed(a+12+2);
                       ed(a+9) - ed(a+12+3)];
            Cq_elementa=[Cq_elementa;  % spoj izolatorja z ground                 
                         ed(a+12+7) - e_zp(a+12+7);
                         ed(a+12+8) - e_zp(a++12+8);
                         ed(a++12+9) - e_zp(a+12+9)];
                   
                   
                   Cq_elementa=[Cq_elementa;  %prvi spoj za izolatorjem
                     ed(a+24+7) - ed(a+36+1);
                     ed(a+24+8) - ed(a+36+2);
                     ed(a+24+9) - ed(a+36+3);
                    ed(a+24+10) - ed(a+36+4);
                    ed(a+24+11) - ed(a+36+5);
                    ed(a+24+12) - ed(a+36+6)];        
   
     %a=a+12;
      a=a+36;
   %     display('c');
           
          case 2 %tipverige=2- V veriga
         
              Cq_elementa=[Cq_elementa;
                       ed(a+7) - ed(a+36+1);  %sklop vodnik-vodnik za izolatorjem
                       ed(a+8) - ed(a+36+2);
                       ed(a+9) - ed(a+36+3);
                       ed(a+10) - ed(a+36+4);
                       ed(a+11) - ed(a+36+5);
                       ed(a+12) - ed(a+36+6);
                       ed(a+7) - ed(a+12+1);   %sklop vodnik-izolator desni
                       ed(a+8) - ed(a+12+2);
                       ed(a+9) - ed(a+12+3)
                       ed(a+7) - ed(a+24+1);   %sklop vodnik-izolator levi
                       ed(a+8) - ed(a+24+2);
                       ed(a+9) - ed(a+24+3)];
            Cq_elementa=[Cq_elementa;  % spoj izolatorja z ground -izolator desni                
                         ed(a+12+7) - e_zp(a+12+7);
                         ed(a+12+8) - e_zp(a+12+8);
                         ed(a+12+9) - e_zp(a+12+9)];
                   
            Cq_elementa=[Cq_elementa;  % spoj izolatorja z ground -izolator levi                
                         ed(a+24+7) - e_zp(a+24+7);
                         ed(a+24+8) - e_zp(a+24+8);
                         ed(a+24+9) - e_zp(a+24+9)];
                     
                     
                   Cq_elementa=[Cq_elementa;  %prvi spoj za izolatorjem
                     ed(a+36+7) - ed(a+48+1);
                     ed(a+36+8) - ed(a+48+2);
                     ed(a+36+9) - ed(a+48+3);
                    ed(a+36+10) - ed(a+48+4);
                    ed(a+36+11) - ed(a+48+5);
                    ed(a+36+12) - ed(a+48+6)];        
       a=a+48;
       
       case 3 %tipverige=2- Vee veriga- popolnoma isto kot zgoraj
         
                Cq_elementa=[Cq_elementa;
                       ed(a+7) - ed(a+36+1);  %sklop vodnik-vodnik za izolatorjem
                       ed(a+8) - ed(a+36+2);
                       ed(a+9) - ed(a+36+3);
                       ed(a+10) - ed(a+36+4);
                       ed(a+11) - ed(a+36+5);
                       ed(a+12) - ed(a+36+6);
                       ed(a+7) - ed(a+12+1);   %sklop vodnik-izolator desni
                       ed(a+8) - ed(a+12+2);
                       ed(a+9) - ed(a+12+3)
                       ed(a+7) - ed(a+24+1);   %sklop vodnik-izolator levi
                       ed(a+8) - ed(a+24+2);
                       ed(a+9) - ed(a+24+3)];
            Cq_elementa=[Cq_elementa;  % spoj izolatorja z ground -izolator desni                
                         ed(a+12+7) - e_zp(a+12+7);
                         ed(a+12+8) - e_zp(a+12+8);
                         ed(a+12+9) - e_zp(a+12+9)];
                   
            Cq_elementa=[Cq_elementa;  % spoj izolatorja z ground -izolator levi                
                         ed(a+24+7) - e_zp(a+24+7);
                         ed(a+24+8) - e_zp(a+24+8);
                         ed(a+24+9) - e_zp(a+24+9)];
                     
                     
                   Cq_elementa=[Cq_elementa;  %prvi spoj za izolatorjem
                     ed(a+36+7) - ed(a+48+1);
                     ed(a+36+8) - ed(a+48+2);
                     ed(a+36+9) - ed(a+48+3);
                    ed(a+36+10) - ed(a+48+4);
                    ed(a+36+11) - ed(a+48+5);
                    ed(a+36+12) - ed(a+48+6)];        
       a=a+48;
              case 4 %tipverige=4- Vee veriga+ pole
         
                Cq_elementa=[Cq_elementa;
                       ed(a+7) - ed(a+60+1);  %sklop vodnik-vodnik za izolatorjem sp1
                       ed(a+8) - ed(a+60+2);
                       ed(a+9) - ed(a+60+3);
                       ed(a+7) - ed(a+12+1);   %sklop vodnik-izolator desni sp2
                       ed(a+8) - ed(a+12+2);
                       ed(a+9) - ed(a+12+3)
                       ed(a+7) - ed(a+24+1);   %sklop vodnik-izolator levi sp3
                       ed(a+8) - ed(a+24+2);
                       ed(a+9) - ed(a+24+3)];
            Cq_elementa=[Cq_elementa;  % spoj izolatorja zgornji -glava zgoraj    sp4             
                         ed(a+12+7) - ed(a+36+7);
                         ed(a+12+8) - ed(a+36+8);
                         ed(a+12+9) - ed(a+36+9)];
             Cq_elementa=[Cq_elementa;  % spoj pole zgoraj izolator spodaj    sp5             
                         ed(a+48+7) - ed(a+24+7);
                         ed(a+48+8) - ed(a+24+8);
                         ed(a+48+9) - ed(a+24+9)];       
                     
             Cq_elementa=[Cq_elementa;  % spoj pole zgoraj  -glava spodaj sp 6 in sp7               
                         ed(a+48+7) - ed(a+36+1);
                         ed(a+48+8) - ed(a+36+2);
                         ed(a+48+9) - ed(a+36+3);
                         ed(a+48+10) - ed(a+36+4);
                         ed(a+48+11) - ed(a+36+5);
                         ed(a+48+12) - ed(a+36+6)];
                   
            Cq_elementa=[Cq_elementa;  % spoj pole z ground -sp8                
                         ed(a+48+1) - e_zp(a+48+1);
                         ed(a+48+2) - e_zp(a+48+2);
                         ed(a+48+3) - e_zp(a+48+3)
                         ed(a+48+4) - e_zp(a+48+4)
                         ed(a+48+5) - e_zp(a+48+5)
                         ed(a+48+6) - e_zp(a+48+6)];
                     
                   Cq_elementa=[Cq_elementa;  %prvi spoj za izolatorjem
                     ed(a+60+7) - ed(a+72+1);
                     ed(a+60+8) - ed(a+72+2);
                     ed(a+60+9) - ed(a+72+3);
                    ed(a+60+10) - ed(a+72+4);
                    ed(a+60+11) - ed(a+72+5);
                    ed(a+60+12) - ed(a+72+6)];        
       a=a+72;
         %end
         
          case 5 %tipverige=5- A veriga-
         
                Cq_elementa=[Cq_elementa;
                       ed(a+7) - ed(a+12+1);  %sklop vodnik-levi krak A
                       ed(a+8) - ed(a+12+2);
                       ed(a+9) - ed(a+12+3);
                       ed(a+7) - ed(a+36+1); %sklop vodnik-jeleni vmesnik
                       ed(a+8) - ed(a+36+2);
                       ed(a+9) - ed(a+36+3);
                       ed(a+36+7) - ed(a+24+1);   %sklop jekleni vmesnik-izolator desni
                       ed(a+36+8) - ed(a+24+2);
                       ed(a+36+9) - ed(a+24+3)
                       ed(a+36+7) - ed(a+48+1);   %sklop jekleni vmesnik-vodnik desnii
                       ed(a+36+8) - ed(a+48+2);
                       ed(a+36+9) - ed(a+48+3)];
            Cq_elementa=[Cq_elementa;  % spoj izolatorja z ground -izolator levi A                
                         ed(a+12+7) - e_zp(a+12+7);
                         ed(a+12+8) - e_zp(a+12+8);
                         ed(a+12+9) - e_zp(a+12+9)];
                   
            Cq_elementa=[Cq_elementa;  % spoj izolatorja z ground -izolator desni A                
                         ed(a+24+7) - e_zp(a+24+7);
                         ed(a+24+8) - e_zp(a+24+8);
                         ed(a+24+9) - e_zp(a+24+9)];
                     
                     
                   Cq_elementa=[Cq_elementa;  %prvi spoj za izolatorjem
                     ed(a+48+7) - ed(a+60+1);
                     ed(a+48+8) - ed(a+60+2);
                     ed(a+48+9) - ed(a+60+3);
                    ed(a+48+10) - ed(a+60+4);
                    ed(a+48+11) - ed(a+60+5);
                    ed(a+48+12) - ed(a+60+6)];        
       a=a+60;      
         case 6 %tipverige=6- IB veriga- 
         
               Cq_elementa=[Cq_elementa;
                       ed(a+7) - ed(a+36+1);  %sklop vodnik-vodnik za izolatorjem
                       ed(a+8) - ed(a+36+2);
                       ed(a+9) - ed(a+36+3);
                       ed(a+10) - ed(a+36+4);
                       ed(a+11) - ed(a+36+5);
                       ed(a+12) - ed(a+36+6);
                       ed(a+7) - ed(a+12+1);   %sklop vodnik-izolator desni
                       ed(a+8) - ed(a+12+2);
                       ed(a+9) - ed(a+12+3)
                       ed(a+7) - ed(a+24+1);   %sklop vodnik-izolator levi
                       ed(a+8) - ed(a+24+2);
                       ed(a+9) - ed(a+24+3)];
            Cq_elementa=[Cq_elementa;  % spoj izolatorja z ground -izolator desni                
                         ed(a+12+7) - e_zp(a+12+7);
                         ed(a+12+8) - e_zp(a+12+8);
                         ed(a+12+9) - e_zp(a+12+9)];
                   
            Cq_elementa=[Cq_elementa;  % spoj izolatorja z ground -izolator levi                
                         ed(a+24+7) - e_zp(a+24+7);
                         ed(a+24+8) - e_zp(a+24+8);
                         ed(a+24+9) - e_zp(a+24+9)];
                     
                     
                   Cq_elementa=[Cq_elementa;  %prvi spoj za izolatorjem
                     ed(a+36+7) - ed(a+48+1);
                     ed(a+36+8) - ed(a+48+2);
                     ed(a+36+9) - ed(a+48+3);
                    ed(a+36+10) - ed(a+48+4);
                    ed(a+36+11) - ed(a+48+5);
                    ed(a+36+12) - ed(a+48+6)];        
       a=a+48;
         end   
 
       
     elseif i>=2 && i==ne_c(k,1) && k== hh-1  % C. sklop vodnik steber desno
     %opomba- zadnjih treh ne rabim ker ni zapisan v omenjitvi
        Cq_elementa=[Cq_elementa;
                     ed(a+7) - e_zp(a+7);
                     ed(a+8) - e_zp(a+8);
                     ed(a+9) - e_zp(a+9)];
       % 3 pride iz element+konstanta
                 % display('zadnji')
       
     % a=a+12;
     end
% ii=ii+1;  %% šeštevanje elementov vodnika
 end
end
% 
%   display(((Cq_elementa)))
%   stop

Cc=Cq_elementa;
%stop
%rezultat matrika C(x)

%Ce_1=(Ce).';  %rezultat transponirana matrika Cq

% ime_datoteke2=strcat('Ce_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice
% save(ime_datoteke2, 'ime_datoteke1','Ce','Ce_1');  %shranjevanje variabel v to datoteko
% display(ime_datoteke2);
% display('konec izraèuna Ce matrike');

end
 