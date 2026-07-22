       function [X1,insX1,insX1dA,spX1,insX1levi,insX1desni]=indeksiKoordinat(tipverige,hh,ne_c,tip_K_F)
       % funkcija ki opredeli indekse koordinat/sil v izhodnih datotekah
       % za risanje grafov 

s=round(ne_c/2); % iskanje sredine po posameznih razpetinah 
%izpiše koordianate izolatorjev/ sredin razpezin za izrise grafov 
% tip_K_F lahko je 12 (za koordinate) ali 3 (za sile)
insX1dA=[]; %samo definicija za primer èe nimam A verige
qI=(ne_c(1,1)+1)*tip_K_F;   %število koordinat vodnika v razpetini plus I veriga
qV=(ne_c(1,1)+2)*tip_K_F;   %število koodinat vodnika v razpetini plus V veriga ali bracepost ali IB
qA=(ne_c(1,1)+3)*tip_K_F;   %število koodinat vodnika v razpetini plus A veriga 
qSP=(ne_c(1,1)+4)*tip_K_F;   %število koordinat vodnika v razpetini steel pole

% sledi še zapis iskanja koordinat za izolatorje
X1=s(1)*tip_K_F+1; % prvi koordinata je vedno enaka sredini prve razpetine

%preddefinicije parznih matrik in indeksov
predhodni_span=0; predhodni=0;
insX1=[];insX1levi=[];insX1desni=[]; spX1=[];

for i=1:(hh-1)-1  % štejem število razpetin manj ena (toliko je izolatorjev)
   if tipverige(i+1)==1  % za I verigo
    % za vodnik   
    predhodni_span=predhodni_span+qI; 
    X1=[X1; s(i+1)*tip_K_F+1+predhodni_span];  % velja za sredino razpetine
    % za izolatorje
    predhodni=predhodni+qI;
    insX1=[insX1; predhodni-11]; %velja za koordinato verige
    insX1levi=[insX1levi;1]; % dodam 1 da umetno ujamm indeks a verige
    insX1desni=[insX1desni;1]; % dodam 1 da umetno ujamm indeks a verige
   elseif (tipverige(i+1)==2||tipverige(i+1)==3||tipverige(i+1)==6);  %za V verigo ali bracepost
    % za vodnik   
    predhodni_span=predhodni_span+qV; 
    X1=[X1; s(i+1)*tip_K_F+1+predhodni_span];  % velja za sredino razpetine
   % novi=qV;
    predhodni=predhodni+qV;
    insX1=[insX1; predhodni-11]; %velja za koordinato verige
    
    %insX1=[insX1;(i)*qV-6+1]; %velja za koordinato verige
    insX1levi=[insX1levi;1;1]; % dodam 1 da umetno ujamm indeks a verige
    insX1desni=[insX1desni;1;1]; % dodam 1 da umetno ujamm indeks a verige
   elseif tipverige(i+1)==4;  %za Brace + steel pole 
    % za vodnik   
    predhodni_span=predhodni_span+qSP; 
    X1=[X1; s(i+1)*tip_K_F+1+predhodni_span];  % velja za sredino razpetine
   insX1=[insX1;(i)*qV-12+1]; %velja za koordinato verige
   insX1levi=[insX1levi;1;1]; % dodam 1 da umetno ujamm indeks a verige
   insX1desni=[insX1desni;1;]; % dodam 1 da umetno ujamm indeks a verige
   % insX1=[insX1;(i-1)*qSP-48+1]; %velja za koordinato verige
% spX1=[insX1;(i-1)*qSP-48+7]; %velja za koordinato konice st.pola
   elseif tipverige(i+1)==5;  %za A verigo v obesiscu
    % za vodnik   
    predhodni_span=predhodni_span+qA; 
    X1=[X1; s(i+1)*tip_K_F+1+predhodni_span];  % velja za sredino razpetine
  
   %display(predhodni)
     %novi=qA-6;
     predhodni=predhodni+qA; % inseks
    
     insX1=[insX1; predhodni-11]; % za desno obesišce vodnika v sestav A
     
     insX1levi=[insX1levi;predhodni-8]; %velja za levi element verige / za sile
     %novi=3;
     predhodni=predhodni+3;
     insX1desni=[insX1desni;predhodni-8]; %velja za desni element verige
%    else tipverige(i+1)==6;  %za  IB
% za vodnik   
%     predhodni_span=predhodni_span+qV; 
%     X1=[X1; s(i+1)*tip_K_F+1+predhodni_span];  % velja za sredino razpetine
%    % novi=qV;
%     predhodni=predhodni+qV;
%     insX1=[insX1; predhodni-5]; %velja za koordinato verige
%     
%     %insX1=[insX1;(i)*qV-6+1]; %velja za koordinato verige
%     insX1desni=[insX1desni;predhodni-5]; % dodam 1 da umetno ujamm indeks a verige
%    % predhodni=predhodni+3;
%     % pazi v vhodnih podatkih je desni pred levim zato tzamenjana indeksa
%     % pri A to ni važno ker imam skupno obesišèe
%     insX1levi=[insX1levi;predhodni-2]; % dodam 1 da umetno ujamm indeks a verige
%     display('test')
    end
end

%  pause 
%stop
     %  end