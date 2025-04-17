% Figure9b
clear;clc;close all
load('BC_tide_SSHA_Mss.mat');
SSHA_M2_mss = SSHA_tide(:,:)*1e+2;
lon_mss = lon;
lat_mss = lat;


LONLIMS = [-21 -15];
LATLIMS = [12.6 18.6];


figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  

m_pcolor(lon_mss,lat_mss,-SSHA_M2_mss);shading interp;

clim([-1.5 1.5])
load('MPL_seismic.mat');colormap(MPL_seismic);hold on;
load('BlueDarkRed18.mat');colormap(BlueDarkRed18);
% title([datestr(SDtime(t)),' at ',num2str(R(k)+1000),'kg m^-^3'],'fontname','Arial','fontsize',20)
% m_gshhs_h('patch',[.8 .8 .8],'edgecolor','k','linewidth',1.5);
m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);

bar = colorbar;set(bar,'fontsize',28,'fontname','Arial','Location','eastoutside','fontweight','bold','LineWidth',2);hold on;
set(get(bar,'Title'),'string','cm','fontname','Arial','fontweight','bold','LineWidth',2);

m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
set(gca,'Layer','top','fontweight','bold');

img=getframe(gcf);
imwrite(img.cdata,['SSHA_Mss.tiff'], 'tiff', 'Resolution', 300)