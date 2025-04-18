% clear;clc;close all
%% nc
% old
% name1 = 'ASA_IMP_1PNESA20090722_113810_000000182081_00023_38654_0000_Cal_Orb_Spk_TC_Spk.nc';
% ncdisp(name1);
% lon = double(ncread(name1,'lon')); %1D
% lat = double(ncread(name1,'lat'));

% new
% clear;
name2 = './CV/ASA_IMM_1PNDSI20070803_113542_000000562060_00252_28362_0000_Cal_Spk_Spk_TC.nc';
title_name ='ASA-IMM-1P 03-Aug-2007 11:35:42 UTC';
ncdisp(name2);

lon = double(ncread(name2,'lon')); %1D
lat = double(ncread(name2,'lat'));

lon_grid = double(ncread(name2,'longitude')); %2D
lat_grid = double(ncread(name2,'latitude')); %2D
Sigma0 =  ncread(name2,'Sigma0_VV_dB');


%%

LONLIMS = [-25.28 -23.6];
LATLIMS = [13.1 16.40];


LONLIMS = [-25 -23.6];
LATLIMS = [14.65 16.40];
load('gsdtol.mat');
load("hotres_r.mat")
load('BlueDarkRed18.mat');

% figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
 m_grid('linestyle','none','linewidth',1.2,'FontSize',28,'fontname','Arial',...
    'xtick',8,'tickdir','in');hold on;
% m_image(lon_grid,lat_grid,Sigma0); % wrong
m_image(lon,lat,Sigma0');
clim([-12.0 0])
% colormap(gsdtol);
load('MPL_GnBu_r.mat');colormap(F2,MPL_GnBu_r);
m_grid('linestyle','none','linewidth',1.2,'FontSize',28,'fontname','Arial',...
    'xtick',8,'tickdir','in');hold on;
% title(title_name,'fontname','Arial','fontsize',16)
% img=getframe(gcf);
% imwrite(img.cdata,['CV_03_Aug_2007.tiff'], 'tiff', 'Resolution', 300)


