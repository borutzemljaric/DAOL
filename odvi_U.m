%% funkcija izraèun odvisne koordinate 
    function odvisneU=odvi_U(odvisneU,hh,ne_c,neodvisneV,V,U,tipverige,e_zp)
  %jacobijeva funkcija
  Niter=0;
  eps_e=1;  %epsilon za preverjanje koraka, dummy da vst0pim v spodnjo zanko
  eps_R=1;   %epsilon za preverjanje residuala fumkcije,, dummy da vstipim v spodnjo zanko
  %delta_e=zeros(n_d,1);
  while (eps_e>1e-5 || eps_R>1e-4) &&Niter<200
  J = jacobian(@(edd)constrain_C_C(edd,hh,ne_c,neodvisneV,V,U,tipverige,e_zp),odvisneU);
  F =constrain_C_C(odvisneU,hh,ne_c,neodvisneV,V,U,tipverige,e_zp);
  delta_e=-J\F;
  odvisneU=odvisneU+delta_e;   
  Niter=Niter+1;   %število iteracije
  eps_e=norm(delta_e);  %epsilon za preverjanje koraka
  eps_R=norm(F);   %epsilon za preverjanje residuala fumkcije
  end
   % display(size(odvisneU))
 %  display(odvisneU)
% stop
    end