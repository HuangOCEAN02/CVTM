%Figure5ef
clear;clc;close all
addpath ../../Model_info/
load('Grid_info.mat','ie_g','je_g','ke','lonp_grid','latp_grid');
load('Grid_info.mat','weto_p','depto_grid','zzout');
%%
load('M2_APE_h.mat')
load('M2_HKE_h.mat')
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
HKE_h = HKE_h.*depto_grid*1e-3; % KJ/m^2
HKE_h(isnan(depto_grid)==1)=0;
LONLIMS = [-26.5 -20.5];
LATLIMS = [14 18];
figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
% figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
% m_proj('miller','lon',[0 180],'lat',[10 50]);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;
% m_eez('Cape Verde');
m_pcolor(lonp_grid,latp_grid,HKE_h);shading interp;hold on;
% m_contourf(lonp_grid,latp_grid,HKE_h,40,'linestyle','none');hold on;
[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:4000],...
    'linewidth',1.0,'color',[.4 .4 .4]);hold on;
clabel(c,h,'LabelSpacing',1500,'color','k',...
    'fontsize',10,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')

% load('sunshine_9lev.mat');colormap(sunshine_9lev)
% load('rh_19lev.mat');colormap(rh_19lev);hold on;
load('WhiteBlueGreenYellowRed.mat')
colormap(WhiteBlueGreenYellowRed)
load('GMT_seis_r.mat');colormap(GMT_seis_r)
% colormap(lansey)
 % colormap(jet)
% load('MPL_RdYlBu_r.mat');colormap(MPL_RdYlBu_r)clim([0 1])
clim([0 3])
bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold');hold on;
set(get(bar,'Title'),'string','kJ m^-^2','fontname','Arial','fontweight','bold');
% m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);

%%
% u_flux = Flux_x;
% v_flux = Flux_y;
% u_flux = u_flux*1e-3.*depto_grid; % kw/m
% v_flux = v_flux*1e-3.*depto_grid;
% 
% % lable
% labelx = [-21.0,-20.8];labelz = [14.25,14.3];
% labelu = [5,0];labelv=[0,0];
% 
% % u_flux(333:347,80:91)=nan;
% % v_flux(333:347,80:91)=nan;
% 
% XX_pic = lonp_grid(2:5:end,2:5:end);
% ZZ_pic = latp_grid(2:5:end,2:5:end);
% UU_pic = u_flux(2:5:end,2:5:end); 
% VV_pic = v_flux(2:5:end,2:5:end);
% 
% UU_pic(69:75,60:64)=nan;
% VV_pic(69:75,60:64)=nan;
% 
% scale_auto = Get_Autoscale(XX_pic,ZZ_pic,UU_pic,VV_pic); 
% scale_label = Get_Autoscale(labelx,labelz,labelu,labelv);
% scale_factor = scale_auto/scale_label;
% 
% q_label= m_quiver(labelx,labelz,labelu,labelv,...
%         1.2,'MaxHeadSize',0.8,'color','k','linewidth',1.5);
% q_minus = m_quiver(XX_pic,ZZ_pic,UU_pic,VV_pic,...
%         1.2/scale_factor,'MaxHeadSize',0.8,'color','k','linewidth',1.2);
% set(q_minus,'MaxHeadSize',0.8);


m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;
set(gca,'Layer','top','fontweight','bold');
% 
% img=getframe(gcf);
% imwrite(img.cdata,['CVS_M2energy_HKE.tiff'], 'tiff', 'Resolution', 300)

%% APE

LONLIMS = [-26.5 -20.5];
LATLIMS = [14 18];

APE_h = APE_h.*depto_grid*1e-3; % KJ/m^2
% APE_h(depto_grid==0)=0;
APE_h(isnan(depto_grid)==1)=0;

figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

% m_pcolor(lonp_grid,latp_grid,APE_h./HKE_h);shading interp;hold on;
% clim([0 1])


figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;
m_pcolor(lonp_grid,latp_grid,APE_h);shading interp;hold on;

[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:4000],...
    'linewidth',1.0,'color',[.4 .4 .4]);hold on;
clabel(c,h,'LabelSpacing',1500,'color','k',...
    'fontsize',10,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')


% load('NCV_jet.mat');colormap(NCV_jet);hold on;
load('GMT_seis_r.mat');colormap(GMT_seis_r)
% load('rh_19lev.mat');colormap(rh_19lev);hold on;
load('hotres.mat');colormap(hotres)
% load('NCV_bright.mat');colormap(NCV_bright);

clim([0 8]);
bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold');hold on;
set(get(bar,'Title'),'string','kJ m^-^2','fontname','Arial','fontweight','bold');
% m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);


m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;

set(gca,'Layer','top','fontweight','bold');

i_index = 132;
m_plot(lonp_grid(i_index,155:236),latp_grid(i_index,155:236),'linewidth',1.5,'linestyle','-','color','k');hold on;
% img=getframe(gcf);
% imwrite(img.cdata,['CVS_M2energy_APE.tiff'], 'tiff', 'Resolution', 300)

