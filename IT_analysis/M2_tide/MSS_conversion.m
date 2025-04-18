%Figure9a
clear;clc;close all
addpath ../../Model_info/
load('Grid_info.mat','ie_g','je_g','ke','lonp_grid','latp_grid');
load('Grid_info.mat','weto_p','depto_grid','zzout');
%%
load('M2_flux_uh.mat')
load('M2_flux_vh.mat')
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
colormap(jet)
%%
% LONLIMS = [min(min(lonp_grid)) max(max(lonp_grid))];
% LATLIMS = [min(min(latp_grid)) max(max(latp_grid))];

LONLIMS = [-21 -15];
LATLIMS = [14.2 18.6];

LONLIMS = [-20.2 -16.8];
LATLIMS = [12.6 15];

LONLIMS = [-21 -15];
LATLIMS = [12.6 18.6];


figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
m_pcolor(lonp_grid,latp_grid,C);shading interp;hold on;

%% Mau 
select_indicex = find(lonp_grid(:,1)>=-18.5 & lonp_grid(:,1)<=-16);
select_indicey = find(latp_grid(1,:)>=15 & latp_grid(1,:)<=18.4);
lon_mcs  = lonp_grid(select_indicex,select_indicey);
lat_mcs = latp_grid(select_indicex,select_indicey);
m_plot(lon_mcs(1,:),lat_mcs(1,:),'k-','linewidth',2.0);hold on;
m_plot(lon_mcs(end,:),lat_mcs(end,:),'k-','linewidth',2.0);hold on;
m_plot(lon_mcs(:,1),lat_mcs(:,1),'k-','linewidth',2.0);hold on;
m_plot(lon_mcs(:,end),lat_mcs(:,end),'k-','linewidth',2.0);hold on;
clear select_indicex select_indicey
%% SCS
select_indicex = find(lonp_grid(:,1)>=-18.5 & lonp_grid(:,1)<=-16);
select_indicey = find(latp_grid(1,:)>=13 & latp_grid(1,:)<=15);
lon_scs  = lonp_grid(select_indicex,select_indicey);
lat_scs = latp_grid(select_indicex,select_indicey);

m_plot(lon_scs(1,:),lat_scs(1,:),'k-','linewidth',2.0);hold on;
m_plot(lon_scs(end,:),lat_scs(end,:),'k-','linewidth',2.0);hold on;
% m_plot(lon_scs(:,1),lat_scs(:,1),'k-','linewidth',2.0);hold on;
m_plot(lon_scs(:,end),lat_scs(:,end),'k-','linewidth',2.0);hold on;



[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:250:3500],...
    'linewidth',0.4,'color',[.4 .4 .4]);hold on;
% clabel(c,h,'LabelSpacing',1500,'color',[.4 .4 .4],...
%     'fontsize',15,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')

load('BlueWhiteOrangeRed.mat');colormap(BlueWhiteOrangeRed);hold on;
load('NCV_blue_red.mat');colormap(NCV_blue_red);hold on;
clim([-0.08 0.08])
bar = colorbar;set(bar,'fontsize',28,'fontname','Arial','Location','eastoutside','fontweight','bold','linewidth',2);hold on;
set(get(bar,'Title'),'string','W m^-^2','fontname','Arial','fontweight','bold','linewidth',2);
set(bar,'Ticks',[-0.08:0.02:0.08])
m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);
%%
u_flux = Flux_x;
v_flux = Flux_y;
u_flux = u_flux*1e-3.*depto_grid;
v_flux = v_flux*1e-3.*depto_grid;

% lable
labelx = [-15.9,-15.8];labelz = [17.80,17.85];
labelu = [4,0];labelv=[0,0];

% u_flux(333:347,80:91)=nan;
% v_flux(333:347,80:91)=nan;

XX_pic = lonp_grid(2:10:end,2:10:end);
ZZ_pic = latp_grid(2:10:end,2:10:end);
UU_pic = u_flux(2:10:end,2:10:end); 
VV_pic = v_flux(2:10:end,2:10:end);

% UU_pic(69:75,60:64)=nan;
% VV_pic(69:75,60:64)=nan;

scale_auto = Get_Autoscale(XX_pic,ZZ_pic,UU_pic,VV_pic); 
scale_label = Get_Autoscale(labelx,labelz,labelu,labelv);
scale_factor = scale_auto/scale_label;

q_label= m_quiver(labelx,labelz,labelu,labelv,...
        4.0,'MaxHeadSize',1.5,'color','b','linewidth',1.8);
q_minus = m_quiver(XX_pic,ZZ_pic,UU_pic,VV_pic,...
        4.0/scale_factor,'MaxHeadSize',0.8,'color',[.4 .4 .4],'linewidth',1.5);
set(q_minus,'MaxHeadSize',1.2);


% m_gshhs_h('patch',[0.85 0.64 0.12],'edgecolor','k','linewidth',1.5);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
set(gca,'Layer','top');


lat_s  = [17.9900 14.6767 ];
lon_s  = [-16.0367 -17.4200 ];

m_plot(lon_s,lat_s,'ok','linewidth',1.5,'Markersize',15,'MarkerFaceColor','c',...
    'DisplayName','Tide gauge'); hold on;


annotation(figure(1),'textbox',...
    [0.657605113636364 0.776763014067866 0.0643948863636357 0.0400000000000004],...
    'String','4 kW m^-^1',...
    'LineStyle','none',...
    'FontSize',25,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'EdgeColor','none') 

annotation(figure(1),'rectangle',...
    [0.659090909090909 0.779411764705883 0.0645454545454546 0.05],...
        'LineWidth',2);


img=getframe(gcf);
imwrite(img.cdata,['Fig9a.tiff'], 'tiff', 'Resolution', 300)
