function [pdotdot, lambda ]=pdotdot_lagrange(m,qe_g,qkqt,qv,qc,ce)
%funkcija ki izraèuna vse pospeške koordinat in lagrangeove koeficiente
% izraèuna s shabana, computational dynamics, 6.145 enaèbe
ic=numel(qc); %preštejem število omejitev
o=zeros(ic,ic);

a=[m ce.';ce o]\[(qe_g-qkqt);qc];
i=numel(a);
pdotdot=a(1:i-ic,1);
lambda=a((i-ic)+1:i,1);

%qv zaenkrat še ni upoštevan v enaèbi
%prav tako drugi del enaèbestr 251 shabana, knjiga

end
 