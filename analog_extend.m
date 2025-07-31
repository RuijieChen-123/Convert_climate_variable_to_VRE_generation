function [down_analogV3]=analog_extend(Nday_similar,Nremain,Iday,TrainData,TestData,Nvar,Mat_noNAN,data_ref_h_Train)
    Icompare0_2=(mod(Iday-1,365)+1)-Nday_similar-1:(mod(Iday-1,365)+1)+Nday_similar+1;
    Icompare_2=Icompare0_2;
    for iy=1:ceil(size(TrainData{1},2)/365)
        Icompare_2=[Icompare_2,Icompare0_2+365*iy];
    end
    Icompare_2=intersect(Icompare_2,1:size(TrainData{1},2));


    down_analogV3=cell(Nvar,1);
    for iv=1:Nvar
        down_analogV3{iv}=zeros(size(Mat_noNAN,1),24);
    end

    for iall=1:size(Mat_noNAN,1)
       
        [seq_temp,~]=find_similar_multi_MV3_lag_ahead(Iday,iall,Icompare_2,Nvar,TestData,TrainData,Nremain);
        %seq_temp:most similar day id
        Id_best_onesite=seq_temp(1);
        down_analogV3{2}(iall,:)=data_ref_h_Train{2}(iall,24*(Id_best_onesite-1)+1:Id_best_onesite*24)/...
            mean(data_ref_h_Train{2}(iall,24*(Id_best_onesite-1)+1:Id_best_onesite*24))*TestData{2}(iall,Iday);
        down_analogV3{1}(iall,:)=data_ref_h_Train{1}(iall,24*(Id_best_onesite-1)+1:Id_best_onesite*24)/...
            mean(data_ref_h_Train{1}(iall,24*(Id_best_onesite-1)+1:Id_best_onesite*24))*TestData{1}(iall,Iday);
        down_analogV3{3}(iall,:)=data_ref_h_Train{3}(iall,24*(Id_best_onesite-1)+1:Id_best_onesite*24)-...
            mean(data_ref_h_Train{3}(iall,24*(Id_best_onesite-1)+1:Id_best_onesite*24))+TestData{3}(iall,Iday);
        down_analogV3{4}(iall,:)=data_ref_h_Train{4}(iall,24*(Id_best_onesite-1)+1:Id_best_onesite*24)/...
            mean(data_ref_h_Train{4}(iall,24*(Id_best_onesite-1)+1:Id_best_onesite*24))*TestData{4}(iall,Iday);
        down_analogV3{5}(iall,:)=data_ref_h_Train{5}(iall,24*(Id_best_onesite-1)+1:Id_best_onesite*24)/...
            mean(data_ref_h_Train{5}(iall,24*(Id_best_onesite-1)+1:Id_best_onesite*24))*TestData{5}(iall,Iday);
    end
    