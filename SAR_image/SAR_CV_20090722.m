% clear;clc;close all
%% nc
% old
% name1 = 'ASA_IMP_1PNESA20090722_113810_000000182081_00023_38654_0000_Cal_Orb_Spk_TC_Spk.nc';
% ncdisp(name1);
% lon = double(ncread(name1,'lon')); %1D
% lat = double(ncread(name1,'lat'));

% new

name2 = './CV/ASA_IMP_1PNESA20090722_113810_000000182081_00023_38654_0000_Orb_Cal_Spk_Spk_Spk_TC.nc';
title_name ='ASA-IMP-1P 22-Jul-2009 11:37:26 UTC';
ncdisp(name2);

lon = double(ncread(name2,'lon')); %1D
lat = double(ncread(name2,'lat'));

lon_grid = double(ncread(name2,'longitude')); %2D
lat_grid = double(ncread(name2,'latitude')); %2D
Sigma0 =  ncread(name2,'Sigma0_VV_dB');


%% PIC
LONLIMS = [-25.3 -24.10];
LATLIMS = [16.18 17.46];

LONLIMS = [-25.3 -24.10];
LATLIMS = [16.18 17.5];

load('gsdtol.mat');
load("hotres_r.mat")
load('MPL_GnBu_r.mat');
% figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
 m_grid('linestyle','none','linewidth',1.5,'FontSize',28,'fontname','Arial',...
    'xtick',8,'tickdir','in');hold on;
% m_image(lon_grid,lat_grid,Sigma0); % wrong
m_image(lon,lat,Sigma0');
clim([-10 0])
% colormap(gsdtol);
colormap(F1,MPL_GnBu_r);
m_grid('linestyle','none','linewidth',1.5,'FontSize',28,'fontname','Arial',...
    'xtick',8,'tickdir','in');hold on;
% title(title_name,'fontname','Arial','fontsize',20)
% img=getframe(gcf);
% % resized_img = imresize(img, [800, 700]);
% imwrite(img.cdata,['CV_22_Jul_2009.tiff'], 'tiff', 'Resolution', 300)


