% Figure5b
clear;clc;close all
addpath ../Model_info/
load('Grid_info.mat','latp_grid','lonp_grid','depto_grid');
load('Grid_resolution.mat', 'dlxu')
load('Grid_resolution.mat', 'dlyv')

load('BlueWhiteOrangeRed.mat');
load('MPL_blues.mat');
load('MPL_Greys.mat');
load('MPL_GnBu.mat');
%% From timeA to timeB
load('Time_info.mat', 'SDtime','LDTRUN','time_index')
S_time = datenum(2011,08,14,18,0,0);
E_time = datenum(2011,08,14,18,0,0);
t_s = find ( SDtime == S_time);
t_e = find ( SDtime == E_time);
Dtime = 3600;
%%
iw = 30;ie = 1;
jn = 30;js = 30;
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);

dlxu  = Exclude_sponge(iw+1,ie,jn,js,dlxu);
dlyv  = Exclude_sponge(iw,ie,jn+1,js,dlyv);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
LATLIMS = [min(min(latp_grid)) max(max(latp_grid))];
LONLIMS = [min(min(lonp_grid)) max(max(lonp_grid))];

load('CVS_domain.mat')
load('CVOO_site.mat')
figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
% m_grid('linestyle','none','linewidth',1.5,'fontsize',16,'fontname','Arial',...
%     'xtick',8,'tickdir','in');hold on;
m_plot(Lon_CVOO,Lat_CVOO,'ok','linewidth',2,'Markersize',15,'MarkerFaceColor','r',...
    'DisplayName','CVOO'); hold on;
leg = legend('show','Autoupdate','off');
set(leg,'Position',[0.73648004358465 0.137279744240117 0.112272727272727 0.0546153846153846],...
    'Orientation','horizontal',...
    'FontSize',28,...
    'FontName','Arial',...
    'AutoUpdate','off','FontWeight','bold','linewidth',2.0)
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  

Location = ['../data/'];
for t= t_s:1:t_e
 if (LDTRUN(t)<10)
         name_z = [Location,'zoo/ZOO_0000000',num2str(LDTRUN(t)),'.nc'];
     else if(LDTRUN(t) < 100)
         name_z = [Location,'zoo/ZOO_000000',num2str(LDTRUN(t)),'.nc'];
       else if(LDTRUN(t) < 1000)
            name_z = [Location,'zoo/ZOO_00000',num2str(LDTRUN(t)),'.nc'];
        else if(LDTRUN(t) < 10000)
            name_z = [Location,'zoo/ZOO_0000',num2str(LDTRUN(t)),'.nc'];
          else if(LDTRUN(t) < 100000)
           name_z = [Location,'zoo/ZOO_000',num2str(LDTRUN(t)),'.nc'];
          else if(LDTRUN(t) < 1000000)
            name_z = [Location,'zoo/ZOO_00',num2str(LDTRUN(t)),'.nc'];
          end
          end
        end
      end
     end
 end
    disp([datestr(SDtime(t))])

    eta = ncread(name_z,'ZOO',[iw+1 jn+1],[ie,je]);

    [dyEta,dxEta] = gradient(eta);

    dxEta = dxEta./dlxu;
    dyEta = dyEta./dlyv;

    SSVD(:,:) = sqrt(dxEta.^2 + dyEta.^2);


   % clf
    m_pcolor(lonp_grid,latp_grid,SSVD);shading interp;hold on;
    % load('BlueWhiteOrangeRed.mat');colormap(BlueWhiteOrangeRed)
    % load('MPL_Blues.mat');colormap(MPL_Blues)
    % load('MPL_Greys.mat');colormap(MPL_Greys)
    % load('hotres.mat'); colormap(hotres);hold on;
    load('MPL_BuPu.mat'); colormap(MPL_BuPu);hold on;
    % load('MPL_Purples.mat'); colormap(MPL_Purples);hold on;
    clim([0 0.5E-5])

    % title([datestr(SDtime(t)),' SSHG'],'fontname','Arial','fontsize',20)

    bar = colorbar;
    set(bar,'fontsize',28,'fontname','Arial','Location','eastoutside','fontweight','bold');hold on;
    set(bar,'LineWidth',2)

    m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  

    m_plot(Lon_CVOO,Lat_CVOO,'ok','linewidth',2.5,'Markersize',15,'MarkerFaceColor','r'); hold on;

    set(gca,'Layer','top','fontweight','bold');

    img=getframe(gcf);
    imwrite(img.cdata,['Fig5b.tiff'], 'tiff', 'Resolution', 300)

end

