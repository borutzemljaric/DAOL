   %% funkcija izraèun neodvisne koordinate
    function [neodvisneV,exitflag_Niter]=...
            neod_U(neodvisneV,konstanteU,hh,ne_c,V,U,konstante,E_c,A_c,le,d_c,Bdi,pari,Qe,ne_i,tipverige,izo,DK)
 [ n_i niv]=size(V');
  Niter=0;
  eps_e=1;  %epsilon za preverjanje koraka, dummy da vstipim v spodnjo zanko
  eps_R=1;   %epsilon za preverjanje residuala fumkcije,, dummy da vstipim v spodnjo zanko
  delta_e=zeros(n_i,1);
  
  
  
  while (eps_e>1e-5 || eps_R>1e-4) && Niter<200
  J = jacobian(@(ei)resfor_Re(ei,konstanteU,hh,ne_c,V,U,konstante,E_c,A_c,le,d_c,Bdi,pari,Qe,ne_i,tipverige,izo,DK),neodvisneV);
  F =resfor_Re(neodvisneV,konstanteU,hh,ne_c,V,U,konstante,E_c,A_c,le,d_c,Bdi,pari,Qe,ne_i,tipverige,izo,DK);
  delta_e=-J\F;  %korak 
  %pause
  neodvisneV=neodvisneV+delta_e; 
  %display(neodvisneV)
  Niter=Niter+1;   %število iteracije
  eps_e=norm(delta_e);  %epsilon za preverjanje koraka
  eps_R=norm(F) ;  %epsilon za preverjanje residuala fumkcije
 % pause
 %stop
%     if Niter==3
%        stop
%     end
  if Niter==200
     exitflag_Niter=3;  % èe je število iteracij preseeno gre na zaèetek zanke
  else
      exitflag_Niter=0;
  end
  end
 %  display(neodvisneV)
    end