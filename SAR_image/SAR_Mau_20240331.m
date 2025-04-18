% clear;clc;close all
%% nc2
loca2 = ['/Users/josephhuang/Desktop/SAR_analysis/Senegal_Mau_20240331/analysis/'];
file2 ='S1_20240331T191910_053230_067369_6D39.nc';

name2 = [loca2,file2];
% title_name ='ASA-IMP-1P 12-Oct-2007 11:35:21 UTC';
% ncdisp(name2);

lon2 = double(ncread(name2,'lon')); %1D
lat2 = double(ncread(name2,'lat'));

% lon_grid = double(ncread(name2,'longitude')); %2D
% lat_grid = double(ncread(name2,'latitude')); %2D
Sigma0_2 =  ncread(name2,'Sigma0_VV_db');



% SAR range of dakar
LONLIMS = [-18.334 -16.4];
LATLIMS = [14.677 16.621];
% SAR range of Mau
LATLIMS = [16.189 18.129]
LONLIMS = [-18.647 -16.019]

% all
LONLIMS = [-17.1 -16];
% LONLIMS = [-16.7 -16];
LATLIMS = [16.6 18];

% load('../Moorings_info.mat');

load('MPL_GnBu_r.mat');
load('gsdtol.mat');
load("MPL_GnBu.mat")
load('BlueDarkRed18.mat');
% figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
 m_grid('linestyle','none','linewidth',1.5,'FontSize',28,'fontname','Arial',...
    'xtick',8,'tickdir','in');hold on;
% m_image(lon_grid,lat_grid,Sigma0); % wrong
m_image(lon2,lat2,Sigma0_2');
clear lon2 lat2 Sigma0_2
%% nc1
loca1 = ['/Users/josephhuang/Desktop/SAR_analysis/Senegal_Mau_20240331/analysis/'];
file1 ='S1A_IW_GRDH_1SDV_20240331T191910_20240331T191935_053230_067369_1DB1_NR_Cal_Spk_TC_dB.nc';
name1 = [loca1,file1];
% title_name ='ASA-IMP-1P 12-Oct-2007 11:35:21 UTC';
% ncdisp(name2);

lon1 = double(ncread(name1,'lon')); %1D
lat1 = double(ncread(name1,'lat'));

% lon_grid = double(ncread(name2,'longitude')); %2D
% lat_grid = double(ncread(name2,'latitude')); %2D
Sigma0_1 =  ncread(name1,'Sigma0_VV_db');

hold on;m_image(lon1,lat1,Sigma0_1');
% hold on;m_plot(lon_m,lat_m,'o','color','k',...
%               'markerfacecolor',[0.2 0.8 0.8],'Markersize',8,'linewidth',0.5);hold on 
% hold on;m_plot(lon_m,lat_m,'o','color','k',...
%               'markerfacecolor',[0.7 0.2 0.8],'Markersize',10,'linewidth',0.5);hold on 


clim([-25 -16.5])
% colormap(gsdtol);
colormap(F4,MPL_GnBu_r);
% colorbar;
m_grid('linestyle','none','linewidth',1.5,'FontSize',28,'fontname','Arial',...
    'xtick',8,'tickdir','in');hold on;
% m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',0.5);
% img=getframe(gcf);
% imwrite(img.cdata,['Mau_31_Mar_2024.tiff'], 'tiff', 'Resolution', 300)

