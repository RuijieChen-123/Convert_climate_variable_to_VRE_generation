function [PW,CF_W]=getWoutputV3(vci,vr,vco,V,T)%

PW=V;
iwp1=find(V<vci);
iwp2=find(V>=vci&V<vr);
iwp3=find(V>=vr&V<vco);
iwp4=find(V>=vco);
PW(iwp1)=0;
PW(iwp2)=(V(iwp2).^3-vci^3)/(vr^3-vci^3);
PW(iwp3)=1;
PW(iwp4)=0; 
i_low_T=find(T<-30);
PW(i_low_T)=0;
CF_W=mean(PW);