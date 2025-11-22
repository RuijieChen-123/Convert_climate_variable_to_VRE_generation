function [PWnew]=get_W_consider_PrV2(height,huss,T2m,ws,pr,yita_sys,start_time,end_time,alpha_month_hour)
% wind hub height, specific humidity, temperature, wind speed, pressure,
% shear exponent, system efficiency
length_data=size(huss,2);
%%%%%%%%%%%%%%%%%%%%%%%风速转换，旧版%%%%%%%%%%%%%%%%%%%%%%%%%5
% v_meas_h=zeros(size(ws));
% for i=1:size(ws,1)
%     v_meas_h(i,:)=ws(i,:)*((height/10)^alpha(i));
% end
%%%%%%%%%%%%%%%%%%风速转换，新版%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% t_start = datetime(2015,1,2,0,0,0);
% t_end   = datetime(2019,12,31,23,0,0);
[nGrid, N] = size(ws);
time = (start_time:hours(1):end_time)';

if length(time) ~= N
    error('时间长度与风速数据列数不一致');
end

% 提取每个时刻的月份和小时
month_id = month(time);     % 1–12
hour_id  = hour(time) + 1;  % 转为1–24索引
clear time
% 为每个时刻生成对应的alpha矩阵（nGrid × N）
alpha_dynamic = zeros(nGrid, N, 'like', ws);
for m = 1:12
    for h = 1:24
        idx = (month_id == m) & (hour_id == h);
        if any(idx)
            % 将对应月份-小时的alpha广播到所有空间点
            alpha_dynamic(:, idx) = repmat(alpha_month_hour(:, m, h), 1, sum(idx));
        end
    end
end
clear month_id hour_id
% --- 高度变换 ---
v_meas_h = ws .* ((height / 10) .^ alpha_dynamic);
clear ws alpha_dynamic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
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
% size(v_std_h)
% length_data
% class(v_std_h)
% size(T2m-height*L)
[PWnew]=f_convert_to_W_allgrid_another_method(v_std_h,1:length_data,T2m-height*L);
PWnew=yita_sys*PWnew;


