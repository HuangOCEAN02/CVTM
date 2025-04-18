%Figure 7 up
% clear;clc;close all
addpath ../../Model_info/
load('Grid_info.mat','ie_g','je_g','ke','lonp_grid','latp_grid');
load('Grid_info.mat','weto_p','depto_grid','zzout');
%%
load('M2_flux_uh.mat')
load('M2_flux_vh.mat')
Flux_x_D2 = Flux_x;
Flux_y_D2 = Flux_y;
load('../S2_tide/S2_flux_uh.mat')
load('../S2_tide/S2_flux_vh.mat')
Flux_x_D2 = Flux_x_D2 + Flux_x;
Flux_y_D2 = Flux_y_D2 + Flux_y;
load('../N2_tide/N2_flux_uh.mat')
load('../N2_tide/N2_flux_vh.mat')
Flux_x_D2 = Flux_x_D2 + Flux_x;
Flux_y_D2 = Flux_y_D2 + Flux_y;
%% flux interactions
% load('../内潮斜压流/Flux_M2_other.mat');
% % Flux_x_D2 = Flux_x;
% % Flux_y_D2 = Flux_y;
% Flux_x_D2 = Flux_x_D2 + Flux_x;
% Flux_y_D2 = Flux_y_D2 + Flux_y;
% load('../内潮斜压流/Flux_N2_other.mat');
% Flux_x_D2 = Flux_x_D2 + Flux_x;
% Flux_y_D2 = Flux_y_D2 + Flux_y;
% load('../内潮斜压流/Flux_S2_other.mat');
% Flux_x_D2 = Flux_x_D2 + Flux_x;
% Flux_y_D2 = Flux_y_D2 + Flux_y;


%% HKE
load('M2_HKE_h.mat','HKE_h');
HKE_h_D2 = HKE_h;
load('../N2_tide/N2_HKE_h.mat','HKE_h');
HKE_h_D2 = HKE_h_D2 + HKE_h;
load('../S2_tide/S2_HKE_h.mat','HKE_h');
HKE_h_D2 = HKE_h_D2 + HKE_h;
% load('../内潮斜压流/M2_S2_HKE.mat','HKE_h');
% % HKE_h_D2 = HKE_h;
% HKE_h_D2 = HKE_h_D2 + HKE_h;
% load('../内潮斜压流/M2_N2_HKE.mat','HKE_h');
% HKE_h_D2 = HKE_h_D2 + HKE_h;
% load('../内潮斜压流/S2_N2_HKE.mat','HKE_h');
% HKE_h_D2 = HKE_h_D2 + HKE_h;
%% APE
load('M2_APE_h.mat','APE_h');
APE_h_D2 = APE_h;
load('../N2_tide/N2_APE_h.mat','APE_h');
APE_h_D2 = APE_h_D2 + APE_h;
load('../S2_tide/S2_APE_h.mat','APE_h');
APE_h_D2 = APE_h_D2 + APE_h;
%%
iw = 30;ie = 1;
jn = 30;js = 30;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
% lonv_grid  = Exclude_sponge(iw,ie,jn,js,lonv_grid);
% latv_grid  = Exclude_sponge(iw,ie,jn,js,latv_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
HKE_h_D2 = HKE_h_D2.*depto_grid*1e-3; % KJ/m^2
HKE_h_D2(isnan(depto_grid)==1)=0;
APE_h_D2= APE_h_D2.*depto_grid*1e-3; % KJ/m^2
APE_h_D2(isnan(depto_grid)==1)=0;


u_flux = Flux_x_D2;
v_flux = Flux_y_D2;
u_flux = u_flux*1e-3.*depto_grid; % kw/m
v_flux = v_flux*1e-3.*depto_grid;
Flux_value =sqrt(u_flux.^2 + v_flux.^2 );

LONLIMS = [-26.5 -20.5];
LATLIMS = [14 18];

LONLIMS = [-25.5 -23];
LATLIMS = [14.7 17];
cg = Flux_value./(HKE_h_D2+APE_h_D2);
cg(isnan(cg)==1)=0;
%%
% figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])

F2 = axes('position',[0.41 0.53 0.6 0.42]);
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  

m_pcolor(lonp_grid,latp_grid,cg);shading interp;hold on;

m=colormap(F2,m_colmap('jet','step',10));
[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:3500],...
    'linewidth',1.5,'color',[.4 .4 .4]);hold on;
clabel(c,h,'LabelSpacing',1500,'color','k',...
    'fontsize',10,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')


% m=colormap(m_colmap('jet','step',10));
[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:3500],...
    'linewidth',1.5,'color',[.4 .4 .4]);hold on;
clabel(c,h,'LabelSpacing',1500,'color','k',...
    'fontsize',15,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')


clim([0 2.0])

% colormap(lansey)
 % colormap(jet)
% load('MPL_RdYlBu_r.mat');colormap(MPL_RdYlBu_r);clim([0 1])
% clim([0 6]);


bar = colorbar;set(bar,'fontsize',28,'fontname','Arial','Location','eastoutside','fontweight','bold','linewidth',2);hold on;
set(get(bar,'Title'),'string','m s^-^1','fontname','Arial','fontweight','bold','linewidth',2);

m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.5);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
set(gca,'Layer','top');

select_indicex = find(lonp_grid(:,1)>=-24.8 & lonp_grid(:,1)<=-24);
select_indicey = find(latp_grid(1,:)>=15.1 & latp_grid(1,:)<=16.45);



lon_sw  = lonp_grid(select_indicex,select_indicey);
lat_sw  = latp_grid(select_indicex,select_indicey);

m_plot(lon_sw(1,:),lat_sw(1,:),'k-','linewidth',1.5);hold on;
m_plot(lon_sw(end,:),lat_sw(end,:),'k-','linewidth',1.5);hold on;
m_plot(lon_sw(:,1),lat_sw(:,1),'k-','linewidth',1.5);hold on;
m_plot(lon_sw(:,end),lat_sw(:,end),'k-','linewidth',1.5);hold on;

% img=getframe(gcf);
% imwrite(img.cdata,['Fig7b.tiff'], 'tiff', 'Resolution', 300);
%%
% figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])

F1 = axes('position',[0.005 0.53 0.6 0.42]);
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
% m_pcolor(lonp_grid,latp_grid,(HKE_h_D2./APE_h_D2));shading interp;hold on;

nan_indicex = find(lonp_grid(:,1)>-23.5 & lonp_grid(:,1)<-23);
nan_indicey = find(latp_grid(1,:)>16.7 & latp_grid(1,:)<17);
APE_h_D2(nan_indicex,nan_indicey) = nan;
HKE_h_D2(nan_indicex,nan_indicey) = nan;
depto_grid(nan_indicex,nan_indicey) = nan;
clear nan_indicey nan_indicex




 m_contourf(lonp_grid,latp_grid,(APE_h_D2+HKE_h_D2),45,'LineStyle','none');
clim([0  8]);colormap(F1,lansey)
% load('hotres.mat');colormap(hotres)
% load('GMT_seis_r.mat');colormap(GMT_seis_r)

 m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.5);

% % lable
labelx = [-23.31,-23.11];labelz = [16.92,16.95];
labelu = [3,0];labelv=[0,0];

% u_flux(333:347,80:91)=nan;
% v_flux(333:347,80:91)=nan;

XX_pic = lonp_grid(2:4:end,2:4:end);
ZZ_pic = latp_grid(2:4:end,2:4:end);
UU_pic = u_flux(2:4:end,2:4:end); 
VV_pic = v_flux(2:4:end,2:4:end);

nan_indicex = find(XX_pic(:,1)>-23.5 & XX_pic(:,1)<-23);
nan_indicey = find(ZZ_pic(1,:)>16.7 & ZZ_pic(1,:)<17);
UU_pic(nan_indicex,nan_indicey) = nan;
VV_pic(nan_indicex,nan_indicey) = nan;

scale_auto = Get_Autoscale(XX_pic,ZZ_pic,UU_pic,VV_pic); 
scale_label = Get_Autoscale(labelx,labelz,labelu,labelv);
scale_factor = scale_auto/scale_label;

q_label= m_quiver(labelx,labelz,labelu,labelv,...
        1.5,'MaxHeadSize',1.2,'color','b','linewidth',1.8);
q_minus = m_quiver(XX_pic,ZZ_pic,UU_pic,VV_pic,...
         1.5/scale_factor,'MaxHeadSize',0.8,'color','k','linewidth',2.0);
set(q_minus,'MaxHeadSize',1.2);


% m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.5);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  

set(gca,'Layer','top');

bar = colorbar;set(bar,'fontsize',28,'fontname','Arial','Location','eastoutside','fontweight','bold','linewidth',2);hold on;
set(get(bar,'Title'),'string','kJ m^-^2','fontname','Arial','fontweight','bold','linewidth',2);

[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:3500],...
    'linewidth',1.5,'color',[.4 .4 .4]);hold on;
clabel(c,h,'LabelSpacing',1500,'color','k',...
    'fontsize',15,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')



annotation(figure(1),'textbox',...
    [[0.378589038248339 0.84709066305819 0.0893987666297107 0.0705548037889046]],...
    'String','3 kW m^-^1',...
    'LineStyle','none',...
    'FontSize',19,...
    'Color','b',...
    'FontName','Arial',...
    'fontweight','bold',...
    'FitBoxToText','off',...
    'EdgeColor','none') 
% annotation(figure(2),'rectangle',...
%     [0.778272727272727 0.123076923076923 0.0653636363636364 0.0492307692307692],...
%     'LineWidth',1.5);

% m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.5);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
set(gca,'Layer','top');

% img=getframe(gcf);
% imwrite(img.cdata,['Fig7a.tiff'], 'tiff', 'Resolution', 300);