function [seq_remain,seq_min]=find_similar_multi_MV3_lag_ahead(Iday,iall,Icompare,Nvar,TestData,TrainData,Nremain)

if Iday==1
    Data_lonlatday_rep=cell(Nvar,1);
    Data_lonlat_ref=cell(Nvar,1);
    Dist_mat=cell(Nvar,1);
    Dist_mat_rank=zeros(length(Icompare),Nvar);
    for iv=1:Nvar
        Data_lonlatday_rep{iv}=repmat(TestData{iv}(iall,Iday),1,length(Icompare));
        Data_lonlat_ref{iv}=TrainData{iv}(iall,Icompare);
        Dist_mat{iv}=sum(abs(Data_lonlatday_rep{iv}-Data_lonlat_ref{iv}),1);
        [~,tempB]=sort(Dist_mat{iv});
        Dist_mat_rank(tempB,iv)=1:length(Icompare);
    end
    
    [~,seq_min]=sort(sum(Dist_mat_rank,2));
    seq_min=Icompare(seq_min);
    seq_remain=seq_min(1:Nremain);
elseif Iday==size(TestData{1},2)
    Data_lonlatday_rep=cell(Nvar,1);
    Data_lonlat_ref=cell(Nvar,1);
    Dist_mat=cell(Nvar,1);
    Dist_mat_rank=zeros(length(Icompare),Nvar);
    for iv=1:Nvar
        Data_lonlatday_rep{iv}=repmat(TestData{iv}(iall,Iday),1,length(Icompare));
        Data_lonlat_ref{iv}=TrainData{iv}(iall,Icompare);
        Dist_mat{iv}=sum(abs(Data_lonlatday_rep{iv}-Data_lonlat_ref{iv}),1);
        [~,tempB]=sort(Dist_mat{iv});
        Dist_mat_rank(tempB,iv)=1:length(Icompare);
    end
    
    [~,seq_min]=sort(sum(Dist_mat_rank,2));
    seq_min=Icompare(seq_min);
    seq_remain=seq_min(1:Nremain);
else
    Data_lonlatday_rep=cell(Nvar,1);
    Data_lonlat_ref=cell(Nvar,1);
    Dist_mat=cell(Nvar,1);
    Dist_mat_rank=zeros(length(Icompare)-2,Nvar);
    for iv=1:Nvar
        Data_lonlatday_rep{iv}=repmat([TestData{iv}(iall,Iday-1);TestData{iv}(iall,Iday);TestData{iv}(iall,Iday+1)],1,length(Icompare)-2);
        Data_lonlat_ref{iv}=[TrainData{iv}(iall,Icompare(1:end-2));TrainData{iv}(iall,Icompare(2:end-1));TrainData{iv}(iall,Icompare(3:end))];
        Dist_mat{iv}=sum(abs(Data_lonlatday_rep{iv}-Data_lonlat_ref{iv}),1);
        [~,tempB]=sort(Dist_mat{iv});
        Dist_mat_rank(tempB,iv)=1:length(Icompare)-2;
    end
    
    [~,seq_min]=sort(sum(Dist_mat_rank,2));
    Icompare_lag=Icompare(1:end-2);
    seq_min=Icompare_lag(seq_min)+1;
    seq_remain=seq_min(1:Nremain);
end

