function H_M_matrike(ime_datoteke1)%(m_c,L)
%Branje datoteke s podatki segmentacije
% [ime_datoteke1, pathname] = ...
%      uigetfile({'*.mat','*.*'},'File Selector');  %vneseš datoteko z vhodnimi podatki _lahko rezultat M

ime_datoteke2=strcat('ySTAT_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice 
load(ime_datoteke2, 'ime_datoteke1','hh','ne_c','m_c','le','ne_i','izo','tipverige');  %branje variabel 
%ime_datoteke=strcat('Ce_active_',ime_datoteke1,'.mat');
load(ime_datoteke2,'ime_datoteke1','Ce_active','Ce_1_active','konstante','neod_fix');

%izraèun masne matrike elementov

ii=1;
for k=1:hh-1
 for i=1:ne_c(k,1)
     
     if k~=hh-1&&i==ne_c(k,1)  %velja za element vodnik_izolator
    % display(le(k,i))
      M_elementa(:,:,ii)=M_element(m_c,le(k,i));
      ii=ii+1;  %% šeštevanje elementov vodnika
 
      for j=1:ne_i %izraèun masne matrike elementa izolatorja
      % display(le(k,i))
          switch tipverige(k+1,1)
          case 0
          case 1
       M_elementa(:,:,ii)=M_element(izo.izo_i(1,2),izo.izo_i(1,1));
    
         ii=ii+1;  %% šeštevanje elementov izolatorja
         case 2
       M_elementa(:,:,ii)=M_element(izo.izo_V(1,2),izo.izo_V(1,1));
         ii=ii+1;  %% šeštevanje elementov izolatorja
       M_elementa(:,:,ii)=M_element(izo.izo_V(1,2),izo.izo_V(1,1));
       ii=ii+1;  %% šeštevanje elementov izolatorja
       case 3
       M_elementa(:,:,ii)=M_element(izo.izo_B(1,2),izo.izo_B(1,1));
         ii=ii+1;  %% šeštevanje elementov izolatorja
       M_elementa(:,:,ii)=M_element(izo.izo_P(1,2),izo.izo_P(1,1));
       ii=ii+1;  %% šeštevanje elementov izolatorja
        case 4
       M_elementa(:,:,ii)=M_element(izo.izo_B(1,2),izo.izo_B(1,1));
         ii=ii+1;  %% šeštevanje elementov izolatorja
       M_elementa(:,:,ii)=M_element(izo.izo_P(1,2),izo.izo_P(1,1));
       ii=ii+1;  %% šeštevanje elementov izolatorja
       M_elementa(:,:,ii)=M_element(izo.st_pole(1,2),izo.izo_glava);
         ii=ii+1;  %% šeštevanje elementov izolatorja
       M_elementa(:,:,ii)=M_element(izo.st_pole(1,2),izo.st_pole(1,1));
       ii=ii+1;  %% šeštevanje elementov izolatorja
       case 5
       M_elementa(:,:,ii)=M_element(izo.izo_A(1,2),izo.izo_A(1,1));
         ii=ii+1;  %% šeštevanje elementov izolatorja
       M_elementa(:,:,ii)=M_element(izo.izo_A(1,2),izo.izo_A(1,1));
       ii=ii+1;  %% šeštevanje elementov izolatorja
       M_elementa(:,:,ii)=M_element(izo.izo_A(1,6),izo.izo_A(1,5));
         ii=ii+1;  %% šeštevanje elementov izolatorja
          case 6
       M_elementa(:,:,ii)=M_element(izo.izo_IB(1,2),izo.izo_IB(1,1));
         ii=ii+1;  %% šeštevanje elementov izolatorja
       M_elementa(:,:,ii)=M_element(izo.izo_IP(1,2),izo.izo_IP(1,1));
       ii=ii+1;  %% šeštevanje elementov izolatorja
       
         end
      end
      
      else %velja za element vodnik
      M_elementa(:,:,ii)=M_element(m_c,le(k,i));
      ii=ii+1;  %% šeštevanje elementov vodnika
    end
 end
 
end

%display(ii)
%display(l_0)
% tvorjenje diagonalne matrike 
M=M_elementa(:,:,1);

for i=2:ii-1
  M = blkdiag(M,M_elementa(:,:,i));
end

% pretvorba v sparse obliko
%display(M)
M=sparse(M);
Minv=inv(M);

H_ll=inv(Ce_active*Minv*Ce_1_active);
H_ee=Minv-(Minv*Ce_1_active*H_ll*Ce_active*Minv);
H_el=Minv*Ce_1_active*H_ll;
H_le=H_el.';



% H_ll=inv((Ce_active/M)*Ce_1_active);
% H_ee=M\(1+Ce_1_active\((Ce_active/M)*Ce_1_active)*Ce_active/M);
% H_el=-(M\Ce_1_active)\((Ce_active/M)*Ce_1_active);
% H_le=H_el.';

% display(M)
% display(H_ll)


%% shranjevanje izraèuna v datoteko
ime_datoteke2=strcat('ySTAT_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice
save(ime_datoteke2, 'ime_datoteke1','H_ll','H_ee','H_el','H_le','M','-append');  %shranjevanje variabel v to datoteko
%display(ime_datoteke2);
display('End of Prepare mass matrix and H matrices');



end
 