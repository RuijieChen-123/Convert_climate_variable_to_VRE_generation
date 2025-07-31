%% read WFDE5 pressure data
load Mat_noNAN
CH_lat=[17.25,52.75];
CH_lon=[73.25,135.75];
DataPressure=[];
for iy=1:41 
    data_thisyear=[];
    for im=1:12
        if (im<10)
            NameMonth=['0',num2str(im)];
        else
            NameMonth=num2str(im);
        end
        filename=['F:\WFDE5\pressure\PSurf_WFDE5_CRU_',num2str(1978+iy),NameMonth,'_v2.1.nc'];
        ncdisp(filename)
        ref_data=ncread(filename,'PSurf');
        ref_data_lon=ncread(filename,'lon');
        ref_data_lat=ncread(filename,'lat');
        ref_data_time=ncread(filename,'time');

        CH_lat_id1=find(CH_lat(1)==ref_data_lat);
        CH_lat_id2=find(CH_lat(2)==ref_data_lat);
        CH_lon_id1=find(CH_lon(1)==ref_data_lon);
        CH_lon_id2=find(CH_lon(2)==ref_data_lon);
        
        ref_data_lat([CH_lat_id1,CH_lat_id2])
        ref_data_lon([CH_lon_id1,CH_lon_id2])
        ref_data=ref_data(CH_lon_id1:CH_lon_id2,CH_lat_id1:CH_lat_id2,:);%73-136,17-53,time
        data_thisyear=cat(3,data_thisyear,ref_data);

        data_thisyear=single(data_thisyear);
        clear ref_data
    end

    DataPressure=cat(3,DataPressure,data_thisyear);
    clear data_thisyear
end

Ntotal_hour0=size(DataPressure,3);
DataPressure2=DataPressure(:,:,17:Ntotal_hour0-8);%1990.1.2

clear DataPressure

Pressure=zeros(3848,359376);
for ii=1:size(Mat_noNAN,1)
    IIlon=Mat_noNAN(ii,1);
    IIlat=Mat_noNAN(ii,2);
    Pressure(ii,:)=squeeze(DataPressure2(IIlon,IIlat,:));
end

clear DataPressure2
%% data_ref_h/d
NameVariable={'Qair','SWdown','Tair','Wind','Pr'};
Nvar=length(NameVariable);
load down_future.mat data_ref_hV2 data_ref_dV2
data_ref_hV2{5}=Pressure;
data_ref_dV2{5}=squeeze(mean(reshape(Pressure, 3848, 24, []), 2));

for iv=1:Nvar
    data_ref_hV2{iv}=single(data_ref_hV2{iv});
    data_ref_dV2{iv}=single(data_ref_dV2{iv});
end

%% train/test data
TrainData=cell(Nvar,1);
TestData=cell(Nvar,1);
for iv=1:Nvar
    TrainData{iv}=data_ref_dV2{iv}(:,1:365*28);
    TestData{iv}=data_ref_dV2{iv}(:,365*28+1:end);
end
clear data_ref_dV2
data_ref_h_Train=cell(Nvar,1);
data_ref_h_Test=cell(Nvar,1);
for iv=1:Nvar
    data_ref_h_Train{iv}=data_ref_hV2{iv}(:,1:365*28*24);
    data_ref_h_Test{iv}=data_ref_hV2{iv}(:,365*28*24+1:end);
    data_ref_hV2{iv}=0;
end
clear data_ref_hV2
