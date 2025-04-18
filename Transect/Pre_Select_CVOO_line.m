clear;clc;close all
%%
% 150 171
addpath ../Model_info/
addpath ./GRID_FUNCTIONS/
% addpath /gxfs_work/geomar/smomw557/BC_exp/Eight/Summer_new/Density
%% From timeA to timeB
% load('Time_info.mat', 'SDtime','LDTRUN','time_index')
% S_time = datenum(2011,08,01,0,0,0);
% E_time = datenum(2011,08,31,23,0,0);
% % S_time = datenum(2011,07,10,0,0,0);
% % E_time = datenum(2011,07,24,23,0,0);
% t_s = find ( SDtime == S_time);
% t_e = find ( SDtime == E_time);
%%
load('Grid_info.mat','ke','weto_p','depto_grid','zzout');
load('Grid_info.mat', 'lonp_grid')
load('Grid_info.mat', 'latp_grid');
iw = 30;ie = 1;
jn = 30;js = 30;
% weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
% zzout  = Exclude_sponge(iw,ie,jn,js,zzout);
% ddpo_grid  = Exclude_sponge(iw,ie,jn,js,ddpo_grid);
% lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
% latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
% depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
ie = size(depto_grid,1);
je = size(depto_grid,2);
% load('../内潮起伏/Diag_info.mat','I_index','J_index');
% CVOO
I_index(1) = 166;
J_index(1) = 110;
% SN strait
index_i_SN = 151;
index_j_SN = 173;
%%
LONLIMS = [-25.8 -22.3];
LATLIMS = [13.6 18.4];
%% enlarge area
eps = 1e-2;
[i_end,~] = find(abs(LONLIMS(2) - lonp_grid(:,1)) <=eps);
[i_start,~] = find(abs(LONLIMS(1) - lonp_grid(:,1)) <=eps);       

[~,j_end] = find(abs(LATLIMS(1) - latp_grid(1,:)) <=eps);
[~,j_start] = find(abs(LATLIMS(2) - latp_grid(1,:)) <=eps);   

lon_index = [i_start(1)-1:1:i_end(end)+1];
lat_index = [j_start(1)-1:1:j_end(end)+1];

Lon_area = lonp_grid(lon_index,lat_index);
Lat_area = latp_grid(lon_index,lat_index);
depth_area = depto_grid(lon_index,lat_index);
weto_area = weto_p(lon_index,lat_index,:);
zzout_area = zzout(lon_index,lat_index,:);


figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
 m_pcolor(Lon_area,Lat_area,depth_area);shading interp;hold on;

m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);
h2=colorbar('location','eastOutside','fontsize',16,'fontweight','bold');
% set(get(h2,'Title'),'string','SSHG','fontname','Arial');
m_grid('linestyle','none','linewidth',1.5,'fontsize',16,'fontname','Arial',...
    'xtick',8,'tickdir','in');hold on;
%% Transect 
lat_select = [latp_grid(index_i_SN,index_j_SN),latp_grid(I_index(1),J_index(1))];
lon_select = [lonp_grid(index_i_SN,index_j_SN),lonp_grid(I_index(1),J_index(1))];

diff(lat_select)/diff(lon_select);
theta = atan2d(diff(lat_select),diff(lon_select)) + 90; % with plus y-axis 
P = polyfit(lon_select,lat_select,1);
atand(P(1)) 
theta - 90 
lon_s = -25.05;
lon_e = lon_select(end)+0.1;

lon_line = [lon_s:0.015:lon_e]';
lat_line = polyval(P,lon_line);

eps=1e-2;
kk_sn = find(abs(lon_line - lon_select(1))<=eps);
kk_sn = 37;

kk_cvoo = find(abs(lon_line - lon_select(2))<=eps);
kk_cvoo = 54;

sw_dist(lat_line([kk_cvoo,kk_sn]),lon_line([kk_cvoo,kk_sn]),'km')
sw_dist(lat_line([20,kk_sn]),lon_line([20,kk_sn]),'km')


m_plot(lon_line,lat_line,'-','linewidth',1.5);hold on;
m_plot(lon_select,lat_select,'ok','linewidth',1.5,'Markersize',8,'MarkerFaceColor','r');

figure(2);clf;
plot(lon_line,lat_line,'-','linewidth',1.5);hold on;
plot(lon_select,lat_select,'ok','linewidth',1.5,'Markersize',8,'MarkerFaceColor','r');
%plot(-24.75,15.5927,'ok','linewidth',1.5,'Markersize',8,'MarkerFaceColor','r');

lat_select(3) = lat_line(20);
lon_select(3) =  lon_line(20);

sw_dist(lat_select,lon_select)

ie =size(Lat_area,1);
je =size(Lat_area,2);
le = length(lon_line);
land = zeros(ie,je,ke);land(weto_area==0)=1;
zzout_line = zeros(le,ke);

Depth_line = BLN2HOP_new(ie,je,le,1,Lat_area,Lon_area,...
      lat_line,lon_line,depth_area,land(:,:,1));

for k = 1:ke
    zzout_area(:,:,k) = DIFFUSION_LAND(zzout_area(:,:,k),~land(:,:,k));
    zzout_line(:,k) = BLN2HOP_new(ie,je,le,1,Lat_area,Lon_area,...
      lat_line,lon_line,zzout_area(:,:,k),land(:,:,k));
end



figure(2);clf
plot(lat_line,Depth_line)
set(gca,'Layer','top');grid off;
set(gca,'GridLineStyle','-.','GridColor',[.2 .2 .2]','GridAlpha',0.2)
ylabel('Depth (m)','fontsize',15,'fontname','Arial')
xlabel('Lat (°N)','fontsize',15,'fontname','Arial')    
area(lat_line,Depth_line,'FaceColor',[.6 .6 .6],'BaseValue',max(Depth_line),'LineWidth',2);hold on
xlim([lat_line(1),lat_line(end)]);ylim([0, max(Depth_line)]);    
set(gca,'fontsize',15,'XTick',[lat_line(1):0.2:lat_line(end)],'LineWidth',2,'fontname','Arial',...
    'YTick',[0:500:4500],'Ydir','reverse','Xaxislocation','bottom','fontweight','bold');   

save CVOO_transect.mat lon_line lat_line Depth_line P theta lon_index lat_index zzout_line