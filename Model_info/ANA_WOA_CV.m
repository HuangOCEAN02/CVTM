clear;clc;close all
load('CVTM_CV_summer.mat')
% Summer [Aug,Sep,Oct,ASO]
% sw_dpth sw_pres
% from meter to dbar
p_summer = sw_pres(Depth,LAT);
pt_summer = sw_ptmp(Sal_summer,T_summer,p_summer,0);
[Nsq_summer,vort,p_ave] = sw_bfrq(Sal_summer,T_summer,p_summer);
[m,n] = size(Nsq_summer);
N2_summer(1)=Nsq_summer(1);
N2_summer(2:n+1)=Nsq_summer(1:n);
% from dbar to meter
z(1)=0;
z(2:n+1)=sw_dpth(p_ave',LAT);
% add density


r_summer = sw_dens(Sal_summer,T_summer,p_summer);




save CVTM_CV_summer.mat p_summer pt_summer N2_summer z r_summer -append
%%
load('CVTM_CV_winter.mat')
% winter [Feb,Mar,Apr,FMA]
% sw_dpth sw_pres
% from meter to dbar
p_winter = sw_pres(Depth,LAT);
pt_winter = sw_ptmp(Sal_winter,T_winter,p_winter,0);
[Nsq_winter,vort,p_ave] = sw_bfrq(Sal_winter,T_winter,p_winter);
[m,n] = size(Nsq_winter);
N2_winter(1)=Nsq_winter(1);
N2_winter(2:n+1)=Nsq_winter(1:n);
% from dbar to meter
z(1)=0;
z(2:n+1)=sw_dpth(p_ave(1:n)',LAT);

r_winter = sw_dens(Sal_winter,T_winter,p_winter);


save CVTM_CV_winter.mat p_winter pt_winter N2_winter z r_winter -append
%%

