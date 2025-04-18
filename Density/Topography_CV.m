%Figure3a
% clear;clc;close all
addpath ../Model_info/
load('Grid_info.mat','ie_g','je_g','ke','lonp_grid','latp_grid');
load('Grid_info.mat','weto_p','depto_grid','zzout');
%%
iw = 30;ie = 1;
jn = 30;js = 30;
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
%%
ie = size(depto_grid,1);
je = size(depto_grid,2);
mask = zeros(ie,je)+1;
mask(isnan(depto_grid)==1)=0;

depto_grid = depto_grid*1e-3;
depto_grid(mask==0)=0;

LONLIMS = [-26 -21.5];
LATLIMS = [14.45 17.7];

% figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',1.5,'FontSize',28,'fontname','Arial');hold on;  


m_pcolor(lonp_grid,latp_grid,depto_grid);shading interp; hold on;
[c,h] = m_contour(lonp_grid,latp_grid,depto_grid,[0.5:0.5:4.5],'linestyle','-',...
    'linewidth',0.5,'color',[.4 .4 .4]);
%clabel(c,h,'LabelSpacing',2500,'color','k',...
%    'fontsize',12,'fontname','Arial','FontSmoothing','on','fontweight','bold')

load('cmp_haxby_r.mat')
colormap(cmp_haxby_r);
clim([-0.01 4.5])
bar = colorbar;set(bar,'FontSize',28,'fontname','Arial','Location','eastoutside');hold on;
set(get(bar,'Title'),'string','km','fontname','Arial','FontSize',28);
set(bar,'Ticks',[0:0.5:4.5])
% cbarrow;

m_grid('linestyle','none','linewidth',2.5,'XAxisLocation','bottom','FontSize',28,'fontname','Arial');
m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',2);

set(gca,'Layer','top','fontweight','bold');

img=getframe(gcf);
imwrite(img.cdata,['Fig3a.tiff'], 'tiff', 'Resolution', 300)

