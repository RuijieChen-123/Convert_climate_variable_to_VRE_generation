function [Pac_ac0]=get_PV_dc2ac(T2m,SR,ws,yita_sys)
% temperature, solar radiation, wind speed, system efficiency
Tcell=4.3+0.943*T2m+0.028*SR-1.528*ws;
%PR=1-0.005*(Tcell-25);
Pdc_dc0=(1-0.005*(Tcell-25)).*SR/1000*yita_sys;

Pac_ac0=1/0.9637*(-0.0162*Pdc_dc0.^2+0.9858*Pdc_dc0-0.0059);

Pac_ac0(Pac_ac0>1)=1;
Pac_ac0(Pac_ac0<0)=0;

Pac_ac0=single(Pac_ac0);





