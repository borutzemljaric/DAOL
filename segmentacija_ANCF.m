function segmentacija_ANCF(N,ime_datoteke1,vrv_c,izo,db,DK)


%% A. klicanje notranjih spremenljivk iz menu- odpri, branje datoteke z vhodnimi podatki daljnovoda
 
%prepisovanje podatkov vodnika
E_c=vrv_c(1,4);  %v N/mm2
m_c=vrv_c(1,3); %v kg/m
k_c=vrv_c(1,5)*1e-6;  % v 1/K
A_c=vrv_c(1,1);  %v mm2
d_c=vrv_c(1,2);  % v mm
izo.d_c=d_c; % izvedba prenosa da ne popravljam programa pri dodelavi
%g=10; %gravitacijska konstanta
g=9.81; %gravitacijska konstanta
EA=E_c*A_c;  %v N


%vhodni podatki za napenjalno polje
T1=0;  %temperatura zaèetna postavim na 0 stopinj celzija
a = [N{:,2}];  %pretvorba celice v matriko za razpetine
%Lv=[N{:,8}];  %dolžina verige v m, napenjalne verige postaviti na 0
tipverige=[N{:,5}];  %opredelitev ali gre za I,V, B verigo
H1_c= [N{:,6}]*1e3;  %pretvorba celice v matriko da dobim nateg napenjalnega polja vodnik, v kN horizontalna sila za vodnik zaèetna
ne_c=[N{:,7}]; %pretvorba celice v matriko da dobim število delitev po razpetinah
%H1_c=S1_c*1e3%*A_c; %preraèun v silo N, velja za vsako razpetino posebej
% spodnijih pdatkov za dodatno breme ne potrebujem, ker pred deiniram db.c
% ki ga uporabljam v nadaljevanju
% db1_c=[N{:,20}];%*0.18*sqrt(d_c)*10; %v N/m, %pretvorba celice v matriko da dobim koeficienta dodatnega bremena vodnika
% db1_c=db1_c(1,1);
 db1_c=100000;  % ne potrebujem -fiktivna vrednost
% db2_c=0;
%db.c=db1_c  % podatek o masi na dolžinsko enoto (pazi kg/m)
%**************************************************************************
%% C. Izraèun dolžine vrvi, gravitacijske razpetine

%[hh,hhh]=size(a);
%display(a);
%a(hh,:)=[]; %brisanje zadnje vrstice podatkov razpetin (ta je niè!)
h = [N{:,3}]+[N{:,4}];%-Lv;  %%tukaj je h višinska kota obesisca  (kota terena + steber do obesišèa!!!)
%display(h);
[hh,hhh]=size(h);  %število obesišè ki je za 1 veèje od števila razpetin
for k=1:hh-1  %štetje po razpetinah
    h_k(k,1)=(h(k,1)-h(k+1)); %izraèun višinske razlike med obesisci
%     %vmesno=sinh((m_c*g*a(k,1))/(2*H1_c(k,1)));

x0 = [a(k,1) m_c*g*a(k,1)]; %zaèetni pogoji
 %H1_c(k,1)=H_0(k,1); % za test 

    [x]=fsolve(@(x)enacbi(x,H1_c(k,1),EA,m_c,g,a(k,1),h_k(k,1)),x0);
         l(k,1)=sqrt(h_k(k,1)^2+(((2*H1_c(k,1))/(m_c*g))*sinh((m_c*g*a(k,1))/(2*H1_c(k,1))))^2); %dolžina vrvi raztegnjena klasièno
         y(k,1)=(H1_c(k,1)/(m_c*g))*log((H1_c(k,1)/(m_c*g*(l(k,1)-h_k(k,1))))*(1-exp((-m_c*g*a(k,1))/H1_c(k,1))));  %gravitacijska razpetina
%         y_0(k,1)=(H_0(k,1)/(m_c*g))*log((H_0(k,1)/(m_c*g*(lo(k,1)-h_k(k,1))))*(1-exp((-m_c*g*a(k,1))/H_0(k,1)))); 
%         V_k(k,1)=H1_c(k,1)*sinh((m_c*g*(y(k,1)))/(H1_c(k,1))); %  vertikalna sila v levem obsesišèu vodnika v k razpetini
%         V_kd(k,1)=H1_c(k,1)*sinh((m_c*g*(a(k,1)+y(k,1)))/(H1_c(k,1))); %  vertikalna sila v desnem obsesišèu vodnika v k razpetini
%         s_k(k,1)=H1_c(k,1)*cosh((m_c*g*y(k,1))/(H1_c(k,1))); % sila v levem obsesišèu vodnika v k razpetini
%         s_kd(k,1)=H1_c(k,1)*cosh((m_c*g*(a(k,1)+y(k,1)))/(H1_c(k,1))); %  sila v desnem obsesišèu vodnika v k razpetini
   
   lo(k,1)=x(1);
   V(k,1)=x(2); 
       %poves za kontrolo
      % poves(k,1)=((h_k(k,1)/2))+(H1_c(k,1)/(m_c*g))*(cosh((m_c*g*y(k,1))/H1_c(k,1))-cosh((m_c*g*(a(k,1)/2+y(k,1)))/H1_c(k,1)));
end

%  display(lo_1)
%   display(lo)
%  display(V)
%  display(H1_c)
% stop


%% izraèun koordinat y in z v lokalnem sistemu
for k=1:hh-1   %število razpetin
    
    S=0:lo(k,1)/ne_c(k):lo(k,1); % razdelitev neraztegnjene dolžine na segmente
        
    for s=1:(ne_c(k)+1)
 

    if h_k(k,1)>=0
        [y_js(k,s) z_js(k,s) by_js(k,s) bz_js(k,s)]=tocke(S(1,s),H1_c(k,1),V(k,1),lo(k,1),EA,m_c,g);
        le(k,s)=lo(k,1)/ne_c(k);
      %  poves(k,1)=((h_k(k,1)/2))+(H1_c(k,1)/(m_c*g))*(cosh((m_c*g*(y_js(k,s)+y(k,1)))/H1_c(k,1))-cosh((m_c*g*(a(k,1)/2+(y_js(k,s)+y(k,1))))/H1_c(k,1)))
%       y_js(k,s)=y(k,1)+(((s-1)*a(k,1))/ne_c(k)); %doloèitev y koordinate s premikom koordinatnega izhodišèa v teme verižnice
%       y0_js(k,s)=y_0(k,1)+(((s-1)*a(k,1))/ne_c(k));% izraèun neraztegnjenega vodnika
%       
%       [y1_js(k,s),z1_js(k,s)]=test(lo(k,1),S(1,s),V_k(k,1),H1_c(k,1),EA,m_c,g);
%       y_js(k,s)=(-y(k,1)-a(k,1))+(((s-1)*a(k,1))/ne_c(k)); %doloèitev y koordinate s premikom koordinatnega izhodišèa v teme verižnice
%       y0_js(k,s)=(-y_0(k,1)-a(k,1))+(((s-1)*a(k,1))/ne_c(k)); % izraèun neraztegnjenega vodnika
    end
        [y_js(k,s) z_js(k,s) by_js(k,s) bz_js(k,s)]=tocke(S(1,s),H1_c(k,1),V(k,1),lo(k,1),EA,m_c,g);  %znotraj obrnem veriznico zato drugi indeksi
        le(k,s)=lo(k,1)/ne_c(k);
    end
end

% izpis le je za en stolpec preveè zato prvi stolpec zbrišem
le(:,1)=[];

bx_js=zeros(size(bz_js));

 %    display (y_js)
  %   display (z_js)
%      display (by_js)
%     display (bz_js)
 %st
%    % display (z_js)
%    display (z0_js)

   
%% prestavitev koordinate z na globalno vrednost (glede na podolžni profil)

for k=1:hh-1   %število razpetin
    %display(h(k,1))
    %delta(k,1)=h(k,1)-z_js(k,1);
    for s=1:(ne_c(k)+1)
    zl_js(k,s)=-z_js(k,s)+h(k,1);%+delta(k,1); %izraèun višinske razlike med obesisci
    end
end
%  display (zl_js)
%  
% %do tu izraèuna v redu poves 
%  figure
%      plot(yl_js(2,:),z_js(2,:))
%     title('zaèetni poves 1 razpetina p klasièni metodi');
%   % hold on


%% priprava koordinat za izolatorje v lokalnem sistemu

for k=1:hh-2
switch tipverige(k+1,1)
    
    case 0  % ni verige zato prazno
    case 1  % I veriga
        xi_i(k,1)=0;
        yi_i(k,1)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,1)=zl_js(k,ne_c(k)+1);      
        xi_i(k,2)=0;
        yi_i(k,2)=0;%yl_js(k,ne_c(k)+1);  
        zi_i(k,2)=zl_js(k,ne_c(k)+1)+izo.izo_i(1,1);  %dodam 1e-4 da prepreèim numerièno nestabilnoat
      %        zi_i(k,2)=zl_js(k,ne_c(k)+1)+izo_i(1,1)+1e-5;  %dodam 1e-4 da prepreèim numerièno nestabilnoat

        ne_i(k)=1;
        by_i(k,1)=0; %naklon
        bx_i(k,1)=0;% naklon
        bz_i(k,1)=1;% naklon
        by_i(k,2)=0; %naklon
        bx_i(k,2)=0;% naklon
        bz_i(k,2)=1;% naklon
        %i=i+1;
    case 2  %V veriga
        xi_i(k,1)=0;
        yi_i(k,1)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,1)=zl_js(k,ne_c(k)+1);
        
        xi_i(k,2)=izo.izo_V(1,1)*sind(izo.izo_V(1,6)/2);
        yi_i(k,2)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,2)=zl_js(k,ne_c(k)+1)+izo.izo_V(1,1)*cosd(izo.izo_V(1,6)/2)+1e-5;%dodam 1e-5 da prepreèim numerièno nestabilnoat
        
        xi_i(k,3)=0;
        yi_i(k,3)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,3)=zl_js(k,ne_c(k)+1);
        
        
        xi_i(k,4)=-izo.izo_V(1,1)*sind(izo.izo_V(1,6)/2);
        yi_i(k,4)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,4)=zl_js(k,ne_c(k)+1)+izo.izo_V(1,1)*cosd(izo.izo_V(1,6)/2)+1e-5;%dodam 1e-5 da prepreèim numerièno nestabilnoat
        
       % li_i(k,1)=izo_V(1,1);
        ne_i(k)=2;
        
        bx_i(k,1)=sind(izo.izo_V(1,6)/2);% naklon
        by_i(k,1)=0; %naklon
        bz_i(k,1)=cosd(izo.izo_V(1,6)/2);% 
        
        bx_i(k,2)=sind(izo.izo_V(1,6)/2);% naklon
        by_i(k,2)=0; %naklon
        bz_i(k,2)=cosd(izo.izo_V(1,6)/2);% 
        
        bx_i(k,3)=-sind(izo.izo_V(1,6)/2);% naklon
        by_i(k,3)=0; %naklon
        bz_i(k,3)=cosd(izo.izo_V(1,6)/2);% 
        
        bx_i(k,4)=-sind(izo.izo_V(1,6)/2);% naklon
        by_i(k,4)=0; %naklon
        bz_i(k,4)=cosd(izo.izo_V(1,6)/2);% 
        %i=i+1;
      case 3
      xi_i(k,1)=0;
        yi_i(k,1)=0;
        zi_i(k,1)=zl_js(k,ne_c(k)+1);
        
        xi_i(k,2)=-izo.izo_P(1,1)*cosd(izo.izo_P(1,6));
        yi_i(k,2)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,2)=zl_js(k,ne_c(k)+1)-izo.izo_P(1,1)*sind(izo.izo_P(1,6));%dodam 1e-5 da prepreèim numerièno nestabilnoat
        
        xi_i(k,3)=0;
        yi_i(k,3)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,3)=zl_js(k,ne_c(k)+1);
          
        xi_i(k,4)=-izo.izo_B(1,1)*cosd(izo.izo_B(1,6)-izo.izo_P(1,6));
        yi_i(k,4)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,4)=zl_js(k,ne_c(k)+1)+izo.izo_B(1,1)*sind(izo.izo_B(1,6)-izo.izo_P(1,6));%dodam 1e-5 da prepreèim numerièno nestabilnoat
        
       % li_i(k,1)=izo_V(1,1);
        ne_i(k)=2;
        
        bx_i(k,1)=-cosd(izo.izo_P(1,6));% naklon
        by_i(k,1)=0; %naklon
        bz_i(k,1)=-sind(izo.izo_P(1,6));% 
        
        bx_i(k,2)=-cosd(izo.izo_P(1,6));% naklon
        by_i(k,2)=0; %naklon
        bz_i(k,2)=-sind(izo.izo_P(1,6));% naklon
        
        bx_i(k,3)=-cosd(izo.izo_B(1,6)-izo.izo_P(1,6));
        by_i(k,3)=0; %naklon
        bz_i(k,3)=sind(izo.izo_B(1,6)-izo.izo_P(1,6));
        
        bx_i(k,4)=-cosd(izo.izo_B(1,6)-izo.izo_P(1,6));
        by_i(k,4)=0; %naklon
        bz_i(k,4)=sind(izo.izo_B(1,6)-izo.izo_P(1,6));
        case 4
            % prvi izolator
        xi_i(k,1)=0;
        yi_i(k,1)=0;
        zi_i(k,1)=zl_js(k,ne_c(k)+1);
        
        xi_i(k,2)=-izo.izo_P(1,1)*cosd(izo.izo_P(1,6));
        yi_i(k,2)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,2)=zl_js(k,ne_c(k)+1)-izo.izo_P(1,1)*sind(izo.izo_P(1,6));%dodam 1e-5 da prepreèim numerièno nestabilnoat
        % drugi izolator
        xi_i(k,3)=0;
        yi_i(k,3)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,3)=zl_js(k,ne_c(k)+1);
          
        xi_i(k,4)=-izo.izo_B(1,1)*cosd(izo.izo_B(1,6)-izo.izo_P(1,6));
        yi_i(k,4)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,4)=zl_js(k,ne_c(k)+1)+izo.izo_B(1,1)*sind(izo.izo_B(1,6)-izo.izo_P(1,6));%dodam 1e-5 da prepreèim numerièno nestabilnoat
        
       % li_i(k,1)=izo_V(1,1);
        ne_i(k)=2;
        
        bx_i(k,1)=-cosd(izo.izo_P(1,6));% naklon
        by_i(k,1)=0; %naklon
        bz_i(k,1)=-sind(izo.izo_P(1,6));% 
        
        bx_i(k,2)=-cosd(izo.izo_P(1,6));% naklon
        by_i(k,2)=0; %naklon
        bz_i(k,2)=-sind(izo.izo_P(1,6));% naklon
        
        bx_i(k,3)=-cosd(izo.izo_B(1,6)-izo.izo_P(1,6));
        by_i(k,3)=0; %naklon
        bz_i(k,3)=sind(izo.izo_B(1,6)-izo.izo_P(1,6));
        
        bx_i(k,4)=-cosd(izo.izo_B(1,6)-izo.izo_P(1,6));
        by_i(k,4)=0; %naklon
        bz_i(k,4)=sind(izo.izo_B(1,6)-izo.izo_P(1,6));
%         %i=i+1;
        % zgornji del stebra
        xi_i(k,5)=xi_i(k,2); %zaèetni del elementa
        yi_i(k,5)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,5)=zi_i(k,2);      
        xi_i(k,6)=xi_i(k,4); % konèni del elementa
        yi_i(k,6)=0;%yl_js(k,ne_c(k)+1);  
        zi_i(k,6)=zi_i(k,4);  %dodam 1e-4 da prepreèim numerièno nestabilnoat
        izo.izo_glava=sqrt((zi_i(k,5)-zi_i(k,6))^2+(xi_i(k,5)-xi_i(k,6))^2); %Definiram ker rabim v nadljevanju
        by_i(k,5)=0; %naklon
        bx_i(k,5)=0;% naklon
        bz_i(k,5)=1;% naklon
        by_i(k,6)=0; %naklon
        bx_i(k,6)=0;% naklon
        bz_i(k,6)=1;% naklon
       %spodnji del stebra
        xi_i(k,7)=xi_i(k,2); %zaèetni del elementa
        yi_i(k,7)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,7)=zi_i(k,2)-izo.st_pole(1,1);      
        xi_i(k,8)=xi_i(k,2); % konèni del elementa
        yi_i(k,8)=0;%yl_js(k,ne_c(k)+1);  
        zi_i(k,8)=zi_i(k,2);  %dodam 1e-4 da prepreèim numerièno nestabilnoat
        by_i(k,7)=0; %naklon
        bx_i(k,7)=0;% naklon
        bz_i(k,7)=1;% naklon
        by_i(k,8)=0; %naklon
        bx_i(k,8)=0;% naklon
        bz_i(k,8)=1;% naklon
        case 5
            % prvi izolator
        xi_i(k,1)=0;
        yi_i(k,1)=-izo.izo_A(1,5)/2;
        zi_i(k,1)=zl_js(k,ne_c(k)+1);
        xi_i(k,2)=0;
        yi_i(k,2)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,2)=zl_js(k,ne_c(k)+1)+sqrt(izo.izo_A(1,1)^2-(izo.izo_A(1,5)/2)^2);%dodam 1e-5 da prepreèim numerièno nestabilnoat
     
        % drugi izolator
        xi_i(k,3)=0;
        yi_i(k,3)=izo.izo_A(1,5)/2;%yl_js(k,ne_c(k)+1);
        zi_i(k,3)=zi_i(k,1);         
        xi_i(k,4)=0;
        yi_i(k,4)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,4)=zi_i(k,2);%dodam 1e-5 da prepreèim numerièno nestabilnoat
        
       % li_i(k,1)=izo_V(1,1);
        ne_i(k)=2;
        
        bx_i(k,1)=0;% naklon
        by_i(k,1)=izo.izo_A(1,5)/2/izo.izo_A(1,1); %naklon
        bz_i(k,1)=sqrt(izo.izo_A(1,1)^2-(izo.izo_A(1,5)/2)^2)/izo.izo_A(1,1);% 
        bx_i(k,2)=0;% naklon
        by_i(k,2)=izo.izo_A(1,5)/2/izo.izo_A(1,1); %naklon
        bz_i(k,2)=sqrt(izo.izo_A(1,1)^2-(izo.izo_A(1,5)/2)^2)/izo.izo_A(1,1);% naklon
        
        bx_i(k,3)=0;
        by_i(k,3)=izo.izo_A(1,5)/2/izo.izo_A(1,1); %naklon
        bz_i(k,3)=-sqrt(izo.izo_A(1,1)^2-(izo.izo_A(1,5)/2)^2)/izo.izo_A(1,1);
        bx_i(k,4)=0;
        by_i(k,4)=izo.izo_A(1,5)/2/izo.izo_A(1,1); %naklon
        bz_i(k,4)=-sqrt(izo.izo_A(1,1)^2-(izo.izo_A(1,5)/2)^2)/izo.izo_A(1,1);
%         %i=i+1;
        % jekleni vmesnik
        xi_i(k,5)=0; %zaèetni del elementa
        yi_i(k,5)=yi_i(k,1);%yl_js(k,ne_c(k)+1);
        zi_i(k,5)=zi_i(k,1);      
        xi_i(k,6)=0; % konèni del elementa
        yi_i(k,6)=yi_i(k,3);%yl_js(k,ne_c(k)+1);  
        zi_i(k,6)=zi_i(k,3);  %dodam 1e-4 da prepreèim numerièno nestabilnoat
        by_i(k,5)=1; %naklon
        bx_i(k,5)=0;% naklon
        bz_i(k,5)=0;% naklon
        by_i(k,6)=1; %naklon
        bx_i(k,6)=0;% naklon
        bz_i(k,6)=0;% naklon
        case 6
        xi_i(k,1)=0;
        yi_i(k,1)=0;
        zi_i(k,1)=zl_js(k,ne_c(k)+1);
        
        xi_i(k,2)=0;
        yi_i(k,2)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,2)=zl_js(k,ne_c(k)+1)+izo.izo_IP(1,1);%dodam 1e-5 da prepreèim numerièno nestabilnoat
        
        xi_i(k,3)=0;
        yi_i(k,3)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,3)=zl_js(k,ne_c(k)+1);
          
        xi_i(k,4)=sqrt(izo.izo_IB(1,1)^2-izo.izo_IP(1,1)^2)+1e-5;%dodam 1e-5 da prepreèim numerièno nestabilnoat
        % ta se mi pojaclja pri bending generalizirani sili
        yi_i(k,4)=0;%yl_js(k,ne_c(k)+1);
        zi_i(k,4)=zl_js(k,ne_c(k)+1)+izo.izo_IP(1,1);
       % li_i(k,1)=izo_V(1,1);
        ne_i(k)=2;
        
        bx_i(k,1)=0;% naklon
        by_i(k,1)=0; %naklon
        bz_i(k,1)=1;% 
        
        bx_i(k,2)=0;% naklon
        by_i(k,2)=0; %naklon
        bz_i(k,2)=1;% naklon
        
        bx_i(k,3)=sqrt(izo.izo_IB(1,1)^2-izo.izo_IP(1,1)^2)/izo.izo_IB(1,1);
        by_i(k,3)=0; %naklon
        bz_i(k,3)=izo.izo_IP(1,1)/izo.izo_IB(1,1);
        
        bx_i(k,4)=sqrt(izo.izo_IB(1,1)^2-izo.izo_IP(1,1)^2)/izo.izo_IB(1,1);
        by_i(k,4)=0; %naklon
        bz_i(k,4)=izo.izo_IP(1,1)/izo.izo_IB(1,1);
       
end
end
%   display (xi_i)
%    display (zi_i)
%    st
 % display (by_i)

 
%**************************************************************************
%% priprava koordinatnih transformacijskih matrik v primeru loma trase
%%za vodnike
at= [N{:,8}];  %pretvorba celice v matriko da dobim kote v zaèetku razpetine iz vhodnih podatkov
%display(at);
% x koordinata je zaenkrat niè (lokalni sistem)
% y koordinata je podana z oznako yl_js
% z koordinata je podana z oznako zl_js
x_js=zeros(size(y_js));

for j=1:hh-1  %štetje po razpetinah (hh je število vrstic vhodnikh podatkov)
    at_j=at(j,1);
xx_js(j,:)=cosd(at_j)*x_js(j,:)-sind(at_j)*y_js(j,:); %tocka
yy_js(j,:)=sind(at_j)*x_js(j,:)+cosd(at_j)*y_js(j,:); %tocka
% bx_js(j,:)=cosd(at_j)*Bx_js(j,:)-sind(at_j)*By_js(j,:);% naklon
% by_js(j,:)=sind(at_j)*Bx_js(j,:)+cosd(at_j)*By_js(j,:); %naklon
end
% display(yy_js)
% stop
zz_js=zl_js; %SAMO PREPIS MATRIKE V DRUGO DA IMAM ISTE OZNAKE ZA X,Y,Z SPREMENLJIVKE
% bz_js=Bz_js;% SAMO PREPIS MATRIKE V DRUGO DA IMAM ISTE OZNAKE ZA X,Y,Z SPREMENLJIVKE
%%za izolatorje
for j=1:hh-2  %štetje po razpetinah (hh je število vrstic vhodnikh podatkov)
    at_j=at(j+1,1);
xi_js(j,:)=cosd(at_j/2)*xi_i(j,:)-sind(at_j/2)*yi_i(j,:);
yi_js(j,:)=sind(at_j/2)*xi_i(j,:)+cosd(at_j/2)*yi_i(j,:);
bxi_js(j,:)=cosd(at_j)*bx_i(j,:)-sind(at_j)*by_i(j,:);% naklon
byi_js(j,:)=sind(at_j)*bx_i(j,:)+cosd(at_j)*by_i(j,:); %naklon
end
%display (at_j)
% display (byi_js)
if norm(tipverige)>=1  %ta pogoj omogoèi delo s samo eno razpetino
zzi_js=zi_i; %SAMO PREPIS MATRIKE V DRUGO DA IMAM ISTE OZNAKE ZA X,Y,Z SPREMENLJIVKE
bzi_js=bz_i;
end

%**************************************************************************
%% prehod s lokalnih koordinat x,y na globalne koordinate X,Y, Z je že v
% globalni
% VODNIKI
x0=0; %zaèetna toèka daljnovoda
y0=0; %zaèetna toèka daljnovoda
for k=1:hh-1   %število razpetin
    for s=1:ne_c(k)+1 %število toèk (segmenti+1)
         xx_js(k,s)=xx_js(k,s)+x0;
         yy_js(k,s)=yy_js(k,s)+y0;
      
    end
         x0=xx_js(k,s);
         %display(s);
         y0=yy_js(k,s);
         %display(s)
end

%globalne koordinate vodnika
%  display (xx_js);
%  display (yy_js);
%  display(zz_js);
%  st
% IZOLATORJI
%translacija na konène toèke elementa k
if norm(tipverige)>=1  %ta pogoj omogoèi delo s samo eno razpetino
for k=1:hh-2   %število razpetin
         xxi_js(k,:)=xi_js(k,:)+xx_js(k,ne_c(k)+1);
         yyi_js(k,:)=yi_js(k,:)+yy_js(k,ne_c(k)+1);
      
end

%globalne koordinate izolatorja
%    display(xxi_js)
%    display(yyi_js)
%    display(zzi_js)
end
  
%   st
  %*************************
%priprava zaèetnih pogojev ANCF coordinates
%*************************

ii=1;
for k=1:hh-1 
 for i=1:ne_c(k,1)
     if k==1&& i==1  % A. spoj steber levo -vodnik

    e(:,:,ii)=[xx_js(k,i);yy_js(k,i);zz_js(k,i);bx_js(k,i);by_js(k,i);bz_js(k,i);...
        xx_js(k,i+1);yy_js(k,i+1);zz_js(k,i+1);bx_js(k,i+1);by_js(k,i+1);bz_js(k,i+1)];
    ii=ii+1;  %% šeštevanje elementov vodnika
                   
     elseif i>=2 && i~=ne_c(k,1) %&& k~= hh-1 % B. vodnik-vodnik
       
    e(:,:,ii)=[xx_js(k,i);yy_js(k,i);zz_js(k,i);bx_js(k,i);by_js(k,i);bz_js(k,i);...
        xx_js(k,i+1);yy_js(k,i+1);zz_js(k,i+1);bx_js(k,i+1);by_js(k,i+1);bz_js(k,i+1)];
    ii=ii+1;  %% šeštevanje elementov vodnika
    
     %display('prej in 1')
     elseif i>=2 && i==ne_c(k,1) && k~= hh-1 % C. sklop vodnik-vodnik-izolator
         %tipberige=0- ni verige
         %tipverige=1- I veriga
         %tipverige=2- V veriga ali Vee
          switch tipverige(k+1,1)
          
          case 0 %tipberige=0- ni verige /pravzaprav ne potrebujem
         % šeštevanje elementov izolatorja     
          e(:,:,ii)=[xx_js(k,i);yy_js(k,i);zz_js(k,i);bx_js(k,i);by_js(k,i);bz_js(k,i);...
          xx_js(k,i+1);yy_js(k,i+1);zz_js(k,i+1);bx_js(k,i+1);1;0];
          ii=ii+1;  %% šeštevanje elementov izolatorja
          
          case 1 %tipverige=1- I veriga
          e(:,:,ii)=[xx_js(k,i);yy_js(k,i);zz_js(k,i);bx_js(k,i);by_js(k,i);bz_js(k,i);...
          xx_js(k,i+1);yy_js(k,i+1);zz_js(k,i+1);bx_js(k,i+1);by_js(k,i+1);bz_js(k,i+1)];  % ima predpisan naklon konca elementa (ena in niè)
          ii=ii+1;  %% šeštevanje elementov izolatorja pred izolatorjem
          e(:,:,ii)=[xxi_js(k,1);yyi_js(k,1);zzi_js(k,1);bxi_js(k,1);byi_js(k,1);bzi_js(k,1);...
          xxi_js(k,2);yyi_js(k,2);zzi_js(k,2);bxi_js(k,2);byi_js(k,2);bzi_js(k,2)];
           ii=ii+1;  %% šeštevanje elementov izolatorja
           e(:,:,ii)=[xx_js(k+1,1);yy_js(k+1,1);zz_js(k+1,1);bx_js(k+1,1);by_js(k+1,1);bz_js(k+1,1);...
          xx_js(k+1,2);yy_js(k+1,2);zz_js(k+1,2);bx_js(k+1,2);by_js(k+1,2);bz_js(k+1,2)];
           ii=ii+1;  %% šeštevanje elementov vodnika  za izolatorjem
           
          case 2 %tipverige=2- V veriga
          e(:,:,ii)=[xx_js(k,i);yy_js(k,i);zz_js(k,i);bx_js(k,i);by_js(k,i);bz_js(k,i);...
          xx_js(k,i+1);yy_js(k,i+1);zz_js(k,i+1);bx_js(k,i+1);1;0];  % ima predpisan naklon konca elementa (ena in niè)
          ii=ii+1;  %% šeštevanje elementov vodnikapred izolatorjem
          e(:,:,ii)=[xxi_js(k,1);yyi_js(k,1);zzi_js(k,1);bxi_js(k,1);byi_js(k,1);bzi_js(k,1);...
          xxi_js(k,2);yyi_js(k,2);zzi_js(k,2);bxi_js(k,2);byi_js(k,2);bzi_js(k,2)];
          ii=ii+1;  %% šeštevanje elementov desnega izolatorja
          e(:,:,ii)=[xxi_js(k,3);yyi_js(k,3);zzi_js(k,3);bxi_js(k,3);byi_js(k,3);bzi_js(k,3);...
          xxi_js(k,4);yyi_js(k,4);zzi_js(k,4);bxi_js(k,4);byi_js(k,4);bzi_js(k,4)];
          ii=ii+1;  %% šeštevanje elementov levega izolatorja
          e(:,:,ii)=[xx_js(k+1,1);yy_js(k+1,1);zz_js(k+1,1);bx_js(k+1,1);1;0;...
          xx_js(k+1,2);yy_js(k+1,2);zz_js(k+1,2);bx_js(k+1,2);by_js(k+1,2);bz_js(k+1,2)];
           ii=ii+1;  %% šeštevanje elementov vodnika za izolatorjem 
          
            case 3 %tipverige=3- Vee veriga- isto kot 2
          e(:,:,ii)=[xx_js(k,i);yy_js(k,i);zz_js(k,i);bx_js(k,i);by_js(k,i);bz_js(k,i);...
          xx_js(k,i+1);yy_js(k,i+1);zz_js(k,i+1);bx_js(k,i+1);1;0];  % ima predpisan naklon konca elementa (ena in niè)
          ii=ii+1;  %% šeštevanje elementov vodnikapred izolatorjem
          
          e(:,:,ii)=[xxi_js(k,3);yyi_js(k,3);zzi_js(k,3);bxi_js(k,3);byi_js(k,3);bzi_js(k,3);...
          xxi_js(k,4);yyi_js(k,4);zzi_js(k,4);bxi_js(k,4);byi_js(k,4);bzi_js(k,4)];
          ii=ii+1;  %% šeštevanje elementov brace          
          
          e(:,:,ii)=[xxi_js(k,1);yyi_js(k,1);zzi_js(k,1);bxi_js(k,1);byi_js(k,1);bzi_js(k,1);...
          xxi_js(k,2);yyi_js(k,2);zzi_js(k,2);bxi_js(k,2);byi_js(k,2);bzi_js(k,2)];
          ii=ii+1;  %% šeštevanje elementov post izolatorja
         

          e(:,:,ii)=[xx_js(k+1,1);yy_js(k+1,1);zz_js(k+1,1);bx_js(k+1,1);1;0;...
          xx_js(k+1,2);yy_js(k+1,2);zz_js(k+1,2);bx_js(k+1,2);by_js(k+1,2);bz_js(k+1,2)];
           ii=ii+1;  %% šeštevanje elementov vodnika za izolatorjem 
           
           case 4 %tipverige=4- Vee veriga + steel pole
          e(:,:,ii)=[xx_js(k,i);yy_js(k,i);zz_js(k,i);bx_js(k,i);by_js(k,i);bz_js(k,i);...
          xx_js(k,i+1);yy_js(k,i+1);zz_js(k,i+1);bx_js(k,i+1);by_js(k,i+1);bz_js(k,i+1)];  % ima predpisan naklon konca elementa (ena in niè)
          ii=ii+1;  %% šeštevanje elementov vodnikapred izolatorjem
          
          e(:,:,ii)=[xxi_js(k,3);yyi_js(k,3);zzi_js(k,3);bxi_js(k,3);byi_js(k,3);bzi_js(k,3);...
          xxi_js(k,4);yyi_js(k,4);zzi_js(k,4);bxi_js(k,4);byi_js(k,4);bzi_js(k,4)];
          ii=ii+1;  %% šeštevanje elementov brace          
          
          e(:,:,ii)=[xxi_js(k,1);yyi_js(k,1);zzi_js(k,1);bxi_js(k,1);byi_js(k,1);bzi_js(k,1);...
          xxi_js(k,2);yyi_js(k,2);zzi_js(k,2);bxi_js(k,2);byi_js(k,2);bzi_js(k,2)];
          ii=ii+1;  %% šeštevanje elementov post izolatorja
         
          e(:,:,ii)=[xxi_js(k,5);yyi_js(k,5);zzi_js(k,5);bxi_js(k,5);byi_js(k,5);bzi_js(k,5);...
          xxi_js(k,6);yyi_js(k,6);zzi_js(k,6);bxi_js(k,6);byi_js(k,6);bzi_js(k,6)];
          ii=ii+1;   %% šeštevanje elementov glave stebram 

          e(:,:,ii)=[xxi_js(k,7);yyi_js(k,7);zzi_js(k,7);bxi_js(k,7);byi_js(k,7);bzi_js(k,7);...
          xxi_js(k,8);yyi_js(k,8);zzi_js(k,8);bxi_js(k,8);byi_js(k,8);bzi_js(k,8)];
          ii=ii+1;   %% šeštevanje elementov glave stebram 
          
          e(:,:,ii)=[xx_js(k+1,1);yy_js(k+1,1);zz_js(k+1,1);bx_js(k+1,1);by_js(k+1,1);bz_js(k+1,1);...
          xx_js(k+1,2);yy_js(k+1,2);zz_js(k+1,2);bx_js(k+1,2);by_js(k+1,2);bz_js(k+1,2)];
           ii=ii+1;  %% šeštevanje elementov vodnika za izolatorjem 
           
            case 5 %tipverige=5- A veriga + steel vmesnik
          e(:,:,ii)=[xx_js(k,i);yy_js(k,i);zz_js(k,i);bx_js(k,i);by_js(k,i);bz_js(k,i);...
          xx_js(k,i+1);yy_js(k,i+1)-izo.izo_A(1,5)/2;zz_js(k,i+1);bx_js(k,i+1);by_js(k,i+1);bz_js(k,i+1)];  % ima predpisan naklon konca elementa (ena in niè)
          ii=ii+1;  %% šeštevanje elementov vodnikapred izolatorjem
          
          e(:,:,ii)=[xxi_js(k,1);yyi_js(k,1);zzi_js(k,1);bxi_js(k,1);byi_js(k,1);bzi_js(k,1);...
          xxi_js(k,2);yyi_js(k,2);zzi_js(k,2);bxi_js(k,2);byi_js(k,2);bzi_js(k,2)];
          ii=ii+1;  %% šeštevanje elementov levega kraka A
          
          e(:,:,ii)=[xxi_js(k,3);yyi_js(k,3);zzi_js(k,3);bxi_js(k,3);byi_js(k,3);bzi_js(k,3);...
          xxi_js(k,4);yyi_js(k,4);zzi_js(k,4);bxi_js(k,4);byi_js(k,4);bzi_js(k,4)];
          ii=ii+1;  %% šeštevanje elementov desnega kraka A 
          
          e(:,:,ii)=[xxi_js(k,5);yyi_js(k,5);zzi_js(k,5);bxi_js(k,5);byi_js(k,5);bzi_js(k,5);...
          xxi_js(k,6);yyi_js(k,6);zzi_js(k,6);bxi_js(k,6);byi_js(k,6);bzi_js(k,6)];
          ii=ii+1;   %% šeštevanje elementov jeklenega vmesnika 

          e(:,:,ii)=[xx_js(k+1,1);yy_js(k+1,1)+izo.izo_A(1,5)/2;zz_js(k+1,1);bx_js(k+1,1);by_js(k+1,1);bz_js(k+1,1);...
          xx_js(k+1,2);yy_js(k+1,2);zz_js(k+1,2);bx_js(k+1,2);by_js(k+1,2);bz_js(k+1,2)];
           ii=ii+1;  %% šeštevanje elementov vodnika za izolatorjem 
           % za primer A odštejem še dolžino vodnika na obeh koncih, za
           % 1/2 vstavka jeklenega vmesnika
         
%            testelevo=sqrt((yy_js(k,i+1)-izo.izo_A(1,5)/2-yy_js(k,i))^2+(zz_js(k,i)-zz_js(k,i+1))^2)
%     
%            teste=sqrt((yy_js(k+1,1)+izo.izo_A(1,5)/2-yy_js(k+1,2))^2+(zz_js(k+1,1)-zz_js(k+1,2))^2)
%        
%             dodatek=.7;
%             dodatek=.7;
           le(k,i)=le(k,i)-izo.izo_A(1,5)/2;
           le(k+1,1)=le(k+1,1)-izo.izo_A(1,5)/2;
           case 6 %tipverige=6- IB veriga- isto kot 2
          e(:,:,ii)=[xx_js(k,i);yy_js(k,i);zz_js(k,i);bx_js(k,i);by_js(k,i);bz_js(k,i);...
          xx_js(k,i+1);yy_js(k,i+1);zz_js(k,i+1);bx_js(k,i+1);1;0];  % ima predpisan naklon konca elementa (ena in niè)
          ii=ii+1;  %% šeštevanje elementov vodnikapred izolatorjem
          
          e(:,:,ii)=[xxi_js(k,3);yyi_js(k,3);zzi_js(k,3);bxi_js(k,3);byi_js(k,3);bzi_js(k,3);...
          xxi_js(k,4);yyi_js(k,4);zzi_js(k,4);bxi_js(k,4);byi_js(k,4);bzi_js(k,4)];
          ii=ii+1;  %% šeštevanje elementov brace          
          
          e(:,:,ii)=[xxi_js(k,1);yyi_js(k,1);zzi_js(k,1);bxi_js(k,1);byi_js(k,1);bzi_js(k,1);...
          xxi_js(k,2);yyi_js(k,2);zzi_js(k,2);bxi_js(k,2);byi_js(k,2);bzi_js(k,2)];
          ii=ii+1;  %% šeštevanje elementov post izolatorja
         

          e(:,:,ii)=[xx_js(k+1,1);yy_js(k+1,1);zz_js(k+1,1);bx_js(k+1,1);1;0;...
          xx_js(k+1,2);yy_js(k+1,2);zz_js(k+1,2);bx_js(k+1,2);by_js(k+1,2);bz_js(k+1,2)];
           ii=ii+1;  %% šeštevanje elementov vodnika za izolatorjem 
 
          end
          
     elseif i>=2 && i==ne_c(k,1) && k== hh-1  % C. sklop vodnik steber desno
    e(:,:,ii)=[xx_js(k,i);yy_js(k,i);zz_js(k,i);bx_js(k,i);by_js(k,i);bz_js(k,i);...
        xx_js(k,i+1);yy_js(k,i+1);zz_js(k,i+1);bx_js(k,i+1);by_js(k,i+1);bz_js(k,i+1)];
    ii=ii+1;  %% šeštevanje elementov vodnika
     end
% ii=ii+1;  %% šeštevanje elementov vodnika
 end
end


% tvorjenje navpiènega vektorja 

e_zp=e(:,:,1);  %ANCF zaèetni pogoji
%display(e_zp)
for i=2:ii-1
  e_zp = [e_zp; e(:,:,i)];  % v enem stolpcu
end
%   display(size(e_zp))
% pretvorba v sparse obliko
e_zp=sparse(e_zp);
% display(e_zp)
% st

%tvorjenja vektorja zaæetnih pogojev za dinamièno simulacijo koordinata + zaèetna hitrost (enaka O)
[sv ss]=size(e_zp);  %tvorjenje prazne matrike -dvojna velikost
e_zp_s=zeros(2*sv,1);
sv=1:sv;   %tvorim indeks  števila koordinat
e_zp_s(2*sv-1,1)=e_zp;  %zaèetni pogoji zapisani v vsako drugo vrstico)
% display(e_zp_s)
% display(size(e_zp_s))
% stop

ne_i=1;  %definiram da je število elementov izolatorja vedno 1

%Opredelitev zunanjega premera elemntov vodnika (izolatorji imajo svojo opredelitev)
Dcc=external_D_obloge(hh,ne_c,d_c,db);
% display(Dcc)
% stop
%%%**************************************************************************
%% zapis rezultatov v izhodno datoteko

%display(ime_datoteke1);
%ime_datoteke2=strcat('segmentacija_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice
ime_datoteke2=strcat('ySTAT_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice
save(ime_datoteke2, 'ime_datoteke1','hh','ne_c','m_c','d_c','db1_c','le','db','yy_js','zz_js',...
    'ne_i','izo','E_c','A_c','tipverige','e_zp','e_zp_s','DK','Dcc');  %shranjevanje variabel v to datoteko
%display(ime_datoteke2);
display('End of line segmentation');
clear all


%% za doloèitev Lo in V
 function F=enacbi(x,H,EA,m,g,ak,hk)
      %  Lo=x(1)
      %  V=x(2)
            F=[(H*x(1)/EA)+(H/(m*g))*((asinh(x(2)/H))-(asinh((x(2)-m*g*x(1))/H)))-ak;
            (m*g*x(1)*x(1)/EA)*(x(2)/(m*g*x(1))-1/2)+(H/(m*g))*(sqrt(1+(x(2)/H)^2)-sqrt(1+((x(2)-(m*g*x(1)))/H)^2))-hk];
 end

    function [x y bx by]=tocke(S,H,V,Lo,EA,m,g)  %velja za vodnik
                x=(H*S/EA)+(H/(m*g))*((asinh(V/H))-(asinh((V-m*g*S)/H)));
                y=(m*g*Lo*S/EA)*(V/(m*g*Lo)-S/(2*Lo))+(H/(m*g))*(sqrt(1+(V/H)^2)-sqrt(1+((V-(m*g*S))/H)^2));
                bx=(H/EA)+1/sqrt(1+((V-(m*g*S))/H)^2);
                by=-((V/EA)-(m*g*S/EA)+((V-(m*g*S))/H)/sqrt(1+((V-(m*g*S))/H)^2));  %zaradi koordinatnega sistema
               
    end
end
