%Figure5d
clear;clc;close all
addpath ../../Model_info/
load('Grid_info.mat','ie_g','je_g','ke','lonp_grid','latp_grid');
load('Grid_info.mat','weto_p','depto_grid','zzout');
%%
load('M2_Flux_Divergence.mat');
load('M2_conversion.mat');
%%
iw = 30;ie = 1;
jn = 30;js = 30;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
R = C - Div_F;

LONLIMS = [-26.5 -20.5];
LATLIMS = [14 18];

figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  


m_pcolor(lonp_grid,latp_grid,-R);shading interp;hold on;

[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:4000],...
    'linewidth',0.8,'color',[.4 .4 .4]);hold on;
% clabel(c,h,'LabelSpacing',1500,'color','k',...
%     'fontsize',10,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')

% load('BlueWhiteOrangeRed.mat');colormap(BlueWhiteOrangeRed);hold on;
% 
% aa = -R;
% aa(aa<0)=nan;
% aaa= (log10(aa));
% aaa(aaa==0)=nan;
% m_pcolor(lonp_grid,latp_grid,aaa);shading interp;hold on;
% load('BlueWhiteOrangeRed.mat');colormap(BlueWhiteOrangeRed);hold on;
% clim([-5 -1])
 clim([-0.05 0.05])
 
load('MPL_PuOr_r.mat')
colormap(MPL_PuOr_r);hold on
clim([-0.1 0.1])
bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold');hold on;
set(get(bar,'Title'),'string','W m^-^2','fontname','Arial','fontweight','bold');

% m_gshhs_h('patch',[0.85 0.64 0.12],'edgecolor','k','linewidth',1.5);
% m_grid('linestyle','none','linewidth',1.5,'fontsize',18,'fontname','Arial');hold on;  

set(gca,'Layer','top','fontweight','bold');

m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  


set(gca,'Layer','top','fontweight','bold');

% img=getframe(gcf);
% imwrite(img.cdata,['CVS_M2energy_Residual.tiff'], 'tiff', 'Resolution', 300)


%%
% rate = -R./depto_grid./1025;
% figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
% m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
% m_grid('linestyle','none','linewidth',1.5,'fontsize',18,'fontname','Arial');hold on;
% m_pcolor(lonp_grid,latp_grid,real(log10(rate)));shading interp;hold on;
% % load('hotres_r.mat');
% % load('hotres.mat');
% colormap(jet);
% caxis([-6 0])
% bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold');hold on;
% set(get(bar,'Title'),'string','log10 (W kg^-^1)','fontname','Arial','fontweight','bold');
% 
% % m_gshhs_h('patch',[0.85 0.64 0.12],'edgecolor','k','linewidth',1.5);
% % m_grid('linestyle','none','linewidth',1.5,'fontsize',18,'fontname','Arial');hold on;  
% 
% set(gca,'Layer','top','fontweight','bold');
% 
% m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);
% m_grid('linestyle','none','linewidth',1.5,'fontsize',18,'fontname','Arial');hold on;  
% 
% set(gca,'Layer','top','fontweight','bold');

% img=getframe(gcf);
% imwrite(img.cdata,['CVS_M2energy_Residual.tiff'], 'tiff', 'Resolution', 300)
%%

figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;
m_pcolor(lonp_grid,latp_grid,Div_F);shading interp;hold on;


[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:4000],...
    'linewidth',0.8,'color',[.4 .4 .4]);hold on;
clabel(c,h,'LabelSpacing',1500,'color','k',...
    'fontsize',10,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')

% load('BlueWhiteOrangeRed.mat');colormap(BlueWhiteOrangeRed);hold on;
% 

load('MPL_PuOr_r.mat')
colormap(MPL_PuOr_r);hold on
% 
clim([-0.2 0.2])
bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold');hold on;
set(get(bar,'Title'),'string','W m^-^2','fontname','Arial','fontweight','bold');

% m_gshhs_h('patch',[0.85 0.64 0.12],'edgecolor','k','linewidth',1.5);
% m_grid('linestyle','none','linewidth',1.5,'fontsize',18,'fontname','Arial');hold on;  

set(gca,'Layer','top','fontweight','bold');

m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  

set(gca,'Layer','top','fontweight','bold');

% img=getframe(gcf);
% imwrite(img.cdata,['CVS_M2energy_Div.tiff'], 'tiff', 'Resolution', 300)
