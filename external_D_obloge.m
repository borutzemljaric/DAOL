 %% funkcija  za doloèitev zunanjega premera vodnika/obloge posameznega
 %% segmenta
    function Dcc=external_D_obloge(hh,ne_c,d_c,db)  %tvorjenje relativnega raztezka za korak t-1 (en korak nazaj)
% db.d premer obloge
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
%display(ne_i)
Dcc=[]; % definicija prazne matrike
   ii=1;
for k=1:hh-1   %razpetine span
 for i=1:ne_c(k,1)  %elementi
  
    %if k~=hh-1&&i==ne_c(k,1)&&(i>=p_z_e&&i<=p_k_e)&&(k>=db.span_z&&k<=db.span_k)  % za kombinacijo vodnik-izolator ki je znotraj obmocja bremena
    if k~=hh-1&&i==ne_c(k,1)&&(i>=p_z_e&&k>=db.span_z)&&(i<=p_k_e&&k<=db.span_k)  
    Dcc(k,i)=d_c;
    ii=ii+1;  %% šeštevanje elementov vodnika
 
     %  display('d')
   % elseif k~=hh-1&&i==ne_c(k,1)&&(i<p_z_e&&i>p_k_e)&&(k<db.span_z&&k>db.span_k)  % za kombinacijo vodnik-izolator ki  je zunaj dodatnega bremena
    elseif k~=hh-1&&i==ne_c(k,1)%&& (i<p_z_e&&k<=db.span_z)&&(i>p_k_e&&k>=db.span_k) 
      Dcc(k,i)=d_c;
 
      %elseif (i>=p_z_e&&i<=p_k_e)&&(k>=db.span_z&&k<=db.span_k)  % % za kombinacijo vodnik-vodnik (vse)
    elseif (i>=p_z_e&&k>=db.span_z)&&(i<=p_k_e&&k<=db.span_k)     
        
   Dcc(k,i)=db.d;

        else   % % za kombinacijo vodnik-vodnik (vse)
   Dcc(k,i)=d_c;
  %  display('a')
    end
 end
 
end


end

