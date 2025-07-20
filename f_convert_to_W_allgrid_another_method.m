function [PW,CF_W]=f_convert_to_W_allgrid_another_method(Vheight,IdTime,Theight)

PW=zeros(size(Vheight,1),length(IdTime));
CF_W=zeros(size(Vheight,1),1);

for ii=1:size(Vheight,1)
    mean_wind_speed=mean(Vheight(ii,:));
    if mean_wind_speed<5.5 %GW150–3.0;
        vci=2.5;vr=9;vco=18;
    end
    if (mean_wind_speed>=5.5 && mean_wind_speed<7.5) %GW165–4.0
        vci=2.5;vr=9.7;vco=24;
    end
     if (mean_wind_speed>=7.5 && mean_wind_speed<9.2) %GW155–4.5
        vci=2.5;vr=10.8;vco=26;
     end
    if (mean_wind_speed>=9.2)%GW136–4.2
        vci=2.5;vr=11.2;vco=26;
    end
    [PW(ii,:),CF_W(ii)]=getWoutputV3(vci,vr,vco,Vheight(ii,:),Theight(ii,:));
end
PW=single(PW);