function [Zd,td]=zdruzevanjeDatotek(ime_datoteke1)
% funkcija ki združi veè izhodnih datotek /rezultatov dinamike) v eno
% datoteko


%najprej odprem prvo datoteko
 ime_datoteke_del=strcat(num2str(1),'e_dinamicni_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice 
 load(ime_datoteke_del, 't','Z','ste_delitev') 
 s=numel(t); %število vpisov, 
% display(size(t))
% display(size(Z))
 Z(s,:)=[]; %brisem zadnjega
 t(s)=[];   %brisem zadnjega
% ste_delitev=3

td=t; Zd=Z;
%sedaj odpiram posamezne datoteke in vpisujem v novo datoteko
for i=2:ste_delitev  %dodaj na želeno število vhodnih datotek zaènem z dva ker sem prvo že odprl da sem doloèil datoteko izo_o, toc_o
    ime_datoteke_del=strcat(num2str(i),'e_dinamicni_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice 
    load(ime_datoteke_del, 't','Z')
    if i<ste_delitev

   s=numel(t); %število vpisov, 
   Z(s,:)=[]; %brisem zadnjega
   t(s)=[];   %brisem zadnjega
 
   td=[td;t];  % sestava vektorja èasov
   Zd=[Zd;Z]; % sestava vektorja koordinat
    else % vpišem zadnjo datoteko in ne brišem zadnjega mesta
   td=[td;t];  % sestava vektorja èasov
   Zd=[Zd;Z]; % sestava vektorja koordinat        
    end
end
 

 
 