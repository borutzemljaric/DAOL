%% funkcija ureditev parov
    function [par_K par_U]=ureditevparov(pari) 
        N_parov=size(pari);
        a=1;
        b=1;
          for k=1:N_parov
                if pari(k,1)==0
                         % prva kolona -katera neodvisna pripada odvisni
                         %druga kolona- odvisne koordinate
                         %tretja kolona- indeks kje se nahaja odvisna v
                         %originalnem vrstnem redu
                    par_K(a,:)=[pari(k,:) k];  
                    a=a+1;
                else
                    par_U(b,:)=[pari(k,:) k];
                    b=b+1;
                end
          end
%         display(par_K)
%         display(par_U)
%         stop
    end