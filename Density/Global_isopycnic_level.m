% Figure 2c
addpath ../Model_info/
%% From timeA to timeB
load('Time_info.mat', 'SDtime','LDTRUN','time_index')
S_time = datenum(2011,08,14,18,0,0);
E_time = datenum(2011,08,14,18,0,0);
t_s = find ( SDtime == S_time);
t_e = find ( SDtime == E_time);
%% Density coordinates
load('Density_coordinates.mat','R','KE')
R = R';
%%
load('Density_coordinates.mat', 'zao_ini')
%%
load('Grid_info.mat','latp_grid','lonp_grid','depto_grid');
iw = 1;ie = 1;
jn = 1;js = 1;
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
ie = size(depto_grid,1);
je = size(depto_grid,2);
zao = zeros(ie,je,KE);
zao_time = zeros(ie,je);
%% PIC
Save_Location = ['./zao/'];
load('NCV_bright.mat')
load('BlueDarkRed18.mat');
% 30海绵
load('Level1_domain.mat')
load('../Transect/CVOO_transect.mat','lat_line','lon_line');
% load('../Transect/NDS_transect.mat','lat_line','lon_line');
% figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',28,'fontname','Arial');
m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.5);

Lon_CVOO = -24.2497; Lat_CVOO = 17.6067;
m_plot(lon_line,lat_line,'k-','linewidth',2,'DisplayName','CVOO transect');hold on
m_plot([-26,-17.5],[16,16],'color','k','linestyle','-','linewidth',2,'DisplayName','16°N transect');hold on

% leg = legend('show','Autoupdate','off');
% set(leg,'Position',[0.148470915690572 0.0506272053192952 0.299739583333333 0.0363729508196721],...
%     'Orientation','horizontal',...
%     'FontSize',22,...
%     'FontName','Arial',...
%     'AutoUpdate','off','FontWeight','bold','linewidth',2.0)


m_plot(Lon_CVOO,Lat_CVOO,'ok','linewidth',2,'Markersize',15,'MarkerFaceColor','r'); hold on;

m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',28,'fontname','Arial');

k = 16; 
% 1 1024 
% 6 1025
% 11 1026
% 16 1027
% 21 1028
% figure(2)
% k=16;
% pcolor(lonp_grid,latp_grid,zao_ini(:,:,k)); shading interp
% aaaa = zao(:,:,k);
% aaaa_ini = zao_ini(:,:,k);

disp([num2str(R(k)+1000),'kg m^-^3']);
for t= t_s:1:t_e
    eval(['load ',Save_Location,'zao_',datestr(SDtime(t),30),'.mat'])

    zao_time = -zao(:,:,k) + zao_ini(:,:,k);
    % zao_time(zao_time==0)=nan;
    % clf
    m_pcolor(lonp_grid,latp_grid,zao_time);shading interp;
    clim([-9 9])
    colormap(BlueDarkRed18);
    % colormap(NCV_bright)
    % load('ncl_default.mat');colormap(ncl_default)
    % load('GMT_no_green.mat');colormap(GMT_no_green)
    % load('BlueWhiteOrangeRed.mat');colormap(BlueWhiteOrangeRed)
    % title([datestr(SDtime(t)),' at ',num2str(R(k)+1000),'kg m^-^3'],'fontname','Arial','fontsize',20)

    % m_gshhs_h('patch',[.8 .8 .8],'edgecolor','k','linewidth',1.5);

     h2=colorbar('location','eastOutside','fontsize',28,'FontWeight','bold');
    set(get(h2,'Title'),'string','km','fontname','Arial','fontsize',28);

    % h2=colorbar('location','eastOutside','fontsize',28);
    set(h2,'Ticks',[-9:2:9])
    % set(get(h2,'Title'),'string','m','fontname','Arial','fontweight','bold');

% clockwisely plot box
LONLIMS = [-26 -21.6];
LATLIMS = [14.4 17.5];
box_lon = [LONLIMS(1),LONLIMS(1),LONLIMS(2),LONLIMS(2),LONLIMS(1)];
box_lat = [LATLIMS(1),LATLIMS(2),LATLIMS(2),LATLIMS(1),LATLIMS(1)]
m_plot(box_lon,box_lat,'b-','linewidth',3);hold on



LONLIMS = [-18.5 -16];
LATLIMS = [15 18.4];
box_lon = [LONLIMS(1),LONLIMS(1),LONLIMS(2),LONLIMS(2)];
box_lat = [LATLIMS(1),LATLIMS(2),LATLIMS(2),LATLIMS(1)];
m_plot(box_lon,box_lat,'b-','linewidth',3.0);hold on

% 
m_plot(LONLIMS,[LATLIMS(1),LATLIMS(1)],'b-.','linewidth',3.0);hold on
LONLIMS = [-18.5 -16.0];
LATLIMS = [13 15];

box_lon = [LONLIMS(1),LONLIMS(1),LONLIMS(2),LONLIMS(2)];
box_lat = [LATLIMS(2),LATLIMS(1),LATLIMS(1),LATLIMS(2)];
m_plot(box_lon,box_lat,'b-','linewidth',3.);hold on
  
m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',28,'fontname','Arial');


m_plot(lon_line,lat_line,'k-','linewidth',3);hold on
m_plot([-26,-17.5],[16,16],'color','k','linestyle','-','linewidth',3,'DisplayName','16°N transect');hold on

m_plot(Lon_CVOO,Lat_CVOO,'ok','linewidth',1.5,'Markersize',15,'MarkerFaceColor','r'); hold on;

m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',28,'fontname','Arial');
m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1);

 
set(gca,'Layer','top')

img=getframe(gcf);
imwrite(img.cdata,['Figure2c.tiff'], 'tiff', 'Resolution', 300)


end