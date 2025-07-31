load('D:\降尺度5变量数据存储\data_ref_single.mat','data_ref_hV2');
load('grid_cell_info_save.mat','qiebian0');
load('grid_cell_info_save.mat','Mat_noNAN');
lon_lat_of_VRE_output=Mat_noNAN(:,3:4);
height=100;

[CF_Wind]=get_W_consider_Pr(height,data_ref_hV2{1},data_ref_hV2{3},data_ref_hV2{4},data_ref_hV2{5},qiebian0,0.855);

[CF_PV]=get_PV_dc2ac(data_ref_hV2{3},data_ref_hV2{2},data_ref_hV2{4},0.86);

save('F:\VREoutput\VRE_1979_2019.mat','CF_Wind','CF_PV','lon_lat_of_VRE_output');
%% convert to VRE
load('grid_cell_info_save.mat','qiebian0');
load('grid_cell_info_save.mat','Mat_noNAN');
lon_lat_of_VRE_output=Mat_noNAN(:,3:4);
height=100;

NameTimeWindow={'2021_2030','2031_2040','2041_2050','2051_2060'};
NameModel={'gfdl-esm4','ipsl-cm6a-lr','mpi-esm1-2-hr','mri-esm2-0','ukesm1-0-ll'};
NameSSP={'ssp126','ssp370','ssp585'};
for im=1:5
    for is=1:3
        data_h=cell(5,1);
        for iv=1:5
            data_h{iv}=[];
        end
        for iy=1:4
            filename_save=['F:\ISIMIP_downscale\',NameModel{im},'_',NameSSP{is},'_','Hourly_',NameTimeWindow{iy},'.mat'];
            load(filename_save);
            for iv=1:5
                data_h{iv}=[data_h{iv},data_hourly{iv}];
            end
        end
        clear data_hourly
        [CF_Wind]=get_W_consider_Pr(height,data_h{1},data_h{3},data_h{4},data_h{5},qiebian0,0.855);
        [CF_PV]=get_PV_dc2ac(data_h{3},data_h{2},data_h{4},0.86);
        save(['F:\VREoutput\VRE_',NameModel{im},'_',NameSSP{is},'_2021_2060.mat'],'CF_Wind','CF_PV','lon_lat_of_VRE_output');
    end
end
