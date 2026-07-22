 %% funkcija za izraèun generalizirane sile zaradi vetra
        function Qw=Qw_element(DK,dci,l,e,edot)
 
     %izracun relativnih hitrosti
     Uyzx=[ DK.Uy-edot(8); -edot(9);DK.Ux-edot(7)]; % pozor zamenjan vrstni red v yzx zaradi ransformacijske matrike

     %transformacijska matrika -pretvorba v lokalni/globalni sistem
%      Cew=[e(5)  sqrt(1-e(6)^2) -e(4);
%          -e(5)*e(6)/sqrt(1-e(6)^2)  e(6) e(4)*e(6)/sqrt(1-e(6)^2);
%          e(4)/sqrt(1-e(6)^2)  0  e(5)/sqrt(1-e(6)^2)];
%   
     % prava% popravljeno 19.3.2019 e(6) in njegov spodnji koren sta
     % zamenjana glede na originalnega
     Cew=[e(5)  e(6) -e(4);
         -e(5)*e(6)/sqrt(1-e(6)^2)  sqrt(1-e(6)^2)  e(4)*e(6)/sqrt(1-e(6)^2);
         e(4)/sqrt(1-e(6)^2)  0  e(5)/sqrt(1-e(6)^2)];     
     
     
     
     
     Utnb=Cew*Uyzx; %Pretvorba relativnih hitrosti v lokalni sistem
     
     vtr=Utnb(1);
     vnr=Utnb(2);
     vbr=Utnb(3);
 
    %komponente sile
    Fdt=(-1/2)*DK.rw*DK.cdt*dci*1e-3*vtr*abs(vtr);
    Fdn=(-1/2)*DK.rw*DK.cdn*dci*1e-3*(vnr^2+vbr^2)^(1/2)*vnr;
    Fdb=(-1/2)*DK.rw*DK.cdb*dci*1e-3*(vnr^2+vbr^2)^(1/2)*vbr;  
    
    %Pretvornba nazaj v globalni sistem
    Fyzx=Cew'*[Fdt; Fdn; Fdb]; 
    %pause
     % tvorba vektorja generaliziranih sil 
     % vzamem da deluje na vsako stran polovica
     Qw=l*[Fyzx(3)/2 Fyzx(1)/2 Fyzx(2)/2 -Fyzx(3)*l/8 -Fyzx(1)*l/8 -Fyzx(2)*l/8 ...
             Fyzx(3)/2 Fyzx(1)/2 Fyzx(2)/2 -Fyzx(3)*l/8 -Fyzx(1)*l/8 -Fyzx(2)*l/8]'; % pretvorba v stolpec

