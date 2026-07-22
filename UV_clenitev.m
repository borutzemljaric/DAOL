function [U V Ce]=UV_clenitev(Ce_active,konstante,neod_fix)
%funkcija ki doloèi odvisne U in neodvisne V spremenljivke 
%verzija 03.01.14
%verzija 30.04.2014 (dopolnjeno da jemlje samo aktivne koordinate)

% Branje datoteke s podatki segmentacije
% [ime_datoteke, pathname] = ...
%      uigetfile({'*.mat','*.*'},'File Selector');  %vneseš datoteko z vhodnimi podatki
% 
% load(ime_datoteke, 'Ce');

%display(Ce_active)
%zapišem še  aktivne odvisne koordinate
%active_U=setdiff(U,konstante');
% izloèim konstante
[nc,n]=size(Ce_active);
index=1:n;
%index_1=setdiff(index,konstante); %vpeljem pomožno matriko da izloèim konstante
index_1=setdiff(index,neod_fix); %v pomožno matriko da izloèim vnaprej doloèene neodvisne koordinate
%index_1=[index_1 neod_fix konstante];  %sestava vektorja kje so desno postavljene doloèene neodvisne koordinate
index_1=[index_1 neod_fix];  %sestava vektorja kje so desno postavljene doloèene neodvisne koordinate
Ce_active=Ce_active(:,index_1);
%[nc,n]=size(Ce_active);
[active_Ce index]=gausovaeliminacija(Ce_active,nc, index_1);

% display(index)
% stop

%display(U)
U_active=(index(1,1:nc));
%display(V)
V_active=(index(1,nc+1:n));
%konec Drugega dela

%za izhod zapišem nove vrednosti 
U=U_active;
V=V_active;
Ce=active_Ce;
%%st
%konec


    function [Ce index]=gausovaeliminacija(Ce,nc,index)
% algoritem Gaussian elimination
for k=1:nc
   % Exchange step
   [piv,i]=max(abs(Ce(k,:)));  %iskanje pivota v vrstici
    if i>k   % zamenjava stolpca glede na pivot
  pom=Ce(:,k);
  Ce(:,k) =Ce(:,i); %
  Ce(:,i) =pom; %
  pom_i=index(1,k);
  index(1,k) =index(1,i); %
  index(1,i) =pom_i; %
    end
  % gaussova eliminacija
  if k<nc-1  %doloèim da gre eliminacija do predzadnje vrstive, zadnja se samo zamenja v predhodnem if stavku
 for v=k+1:nc  % v- vrstice
     m=Ce(v,k)/Ce(k,k);
     if Ce(k,k)==0
         display('singularno')
        % display(k)
     end
    % Ce(v,k)=0;
     for s=k:n  %s-stolpci
         Ce(v,s)=Ce(v,s)-m*Ce(k,s);
     end
 end
end
end
    end

  
end
