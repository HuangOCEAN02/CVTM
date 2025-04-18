% Figure 7c&d
% clear;clc;close all
% bottom pressure
load('M2_BC_tide_pbt.mat')
addpath ../Model_info/
addpath ../Transect/GRID_FUNCTIONS/
load('Grid_info.mat','ke','depto_grid','weto_p','latp_grid','lonp_grid','bottom_index');

iw = 30;ie = 1;
jn = 30;js = 30;

 depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
 % ddpo_grid  = Exclude_sponge(iw,ie,jn,js,ddpo_grid);
     weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
  latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
  lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
bottom_index = Exclude_sponge(iw,ie,jn,js,bottom_index);

ie = size(depto_grid,1);
je = size(depto_grid,2);

% LONLIMS = [min(min(lonp_grid)) max(max(lonp_grid))];
% LATLIMS = [min(min(latp_grid)) max(max(latp_grid))];

LONLIMS = [-26.5 -20.5];
LATLIMS = [14 18];
%% bottom pressure
AMPH = zeros(ie,je);
sigma = zeros(ie,je);
masko(:,:) = weto_p(:,:,1);
for i = 1:ie
    for j = 1:je
        if masko(i,j)~=0
            % AMPH(i,j) = pa(i,j,bottom_index(i,j));
            % sigma(i,j) = pg(i,j,bottom_index(i,j));
            AMPH(i,j) = pa(i,j);
            sigma(i,j) = pg(i,j);
        end
    end
end
% AMPH(masko==0)=nan;
sigma(masko==0)=nan;
% sigma(sigma>180) = (360 - sigma(sigma>180))*(-1); 
%% 
load('M2_BC_tide_velocity.mat');
uabt = zeros(ie,je);
ugbt = uabt;
vabt = uabt;vgbt = uabt;
for i = 1:ie
    for j = 1:je
        if bottom_index(i,j)~=0
            uabt(i,j) = ua(i,j,bottom_index(i,j));
            vabt(i,j)  = va(i,j,bottom_index(i,j));
            ugbt(i,j)  = ug(i,j,bottom_index(i,j));
            vgbt(i,j)  = vg(i,j,bottom_index(i,j));
        end
    end
end

 [SEMA,ECC,INC, PHA,]=ap2ep(uabt, ugbt, vabt, vgbt);


 load('CapeVerde_index.mat');
SEMA_cvs = SEMA(select_indicex,select_indicey);SEMA_cvs=SEMA_cvs*100;
ECC_cvs = ECC(select_indicex,select_indicey);
SEMI_cvs = SEMA_cvs.*ECC_cvs;

INC_cvs = INC(select_indicex,select_indicey);
PHA_cvs = PHA(select_indicex,select_indicey);

latp_cvs = latp_grid(select_indicex,select_indicey);
lonp_cvs = lonp_grid(select_indicex,select_indicey);
AMPH_cvs = AMPH(select_indicex,select_indicey);
depto_cvs = depto_grid(select_indicex,select_indicey);
SEMA_cvs(depto_cvs<3000)=nan;
% ECC_cvs(abs(ECC_cvs)<=0.001)=nan;
%% M2
load('NCV_jet.mat');
load('gui_default.mat')
load('WhiteBlueGreenYellowRed.mat')


LONLIMS = [-25.5 -23]+360;
LATLIMS = [14.7 17];

% 
lonp_cvs = lonp_cvs+360;
% figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])

F3 = axes('position',[0.005 0.035 0.6 0.42]);
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);


nan_indicex = find(lonp_cvs(:,1)>-23.5+360 & lonp_cvs(:,1)<-23+360 );
nan_indicey = find(latp_cvs(1,:)>16.7 & latp_cvs(1,:)<17);
AMPH_cvs(nan_indicex,nan_indicey) = nan;
depto_cvs(nan_indicex,nan_indicey) = nan;


m_pcolor(lonp_cvs,latp_cvs,AMPH_cvs);hold on;shading interp;hold on;
% m=colormap(m_colmap('jet','step',10));
% colormap(lansey)
colormap(WhiteBlueGreenYellowRed)
% m=colormap(m_colmap('jet','step',10));
clim([0 120])
hold on;

m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.5);

% Exclued  逆时针转时minor为正
XX_pic = lonp_cvs(2:5:end,2:5:end);
YY_pic = latp_cvs(2:5:end,2:5:end);
SEMA_grid = SEMA_cvs(2:5:end,2:5:end);
SEMI_grid = (SEMI_cvs(2:5:end,2:5:end));
INC_grid = INC_cvs(2:5:end,2:5:end);
PHA_grid = PHA_cvs(2:5:end,2:5:end);
ECC_grid = ECC_cvs(2:5:end,2:5:end);

% PHA_grid(SEMI_grid==0)=0;
% %clockwise
% SEMA_grid(ECC_grid >= 0)=nan;
% SEMI_grid(ECC_grid >= 0)=nan;
% PHA_grid(ECC_grid >= 0)=nan;
% INC_grid(ECC_grid >= 0)=nan;
% ECC_grid(ECC_grid >= 0)=nan;
% scale bar

nan_indicex = find(XX_pic(:,1)>-23.5+360 & XX_pic(:,1)<-23+360 );
nan_indicey = find(YY_pic(1,:)>16.7 & YY_pic(1,:)<17);
SEMA_grid(nan_indicex,nan_indicey) = nan;
SEMI_grid(nan_indicex,nan_indicey) = nan;

i_ellpise = nan_indicex(3);
j_ellpise = nan_indicey(2);
SEMA_grid(i_ellpise,j_ellpise) = 6;
SEMI_grid(i_ellpise,j_ellpise) = 0.002;
INC_grid(i_ellpise,j_ellpise) = 0;
PHA_grid(i_ellpise,j_ellpise) = 0;
%
%clockwise
[H_n]=m_ellipse_modify(XX_pic,YY_pic,...
                abs(SEMA_grid),(SEMI_grid),...
                (INC_grid),PHA_grid,...
                  60,'line','color','k','linewidth',2,'linestyle','-');

hold on;

% SEMA_grid = SEMA_cvs(2:5:end,2:5:end);
% SEMI_grid = abs(SEMI_cvs(2:5:end,2:5:end));
% INC_grid = INC_cvs(2:5:end,2:5:end);
% PHA_grid = PHA_cvs(2:5:end,2:5:end);
% ECC_grid = ECC_cvs(2:5:end,2:5:end);
% 
% SEMA_grid(ECC_grid < 0)=nan;
% SEMI_grid(ECC_grid < 0)=nan;
% PHA_grid(ECC_grid < 0)=nan;
% ECC_grid(ECC_grid < 0)=nan;
% 
% % anticlockwise
% [H_p]=m_ellipse(lonp_cvs(2:5:end,2:5:end),latp_cvs(2:5:end,2:5:end),...
%                 SEMA_grid,SEMI_grid,...
%                 INC_grid,PHA_grid,...
%                   45,'line','color','k','linewidth',1.5);
% hold on;


% m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.5);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  

% [c,h]=m_contour(lonp_cvs,latp_cvs,depto_cvs,[500:500:3500],...
%     'linewidth',0.5,'color',[.4 .4 .4]);hold on;
% clabel(c,h,'LabelSpacing',1500,'color','k',...
%     'fontsize',12,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')

bar = colorbar;set(bar,'fontsize',28,'fontname','Arial','Location','eastoutside','fontweight','bold','linewidth',2);hold on;
set(get(bar,'Title'),'string','kg m^-^1 s^-^2','fontname','Arial','fontweight','bold','linewidth',2);

m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  

set(gca,'Layer','top','fontweight','bold');

annotation(figure(1),'textbox',...
    [0.369116778437785 0.365782251843236 0.0893987666297107 0.0705548037889045],...
    'Color',[0 0 1],...
    'String','6 cm s^-^1',...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',19,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'EdgeColor','none');


% img=getframe(gcf);
% imwrite(img.cdata,['CV_M2_Pressure_Amp.tiff'], 'tiff', 'Resolution', 300)
% 




% figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
F4 =axes('position',[0.41 0.035 0.6 0.42]);
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
lonp_grid = lonp_grid+360;

sigma1=sigma;
sigma1 (sigma1<20)=nan;
m_contourf(lonp_grid,latp_grid,sigma1,[5:5:360],'linestyle','none');hold on;
sigma2 = sigma;
sigma2(sigma2>30)=nan;
m_contourf(lonp_grid,latp_grid,sigma2,[0:1:5],'linestyle','none');hold on;
clim([0 360])
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  


% colormap(WhiteBlueGreenYellowRed)
load('wh_bl_gr_ye_re.mat');colormap(wh_bl_gr_ye_re)
[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:3500],...
    'linewidth',1.5,'color',[.4 .4 .4]);hold on;
clabel(c,h,'LabelSpacing',1500,'color','k',...
    'fontsize',15,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')

clim([30 330])
% 
% m=colormap(m_colmap('jet','step',10));
bar = colorbar;set(bar,'fontsize',28,'fontname','Arial','Location','eastoutside','fontweight','bold','linewidth',2);hold on;
set(get(bar,'Title'),'string','°','fontname','Arial','fontweight','bold','linewidth',2);

m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.5);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  

set(gca,'Layer','top','fontweight','bold');


img=getframe(gcf);
imwrite(img.cdata,['Figure7down.tiff'], 'tiff', 'Resolution', 300);