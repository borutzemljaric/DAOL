function [Flevo Fdesno ]=sileMomenti(Qc)
%% izraèun notranjih sil v vozlišèih v 3D
nc=numel(Qc);  %število generaliziranih sil
I=eye(3:3);
O=zeros(3);
%za element A
Sk1=[O O I O];  % velja za r v toèki b telesa A -ksi je enak ena
Sk2=[I O O O]; % velja za r v toèki a telesa A- ksi je enak 0

% Sl = repmat(Sk2,1,sCe/12)
% Sd = repmat(Sk1,1,sCe/12);

% prvi trije izven zanke
ii=1;
Qc_element=Qc(((ii-1)*12+1):((ii-1)*12+12),:); %vpis  koordinat za predmetni element, samo od-do po 8 koordinat
Flevo=Sk2.'\Qc_element;  % ima dimenzije n x število zapsov èasa (vt)
Fdesno=Sk1.'\Qc_element;  % ima dimenzije n x število zapsov èasa (vt)

for ii=2:nc/12
 Qc_element=Qc(((ii-1)*12+1):((ii-1)*12+12),:); %vpis  koordinat za predmetni element, samo od-do po 8 koordinat
Flevo_n=Sk2.'\Qc_element;  % ima dimenzije n x število zapsov èasa (vt)
Flevo=[Flevo;Flevo_n];
Fdesno_n=Sk1.'\Qc_element;  % ima dimenzije n/12 (število elementov!!) x število zapisov èasa (vt)
Fdesno=[Fdesno;Fdesno_n];

end
%kot rezultat dobim sile v levem in desnem jointu
%display(size(Fdesno))
end