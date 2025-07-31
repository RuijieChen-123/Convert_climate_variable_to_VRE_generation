%% read WFDE5 data
clear all
CH_lat=[17.25,52.75];
CH_lon=[73.25,135.75];
NameVariable={'Qair','SWdown','Tair','Wind'};
Nvar=length(NameVariable);

data_ref_h=cell(Nvar,1);
for iv=1:Nvar
    data_ref_h{iv}=[];
end
for iy=1:41 %41year
    data_thisyear=cell(Nvar,1);
    for iv=1:Nvar
        data_thisyear{iv}=[];
        for im=1:12
            if (im<10)
                NameMonth=['0',num2str(im)];
            else
                NameMonth=num2str(im);
            end
            filename=['F:\WFDE5\',num2str(1978+iy),'\',NameVariable{iv},'_WFDE5_CRU_',num2str(1978+iy),NameMonth,'_v2.1.nc'];
            ncdisp(filename)
            ref_data=ncread(filename,NameVariable{iv});
            ref_data_lon=ncread(filename,'lon');
            ref_data_lat=ncread(filename,'lat');
            ref_data_time=ncread(filename,'time');
    
            CH_lat_id1=find(CH_lat(1)==ref_data_lat);
            CH_lat_id2=find(CH_lat(2)==ref_data_lat);
            CH_lon_id1=find(CH_lon(1)==ref_data_lon);
            CH_lon_id2=find(CH_lon(2)==ref_data_lon);
            
            ref_data_lat([CH_lat_id1,CH_lat_id2])
            ref_data_lon([CH_lon_id1,CH_lon_id2])
            ref_data=ref_data(CH_lon_id1:CH_lon_id2,CH_lat_id1:CH_lat_id2,:);%lon:73-136,lat:17-53,time
            data_thisyear{iv}=cat(3,data_thisyear{iv},ref_data);


            data_thisyear{iv}=single(data_thisyear{iv});


            clear ref_data
        end
    end
    for iv=1:Nvar
        data_ref_h{iv}=cat(3,data_ref_h{iv},data_thisyear{iv});
    end
    clear data_thisyear
end

Nlon=size(data_ref_h{1},1);
Nlat=size(data_ref_h{1},2);
Ntotal_hour0=size(data_ref_h{1},3);
% UTC+0 to UTC+8
data_ref_h{1}=data_ref_h{1}(:,:,17:Ntotal_hour0-8);%1990.1.2
data_ref_h{2}=data_ref_h{2}(:,:,10:Ntotal_hour0-15);
data_ref_h{3}=data_ref_h{3}(:,:,17:Ntotal_hour0-8)-273.15;
data_ref_h{4}=data_ref_h{4}(:,:,17:Ntotal_hour0-8);
%

%%%%%%%%%%%%%% Mat_noNAN: spatial grid cells in China
load idWST_and_Mat.mat Mat_noNAN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% input data 3D to 2D %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_ref_hV2=cell(Nvar,1);
data_ref_dV2=cell(Nvar,1);
for iv=1:Nvar
    data_ref_hV2{iv}=zeros(size(Mat_noNAN,1),size(data_ref_h{iv},3));
    data_ref_dV2{iv}=zeros(size(Mat_noNAN,1),size(data_ref_h{iv},3)/24);
    for ii=1:size(Mat_noNAN,1)
        IIlon=Mat_noNAN(ii,1);
        IIlat=Mat_noNAN(ii,2);

        data_ref_hV2{iv}(ii,:)=squeeze(data_ref_h{iv}(IIlon,IIlat,:));
        data_ref_dV2{iv}(ii,:)=mean(reshape(data_ref_hV2{iv}(ii,:), 24, length(data_ref_hV2{iv}(ii,:))/24), 1);
    end
    data_ref_h{iv}=0;
end
clear data_ref_h

for iv=1:Nvar
    data_ref_hV2{iv}=single(data_ref_hV2{iv});
end

for iv=1:Nvar
    data_ref_dV2{iv}=single(data_ref_dV2{iv});
end

%% 
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
