%%
load('C:\code operation\downscale\Simulate_VRE_Capa_save.mat','Mat_noNAN');
NameVariable={'huss','rsds','tas','sfcwind','ps'};
NameTimeWindow={'2021_2030','2031_2040','2041_2050','2051_2060'};
NameModel='ukesm1-0-ll';
NameSSP={'ssp126','ssp370','ssp585'};
%%

mean_record=zeros(3,4,5);
error_record=zeros(3,4,5);
error_record_lon=zeros(3,4,5);
error_record_lat=zeros(3,4,5);
for is=1:3
    for iy=1:4
        tic
        clear data_hourly
        filename_save=['F:\ISIMIP_downscale\',NameModel,'_',NameSSP{is},'_','Hourly_',NameTimeWindow{iy},'.mat'];
        load(filename_save);
        for iv=1:5
            clear A
            A=data_hourly{iv};

            lon = Mat_noNAN(:,3);
            lat = Mat_noNAN(:,4);
            n_location = size(A,1);
            n_time = size(A,2);
            
            % start：UTC+8 
            if (iy==1)
                start_time = datetime(2021,1,1,0,0,0,'TimeZone','Asia/Shanghai');
            end
            if (iy==2)
                start_time = datetime(2031,1,1,0,0,0,'TimeZone','Asia/Shanghai');
            end
            if (iy==3)
                start_time = datetime(2041,1,1,0,0,0,'TimeZone','Asia/Shanghai');
            end
            if (iy==4)
                start_time = datetime(2051,1,1,0,0,0,'TimeZone','Asia/Shanghai');
            end
            
            
            % buid time vector
            
            time_vec = hours(0:n_time-1);  
            time_units = 'hours UTC+08';
            
            %  NetCDF
            filename = ['D:\ISIMIP_downscale_nc\',NameModel,'_',NameSSP{is},'_',NameVariable{iv},'_',NameTimeWindow{iy},'.nc'];
            
            % build variable
            nccreate(filename, NameVariable{iv}, ...
                'Dimensions', {'location', n_location, 'time', n_time}, ...
                'Datatype', 'single', 'DeflateLevel', 5);
            
            nccreate(filename, 'lon', ...
                'Dimensions', {'location', n_location}, ...
                'Datatype', 'double');
            
            nccreate(filename, 'lat', ...
                'Dimensions', {'location', n_location}, ...
                'Datatype', 'double');
            
            nccreate(filename, 'time', ...
                'Dimensions', {'time', n_time}, ...
                'Datatype', 'double');
            
            % write data
            ncwrite(filename, NameVariable{iv}, A);
            ncwrite(filename, 'lon', lon);
            ncwrite(filename, 'lat', lat);
            ncwrite(filename, 'time', hours(time_vec));
            
            
            switch iv
                case 1
                    % specific humidity
                    stdname = 'specific_humidity';
                    longname = 'Specific humidity';
                    units = 'kg kg-1';
                case 2
                    % rsds
                    stdname = 'surface_downwelling_shortwave_flux_in_air';
                    longname = 'Surface downwelling shortwave radiation';
                    units = 'W m-2';
                case 3
                    % temperature
                    stdname = 'air_temperature';
                    longname = '2-meter air temperature';
                    units = 'degree_Celsius';
                case 4
                    % wind speed
                    stdname = 'wind_speed';
                    longname = '10-meter wind speed';
                    units = 'm s-1';
                case 5
                    % pressure
                    stdname = 'air_pressure';
                    longname = 'Surface air pressure';
                    units = 'Pa';
            end
            
            varname=NameVariable{iv};
            
            ncwriteatt(filename, varname, 'standard_name', stdname);
            ncwriteatt(filename, varname, 'long_name', longname);
            ncwriteatt(filename, varname, 'units', units);
            ncwriteatt(filename, varname, 'missing_value', single(NaN));
            
            ncwriteatt(filename, 'lon', 'units', 'degrees_east');
            ncwriteatt(filename, 'lat', 'units', 'degrees_north');
            
            ncwriteatt(filename, 'time', 'units', time_units);
            ncwriteatt(filename, 'time', 'calendar', 'standard');
            
            ncdisp(filename)
            
            data=ncread(filename,varname);
            data_lon=ncread(filename,'lon');
            data_lat=ncread(filename,'lat');
                  

            error_record(is,iy,iv)=sum(sum(abs(data-A)));
            mean_record(is,iy,iv)=mean(mean(data));
            error_record_lon=sum(sum(abs(data_lon-lon)));
            error_record_lat=sum(sum(abs(data_lat-lat)));
            clear data data_lon data_lat
        end
        toc
    end
end
