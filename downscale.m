%% pre-process ISIMIP data
load Mat_noNAN;
CH_lat=[17.25,52.75];
CH_lon=[73.25,135.75];
NameVariable={'huss','rsds','tas','sfcwind','ps'};
NameTimeWindow={'2021_2030','2031_2040','2041_2050','2051_2060'};
NameModel='ukesm1-0-ll';
NameSSP='ssp126';

Nvar=length(NameVariable);
NyearSet=length(NameTimeWindow);

data_all=cell(Nvar,1);
for iv=1:Nvar
    data_all{iv}=[];
    for iy=1:NyearSet
        filename=['F:\ISIMIP\',NameModel,'_',NameSSP,'\',NameModel,'_r1i1p1f2_w5e5_',NameSSP,'_',...
            NameVariable{iv},'_lat17.0to53.0lon73.0to136.0_daily_',NameTimeWindow{iy},'.nc'];
        ncdisp(filename)
        ref_data=ncread(filename,NameVariable{iv});
        ref_data=flip(ref_data,2);
        ref_data_lon=ncread(filename,'lon');
        ref_data_lat=ncread(filename,'lat');
        ref_data_lat=flipud(ref_data_lat);
        ref_data_time=ncread(filename,'time');

        CH_lat_id1=find(CH_lat(1)==ref_data_lat);
        CH_lat_id2=find(CH_lat(2)==ref_data_lat);
        CH_lon_id1=find(CH_lon(1)==ref_data_lon);
        CH_lon_id2=find(CH_lon(2)==ref_data_lon);
        
        ref_data=ref_data(CH_lon_id1:CH_lon_id2,CH_lat_id1:CH_lat_id2,:);%73-136,17-53,time
        data_all{iv}=cat(3,data_all{iv},ref_data);
    end
end
data_all{3}=data_all{3}-273.15;
clear ref_data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3D to 2D %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_future=cell(Nvar,1);
for iv=1:Nvar
    for ii=1:size(Mat_noNAN,1)
        IIlon=Mat_noNAN(ii,1);
        IIlat=Mat_noNAN(ii,2);

        data_future{iv}(ii,:)=squeeze(data_all{iv}(IIlon,IIlat,:));
    end
    data_all{iv}=0;
end
clear data_all

CV_future=cell(Nvar,1);
CV_history=cell(Nvar,1);
for iv=1:Nvar
    figure(iv)
    for i=1:size(Mat_noNAN,1)
        Ilon=Mat_noNAN(i,3);
        Ilat=Mat_noNAN(i,4);
        subplot(1,2,1)
        scatter(Ilon,Ilat,10,mean(data_future{iv}(i,:)));hold on
        subtitle('future')
        colorbar
        subplot(1,2,2)
        scatter(Ilon,Ilat,10,mean(data_ref_dV2{iv}(i,:)));hold on
        subtitle('history')
        colorbar
        CV_future{iv}(i)=mean(data_future{iv}(i,:));
        CV_history{iv}(i)=mean(data_ref_dV2{iv}(i,:));
    end

end

StartEndDay=[1,3652;3653 7305;7306 10957;10958 14610;14611 18262];
%% downscale
load data_ref.mat;
Nremain=10;%no use
Nday_similar=12;

tic
for iy=1:NyearSet
    data_hourly=cell(Nvar,1);
    for Iday=StartEndDay(iy,1):StartEndDay(iy,2)
        [down_analog_extend]=analog_extend(Nday_similar,Nremain,Iday,data_ref_dV2,data_future,Nvar,Mat_noNAN,data_ref_hV2);
        for iv=1:Nvar
            Iday2=Iday-StartEndDay(iy,1)+1;
            data_hourly{iv}(:,(Iday2-1)*24+1:Iday2*24)=single(down_analog_extend{iv});
        end
    end

    filename_save=['D:\ISIMIP_downscale\',NameModel,'_',NameSSP,'_','Hourly_',NameTimeWindow{iy},'.mat'];
    save(filename_save,'data_hourly');
end
toc
