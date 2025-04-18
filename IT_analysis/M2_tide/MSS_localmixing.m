%Figure 9d
clear;clc;close all
addpath ../../Model_info/
load('Grid_info.mat','ie_g','je_g','ke','lonp_grid','latp_grid');
load('Grid_info.mat','weto_p','depto_grid','zzout');
%%
load('./M2_Flux_Divergence.mat');
load('./M2_conversion.mat');
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

LONLIMS = [-21 -15];
LATLIMS = [14.2 18.6];


LONLIMS = [-21 -15];
LATLIMS = [12.6 18.6];

figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;
m_pcolor(lonp_grid,latp_grid,-R);shading interp;hold on;

[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:250:3500],...
    'linewidth',0.4,'color',[.4 .4 .4]);hold on;
% clabel(c,h,'LabelSpacing',700,'color','k',...
%     'fontsize',9,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')

% load('BlueWhiteOrangeRed.mat');colormap(BlueWhiteOrangeRed);hold on;
% 

load('MPL_PuOr_r.mat')
colormap(MPL_PuOr_r);hold on
clim([-0.02 0.02])
bar = colorbar;set(bar,'fontsize',28,'fontname','Arial','Location','eastoutside','fontweight','bold','LineWidth',2);hold on;
set(get(bar,'Title'),'string','W m^-^2','fontname','Arial','fontweight','bold','LineWidth',2);

% m_gshhs_h('patch',[0.85 0.64 0.12],'edgecolor','k','linewidth',1.5);
% m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  

set(gca,'Layer','top','fontweight','bold');

m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  

set(gca,'Layer','top','fontweight','bold');

img=getframe(gcf);
imwrite(img.cdata,['Fig9d.tiff'], 'tiff', 'Resolution', 300)

%%