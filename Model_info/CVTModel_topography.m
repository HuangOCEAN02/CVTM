%% Figure2a
load('CVTM_BRAVE60_topo.mat')
load('Grid_info.mat','depto_grid','latp_grid','lonp_grid')
load('cmp_haxby_r.mat');
load('cmp_haxby.mat');
 % lon_range = [ max(max(LON_level1_P)) min(min(LON_level1_P)) ];
 % lat_range = [ max(max(LAT_level1_P)) min(min(LAT_level1_P)) ];
 % LONLIMS = [min(lon_range) max(lon_range)];
 % LATLIMS = [min(lat_range) max(lat_range)];

load('Level1_domain.mat')
% figure(1);clf;set(gcf,'color','w');set(gcf,'position',[100 20 800 750])
LON_level1_P = lonp_grid;
LAT_level1_P = latp_grid;
DEPTH_P = depto_grid;

m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',28,'fontname','Arial');

%%
lat_35 = ncread("./TPN+J1N/ctoh.sla.ref.TPN+J1N.wafrica.035.mgr.nc",'lat');
lon_35 = ncread("./TPN+J1N/ctoh.sla.ref.TPN+J1N.wafrica.035.mgr.nc",'lon');
m_plot(lon_35,lat_35,'-.','color','[0.98 0 0.98]',...
            'linewidth',2,'DisplayName','TPN+J1N');hold on 
lat_200 = ncread("./TP+J1+J2/ctoh.sla.ref.TP+J1+J2.wafrica.200.mgr.nc",'lat');
lon_200 = ncread("./TP+J1+J2/ctoh.sla.ref.TP+J1+J2.wafrica.200.mgr.nc",'lon');
m_plot(lon_200,lat_200,'--','color','k',...
 'linewidth',2,'DisplayName','TP+J1+J2');hold on 
lat_s  = [ 17.9900 16.8667 14.6767 ];
lon_s  = [ -16.0367 -24.9833 -17.4200 ];
m_plot(lon_s,lat_s,'ok','linewidth',1.5,'Markersize',15,'MarkerFaceColor','c',...
    'DisplayName','Tide gauge'); hold on;
Lon_CVOO = -24.2497;
Lat_CVOO = 17.6067;
m_plot(Lon_CVOO,Lat_CVOO,'ok','linewidth',1.5,'Markersize',15,'MarkerFaceColor','r',...
    'DisplayName','Mooring'); hold on;
leg = legend('show','Autoupdate','off');

set(leg,'fontsize',22,'fontname','Arial','Orientation','vertical','fontweight','bold',...
    'Position',[0.368345359479814 0.68032786885246 0.08203125 0.144467213114754],...
    'linewidth',2)

%%



m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',28,'fontname','Arial');

m_pcolor(LON_level1_P,LAT_level1_P,DEPTH_P*1e-3);shading interp; hold on;
[c,h] = m_contour(LON_level1_P,LAT_level1_P,DEPTH_P*1e-3,[0:0.5:5],'linestyle','-',...
    'linewidth',0.8,'color',[.4 .4 .4]);
% m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',15,'fontname','Arial');
% m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1);
% m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',15,'fontname','Arial');
% 

 colormap(cmp_haxby_r);clim([-0.100 6]);
 [c,h] = m_contour(LON_level1_P,LAT_level1_P,DEPTH_P*1e-3,[0.5,0.5],'linestyle','-',...
    'linewidth',0.8,'color',[.4 .4 .4]);

 h2=colorbar('location','eastOutside','fontsize',28,'FontWeight','bold');
set(get(h2,'Title'),'string','km','fontname','Arial','fontsize',28);
set(h2,'Ticks',[0:1:6])

 % cbarrow;

 m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',28,'fontname','Arial');
m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1);

lat_35 = ncread("./TPN+J1N/ctoh.sla.ref.TPN+J1N.wafrica.035.mgr.nc",'lat');
lon_35 = ncread("./TPN+J1N/ctoh.sla.ref.TPN+J1N.wafrica.035.mgr.nc",'lon');
m_plot(lon_35,lat_35,'-.','color','[0.98 0 0.98]',...
            'linewidth',2,'DisplayName','TPN+J1N');hold on 


lat_111 = ncread("./TPN+J1N/ctoh.sla.ref.TPN+J1N.wafrica.111.mgr.nc",'lat');
lon_111 = ncread("./TPN+J1N/ctoh.sla.ref.TPN+J1N.wafrica.111.mgr.nc",'lon');
% m_plot(lon_111,lat_111,'o','color','k',...
%             'markerfacecolor',[0.98 0 0.98],'Markersize',3,'linewidth',2);hold on 
m_plot(lon_111,lat_111,'-.','color','[0.98 0 0.98]',...
            'linewidth',2);hold on 



lat_213 = ncread("./TPN+J1N/ctoh.sla.ref.TPN+J1N.wafrica.213.mgr.nc",'lat');
lon_213 = ncread("./TPN+J1N/ctoh.sla.ref.TPN+J1N.wafrica.213.mgr.nc",'lon');
% m_plot(lon_213,lat_213,'o','color','k',...
%             'markerfacecolor',[0.98 0 0.98],'Markersize',3,'linewidth',2);hold on 
m_plot(lon_213,lat_213,'-.','color','[0.98 0 0.98]',...
            'linewidth',2);hold on 



lat_137 = ncread("./TPN+J1N/ctoh.sla.ref.TPN+J1N.wafrica.137.mgr.nc",'lat');
lon_137 = ncread("./TPN+J1N/ctoh.sla.ref.TPN+J1N.wafrica.137.mgr.nc",'lon');
% m_plot(lon_137,lat_137,'o','color','k',...
%             'markerfacecolor',[0.98 0 0.98],'Markersize',3,'linewidth',2);hold on 
m_plot(lon_137,lat_137,'-.','color','[0.98 0 0.98]',...
            'linewidth',2);hold on 


lat_061 = ncread("./TPN+J1N/ctoh.sla.ref.TPN+J1N.wafrica.061.mgr.nc",'lat');
lon_061 = ncread("./TPN+J1N/ctoh.sla.ref.TPN+J1N.wafrica.061.mgr.nc",'lon');
% m_plot(lon_061,lat_061,'o','color','k',...
%             'markerfacecolor',[0.98 0 0.98],'Markersize',3,'linewidth',2);hold on 
m_plot(lon_061,lat_061,'-.','color','[0.98 0 0.98]',...
            'linewidth',2);hold on 
%%
lat_200 = ncread("./TP+J1+J2/ctoh.sla.ref.TP+J1+J2.wafrica.200.mgr.nc",'lat');
lon_200 = ncread("./TP+J1+J2/ctoh.sla.ref.TP+J1+J2.wafrica.200.mgr.nc",'lon');
m_plot(lon_200,lat_200,'--','color','k',...
 'linewidth',2,'DisplayName','TP+J1+J2');hold on 

lat_174 = ncread("./TP+J1+J2/ctoh.sla.ref.TP+J1+J2.wafrica.174.mgr.nc",'lat');
lon_174 = ncread("./TP+J1+J2/ctoh.sla.ref.TP+J1+J2.wafrica.174.mgr.nc",'lon');
m_plot(lon_174,lat_174,'--','color','k',...
 'linewidth',2);hold on 
lat_098 = ncread("./TP+J1+J2/ctoh.sla.ref.TP+J1+J2.wafrica.098.mgr.nc",'lat');
lon_098 = ncread("./TP+J1+J2/ctoh.sla.ref.TP+J1+J2.wafrica.098.mgr.nc",'lon');
m_plot(lon_098,lat_098,'--','color','k',...
 'linewidth',2);hold on 
lat_022 = ncread("./TP+J1+J2/ctoh.sla.ref.TP+J1+J2.wafrica.022.mgr.nc",'lat');
lon_022 = ncread("./TP+J1+J2/ctoh.sla.ref.TP+J1+J2.wafrica.022.mgr.nc",'lon');
m_plot(lon_022,lat_022,'--','color','k',...
 'linewidth',2);hold on 


lat_s  = [ 17.9900 16.8667 14.6767 ];
lon_s  = [ -16.0367 -24.9833 -17.4200 ];

lat_s  = [ 16.7550  17.9900 14.6767 ];
lon_s  = [ -22.9833 -16.0367 -17.4200 ];

m_plot(lon_s,lat_s,'ok','linewidth',1.5,'Markersize',15,'MarkerFaceColor','c',...
    'DisplayName','Tide gauge'); hold on;
%% CVOO
Lon_CVOO = -24.2497;
Lat_CVOO = 17.6067;
m_plot(Lon_CVOO,Lat_CVOO,'ok','linewidth',1.5,'Markersize',15,'MarkerFaceColor','r',...
    'DisplayName','CVOO mooring'); hold on;
%% CapeVerde AREA
% m_plot([-26.5,-26.5,-20.5,-20.5,-26.5],[14,18,18,14,14],'-','linewidth',2.0,'color','r');hold on
m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',28,'fontname','Arial');
set(gca,'Layer','top')
img=getframe(gcf);
imwrite(img.cdata,['Figure2a.tiff'], 'tiff', 'Resolution', 300);
