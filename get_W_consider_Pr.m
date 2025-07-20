function [PWnew]=get_W_consider_Pr(height,huss,T2m,ws,pr,qiebian0,yita_sys)
% wind hub height, specific humidity, temperature, wind speed, pressure,
% shear exponent, system efficiency
length_data=size(huss,2);

v_meas_h=zeros(size(ws));
for i=1:size(ws,1)
    v_meas_h(i,:)=ws(i,:)*((height/10)^qiebian0(i));
end
clear ws
L=0.0065;
g = 9.80665;        %  (m/s^2)
Rd = 287.05;        %  (J/(kg·K))
Rvapour=461.5;

p_meas_h=pr.*(1-L*height./(T2m+273.15)).^(g./(Rd*L));
clear pr
p_vapour=huss.*p_meas_h./(0.622+0.378*huss);
clear huss
rho_meas_h=(p_meas_h-p_vapour)./(Rd*(T2m+273.15-height*L))+...
    p_vapour./(Rvapour*(T2m+273.15-height*L));
clear p_meas_h p_vapour
v_std_h=v_meas_h.*(rho_meas_h/1.225).^(1/3);

clear rho_meas_h

% mean(mean(v_std_h))
% mean(mean(v_meas_h))

clear v_meas_h

[PWnew]=f_convert_to_W_allgrid_another_method(v_std_h,1:length_data,T2m-height*L);
PWnew=yita_sys*PWnew;


