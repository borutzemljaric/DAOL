 %% funkcija Qe za izraèun zunanje sile
    function Qe_db=external_Qe(hh,ne_c,le,g,m_c,db,ne_i,tipverige)  %tvorjenje relativnega raztezka za korak t-1 (en korak nazaj)

% db.c=db1_c
% db.z*ne_c=0;%podatki lokacije zaèetka dodatnega bremena v % razpetine
% db.span_z=1; %podatek v kateri razpetine se zaène dodatno breme
% db.k=1; %podatki lokacije konca dodatnega bremena%meje dodatnega bremena
% db.span_k=1;  %podatek v kateri razpetine se konèa dodatno breme 
   
% pogoji za doloèitev kje je dodatno breme
% pogoj_zacetka_element
p_z_e=round(db.z*ne_c(db.span_z,1)); %podatki lokacije zaèetka dodatnega bremena v % razpetine -doloæitev elementa
%pogoj_konca_element
p_k_e=round(db.k*ne_c(db.span_k,1)); %podatki lokacije konca dodatnega bremena v % razpetine -doloæitev elementa
% display(p_z_e)
% display(p_k_e)
% st
Qe_elementa=[]; % definicija prazne matrike
   ii=1;
for k=1:hh-1   %razpetine span
 for i=1:ne_c(k,1)  %elementi
  
    %if k~=hh-1&&i==ne_c(k,1)&&(i>=p_z_e&&i<=p_k_e)&&(k>=db.span_z&&k<=db.span_k)  % za kombinacijo vodnik-izolator ki je znotraj obmocja bremena
    if k~=hh-1&&i==ne_c(k,1)&&(i>=p_z_e&&k>=db.span_z)&&(i<=p_k_e&&k<=db.span_k)  
    Qe_elementa=[Qe_elementa Qg(g,m_c,le(k,i))];
    ii=ii+1;  %% šeštevanje elementov vodnika
 
      for j=1:ne_i %izraèun masne matrike elementa izolatorja
         %tipberige=0- ni verige
         %tipverige=1- I veriga
         %tipverige=2- V veriga
      switch tipverige(k+1,1)
          case 0

         case 1
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      % predefiniram da je dodatno breme na izolatorje enako niè
       ii=ii+1;  %% šeštevanje elementov izolatorja
         case 2 
       Qe_elementa=[Qe_elementa  0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       case 3 
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       case 4 
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       case 5 
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       case 6 
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       
      end
      end
     %  display('d')
   % elseif k~=hh-1&&i==ne_c(k,1)&&(i<p_z_e&&i>p_k_e)&&(k<db.span_z&&k>db.span_k)  % za kombinacijo vodnik-izolator ki  je zunaj dodatnega bremena
    elseif k~=hh-1&&i==ne_c(k,1)%&& (i<p_z_e&&k<=db.span_z)&&(i>p_k_e&&k>=db.span_k) 
      Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];
      ii=ii+1;  %% šeštevanje elementov vodnika
 
      for i=1:ne_i %izraèun masne matrike elementa izolatorja
         %tipberige=0- ni verige
         %tipverige=1- I veriga
         %tipverige=2- V veriga
      switch tipverige(k+1,1)
          case 0

         case 1
       Qe_elementa= [Qe_elementa 0*Qg(g,m_c,le(k,i))];      % predefiniram da je dodatno breme na izolatorje enako niè
       ii=ii+1;  %% šeštevanje elementov izolatorja
         case 2
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
        case 3 % ponovi se case 2
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       case 4 
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       case 5 
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       case 6 
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];      
       ii=ii+1;  %% šeštevanje elementov izolatorja
       
      end
      end
  %     display('c')
        
      %elseif (i>=p_z_e&&i<=p_k_e)&&(k>=db.span_z&&k<=db.span_k)  % % za kombinacijo vodnik-vodnik (vse)
    elseif (i>=p_z_e&&k>=db.span_z)&&(i<=p_k_e&&k<=db.span_k)     
        
    Qe_elementa=[Qe_elementa Qg(g,m_c,le(k,i))];
    ii=ii+1;  %% šeštevanje elementov vodnika
  %   display('b')
        else   % % za kombinacijo vodnik-vodnik (vse)
    Qe_elementa=[Qe_elementa 0*Qg(g,m_c,le(k,i))];
    ii=ii+1;  %% šeštevanje elementov vodnika
  %  display('a')
    end
 end
 
end
% pretvorba vrstice v stolpec
Qe_db=Qe_elementa';
% display(Qe_db)
% st

end

