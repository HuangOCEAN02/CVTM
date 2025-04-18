% clear;clc;close all
% Fig2d
addpath ../Model_info/
load('Grid_info.mat','ie_g','je_g','ke','lonp_grid','latp_grid');
load('Grid_info.mat','weto_p','depto_grid','zzout');
load('Linear_conversion_rate.mat') % C_linear
load('Linear_flux.mat') % Flux_u Flux_v
%%
iw = 30;ie = 1;
jn = 30;js = 30;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);

ie = size(depto_grid,1);
je = size(depto_grid,2);
% colormap(jet)

%%
LONLIMS = [min(min(lonp_grid)) max(max(lonp_grid))];
LATLIMS = [min(min(latp_grid)) max(max(latp_grid))];

% LONLIMS = [-26.5 -20.5];
% LATLIMS = [14 18];

% figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',28,'fontname','Arial');
m_pcolor(lonp_grid,latp_grid,C_linear);shading interp;hold on;


[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:4000],...
    'linewidth',0.4,'color',[.4 .4 .4]);hold on;
% clabel(c,h,'LabelSpacing',1500,'color',[.4 .4 .4],...
%     'fontsize',20,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
% 
% 
% load('BlueWhiteOrangeRed.mat');colormap(F4,BlueWhiteOrangeRed);hold on;
% load('NCV_jaisnd.mat');colormap(NCV_jaisnd);hold on;
% load('nrl_sirkes.mat');colormap(nrl_sirkes);hold on;
load('NCV_blue_red.mat');colormap(NCV_blue_red);hold on;
clim([-0.1 0.1])
bar = colorbar;set(bar,'fontsize',28,'FontWeight','bold','Location','eastoutside');hold on;
set(get(bar,'Title'),'string','W m^-^2','fontname','Arial','fontsize',28);
set(bar,'Ticks',[-0.1:0.025:0.1])


m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);
%%
u_flux = Flux_u; % velocity[m/s]*pressure[kg/(m*s^2)] = kg/s^3
v_flux = Flux_v; % (kg*m^2/s^3) * (m^-2) = W m^-2
u_flux = u_flux*1e-3.*depto_grid; % KW/m
v_flux = v_flux*1e-3.*depto_grid;

% lable
labelx = [-15.5,-15.3];labelz = [17.7,17.8];
labelu = [3,0];labelv=[0,0];

% u_flux(333:347,80:91)=nan;
% v_flux(333:347,80:91)=nan;

XX_pic = lonp_grid(2:15:end,2:15:end);
ZZ_pic = latp_grid(2:15:end,2:15:end);
UU_pic = u_flux(2:15:end,2:15:end); 
VV_pic = v_flux(2:15:end,2:15:end);

scale_auto = Get_Autoscale(XX_pic,ZZ_pic,UU_pic,VV_pic); 
scale_label = Get_Autoscale(labelx,labelz,labelu,labelv);
scale_factor = scale_auto/scale_label;

q_label= m_quiver(labelx,labelz,labelu,labelv,...
        5.5,'MaxHeadSize',1.5,'color','b','linewidth',1.5);
q_minus = m_quiver(XX_pic,ZZ_pic,UU_pic,VV_pic,...
        5.5/scale_factor,'MaxHeadSize',0.8,'color','k','linewidth',1.5);
set(q_minus,'MaxHeadSize',1.5);


m_grid('linestyle','none','linewidth',1.5,'fontsize',28,'fontname','Arial');hold on;  


set(gca,'Layer','top','fontweight','bold');


annotation(figure(1),'textbox',...
    [0.805493371212121 0.382459016393443 0.0633039772727265 0.0384615384615391],...
    'String','3 kW m^-^1',...
    'LineStyle','none',...
    'FontSize',22,...
    'fontweight','bold',...
    'FontName','Arial',...
    'FitBoxToText','off');   

annotation(figure(1),'rectangle',...
    [0.790104166666667 0.359631147540985 0.0591666666666668 0.0532786885245902],...
        'LineWidth',2);

Lon_CVOO = -24.2497;
Lat_CVOO = 17.6067;
m_plot(Lon_CVOO,Lat_CVOO,'ok','linewidth',1.5,'Markersize',15,'MarkerFaceColor','r',...
    'DisplayName','CVOO mooring'); hold on;
m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',28,'fontname','Arial');
set(gca,'Layer','top')

img=getframe(gcf);
imwrite(img.cdata,['Fig2d.tiff'], 'tiff', 'Resolution', 300)
