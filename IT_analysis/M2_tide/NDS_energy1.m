% Figure12 up 1
clear;clc;close all
%% Gird
addpath ../Model_info/
load('Grid_info.mat','ie_g','je_g','ke','lonp_grid','latp_grid');
load('Grid_info.mat','weto_p','depto_grid','zzout');
iw = 30;ie = 1;
jn = 30;js = 30;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);

%%
load('Grid_resolution.mat', 'dlxp')
load('Grid_resolution.mat', 'dlyp')
dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
load('./M2_flux_uh.mat');
load('./M2_flux_vh.mat');
load('./M2_conversion.mat');
load('./M2_Flux_Divergence.mat');
R = Div_F - C;
Flux_x = Flux_x*1e-3.*depto_grid;
Flux_y = Flux_y*1e-3.*depto_grid;
F_mag = sqrt(Flux_x.^2+Flux_y.^2);
%%
LONLIMS = [-21 -15];
LATLIMS = [12.6 18.6];

%% domain
select_indicex = find(lonp_grid(:,1)>=-18.5 & lonp_grid(:,1)<=-16);
select_indicey = find(latp_grid(1,:)>=15 & latp_grid(1,:)<=18.4);


C_MSS = C(select_indicex,select_indicey);
R_MSS = R(select_indicex,select_indicey);
DIF_F_MSS = Div_F(select_indicex,select_indicey);
F_mag_MSS = F_mag(select_indicex,select_indicey);

lat_MSS = latp_grid(select_indicex,select_indicey);
lon_MSS = lonp_grid(select_indicex,select_indicey);

dlxp_MSS = dlxp(select_indicex,select_indicey);
dlyp_MSS = dlyp(select_indicex,select_indicey);

depto_MSS = depto_grid(select_indicex,select_indicey);

cvie = length(select_indicex);
cvje = length(select_indicey);

depto_MSS = reshape(depto_MSS,[cvie*cvje,1]);
dlxp_MSS = reshape(dlxp_MSS,[cvie*cvje,1]);
dlyp_MSS = reshape(dlyp_MSS,[cvie*cvje,1]);

C_MSS = reshape(C_MSS,[cvie*cvje,1]);
R_MSS = reshape(R_MSS,[cvie*cvje,1]);
DIF_F_MSS = reshape(DIF_F_MSS,[cvie*cvje,1]);
F_mag_MSS = reshape(F_mag_MSS,[cvie*cvje,1]);
% remove nan
[R_MSS,inx_nan]= rmmissing(R_MSS);
C_MSS(inx_nan)=[];
DIF_F_MSS(inx_nan)=[];

depto_MSS(inx_nan)=[];
dlxp_MSS(inx_nan)=[];
dlyp_MSS(inx_nan)=[];

% sort
[depto_MSS_x,inx] = sort(depto_MSS,'ascend');

C_MSS = C_MSS(inx); % W/m2
R_MSS = R_MSS(inx); % W/m2
DIF_F_MSS = DIF_F_MSS(inx);  % W/m2
F_mag_MSS = F_mag_MSS(inx); % W/m3

dlyp_MSS = dlyp_MSS(inx); % W/m2
dlxp_MSS = dlxp_MSS(inx); % W/m2

C_MSS = C_MSS.*dlxp_MSS.*dlyp_MSS;
R_MSS = R_MSS.*dlxp_MSS.*dlyp_MSS;
DIF_F_MSS = DIF_F_MSS.*dlxp_MSS.*dlyp_MSS;

%0m-3500m
inteval = 100;
3500/50;
for iiz = 1:1:3500/inteval

    up =  (iiz-1)*inteval;
    dow = (iiz)*inteval;

    dpe(iiz) = (up+dow)./2

    C_diag(iiz,1) = nansum(C_MSS(depto_MSS_x<=dow & depto_MSS_x>up));
    R_diag(iiz,1) = nansum(R_MSS(depto_MSS_x<=dow & depto_MSS_x>up));
    DF_diag(iiz,1) = nansum(DIF_F_MSS(depto_MSS_x<=dow & depto_MSS_x>up));
    % F_diag(iiz,1) = nansum(F_mag_CV(depto_MSS_x<=dow & depto_MSS_x>up));


    C_diag(iiz,2) = nanmean(C_MSS(depto_MSS_x<=dow & depto_MSS_x>up));
    R_diag(iiz,2) = nanmean(R_MSS(depto_MSS_x<=dow & depto_MSS_x>up));
    DF_diag(iiz,2) = nanmean(DIF_F_MSS(depto_MSS_x<=dow & depto_MSS_x>up));
    % F_diag(iiz,2) = nanmean(F_mag_CV(depto_MSS_x<=dow & depto_MSS_x>up));

end


% 累计
inteval = 10;
3500/50;
for iiz = 1:1:3500/inteval

    up =  (iiz-1)*inteval;
    dow = (iiz)*inteval;

    dpe_continue(iiz) = (up+dow)./2;

    C_continue(iiz,1) = nansum(C_MSS(depto_MSS_x<=dow & depto_MSS_x>up));
    R_continue(iiz,1) = nansum(R_MSS(depto_MSS_x<=dow & depto_MSS_x>up));
    % DF_diag(iiz,1) = nansum(DIF_F_CV(depto_MSS_x<=dow & depto_MSS_x>up));
    % F_diag(iiz,1) = nansum(F_mag_CV(depto_MSS_x<=dow & depto_MSS_x>up));


    C_continue(iiz,2) = nanmean(C_MSS(depto_MSS_x<=dow & depto_MSS_x>up));
    R_continue(iiz,2) = nanmean(R_MSS(depto_MSS_x<=dow & depto_MSS_x>up));
    % DF_diag(iiz,2) = nanmean(DIF_F_CV(depto_MSS_x<=dow & depto_MSS_x>up));
    % F_diag(iiz,2) = nanmean(F_mag_CV(depto_MSS_x<=dow & depto_MSS_x>up));

end

C_continue = C_continue.*1e-6;
R_continue = R_continue.*1e-6;

C_continue(isnan(C_continue)==1)=0;
R_continue(isnan(R_continue)==1)=0;

C_sum = cumsum(C_continue);
R_sum = cumsum(R_continue);

C_diag(:,:) = C_diag(:,:).*1e-6;
DF_diag(:,:) = DF_diag(:,:).*1e-6;
R_diag(:,:) = R_diag(:,:).*1e-6;


% 累计 winter
load('../../Winter_Stratification/IT_analysis/M2_tide/M2_Flux_Divergence.mat');
load('../../Winter_Stratification/IT_analysis/M2_tide/M2_conversion.mat');
load('../../Winter_Stratification/IT_analysis/M2_tide/M2_flux_uh.mat');
load('../../Winter_Stratification/IT_analysis/M2_tide/M2_flux_vh.mat');
C_winter = C;
Div_F_winter = Div_F;
Flux_strength_winter = sqrt(Flux_x.^2+ Flux_y.^2);
R_winter = Div_F_winter - C_winter;
clear C Div_F Flux_x Flux_y

C_MSS_winter = C_winter(select_indicex,select_indicey);
R_MSS_winter = R_winter(select_indicex,select_indicey);
DIF_F_MSS_winter = Div_F_winter(select_indicex,select_indicey);



C_MSS_winter = reshape(C_MSS_winter,[cvie*cvje,1]);
R_MSS_winter = reshape(R_MSS_winter,[cvie*cvje,1]);
DIF_F_MSS_winter = reshape(DIF_F_MSS_winter,[cvie*cvje,1]);

[R_MSS_winter,inx_nan]= rmmissing(R_MSS_winter);
C_MSS_winter(inx_nan)=[];
DIF_F_MSS_winter(inx_nan)=[];

C_MSS_winter = C_MSS_winter(inx);
R_MSS_winter = R_MSS_winter(inx);
DIF_F_MSS_winter = DIF_F_MSS_winter(inx);

C_MSS_winter = C_MSS_winter.*dlxp_MSS.*dlyp_MSS;
R_MSS_winter = R_MSS_winter.*dlxp_MSS.*dlyp_MSS;
DIF_F_MSS_winter = DIF_F_MSS_winter.*dlxp_MSS.*dlyp_MSS;






inteval = 10;
3500/50;
for iiz = 1:1:3500/inteval

    up =  (iiz-1)*inteval;
    dow = (iiz)*inteval;

    dpe_continue(iiz) = (up+dow)./2;

    C_winter_continue(iiz,1) = nansum(C_MSS_winter(depto_MSS_x<=dow & depto_MSS_x>up));
    R_winter_continue(iiz,1) = nansum(R_MSS_winter(depto_MSS_x<=dow & depto_MSS_x>up));
    % DF_diag(iiz,1) = nansum(DIF_F_CV(depto_MSS_x<=dow & depto_MSS_x>up));
    % F_diag(iiz,1) = nansum(F_mag_CV(depto_MSS_x<=dow & depto_MSS_x>up));


    C_winter_continue(iiz,2) = nanmean(C_MSS_winter(depto_MSS_x<=dow & depto_MSS_x>up));
    R_winter_continue(iiz,2) = nanmean(R_MSS_winter(depto_MSS_x<=dow & depto_MSS_x>up));
    % DF_diag(iiz,2) = nanmean(DIF_F_CV(depto_MSS_x<=dow & depto_MSS_x>up));
    % F_diag(iiz,2) = nanmean(F_mag_CV(depto_MSS_x<=dow & depto_MSS_x>up));

end

C_winter_continue = C_winter_continue.*1e-6;
R_winter_continue = R_winter_continue.*1e-6;

C_winter_continue(isnan(C_winter_continue)==1)=0;
R_winter_continue(isnan(R_winter_continue)==1)=0;

C_winter_sum = cumsum(C_winter_continue);
R_winter_sum = cumsum(R_winter_continue);

%%
figure(3);clf;set(gcf,'color','w');
set(gcf,'position',[10 10 1200 300]);
yyaxis left;
barh = bar(dpe,[C_diag(:,1)';DF_diag(:,1)';R_diag(:,1)']);hold on;
set(barh(1),'Facecolor',[0.00,0.79,0.25],'Linewidth',1.5,'DisplayName','Conversion');
set(barh(2),'Facecolor',[0.30,0.75,0.93],'Linewidth',1.5,'DisplayName','Radiation');
set(barh(3),'Facecolor',[0.91,0.91,0.14],'Linewidth',1.5,'DisplayName','Dissipation');
set(barh,'Linewidth',1.5,'Barwidth',1);
xlim([10 2500])
ylim([-25 10])
set(gca,'fontsize',25,'fontname','Arial');
set(gca,'xlim',[0 2000],'XTick',[0:100:2000],'fontname','Arial','fontweight','bold');
set(gca,'xlim',[0 2000],'XTick',[0:100:2000],'fontname','Arial','fontweight','bold',...
    'XTickLabel',{' '});
set(gca,'Layer','top','linewidth',2,'Gridalpha',0.1);grid on
set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2)

ylabel([' Power\newline ' ...
    ' $(MW)$'],'Interpreter','latex','Rotation',90,'FontSize',28,'FontWeight','bold','fontname','Arial')
set(gca,'YColor','k')
leg = legend('AutoUpdate','off');
set(leg,'Orientation','horizontal','Location','north',...
    'Position',[0.450833333333334 0.313333333333334 0.425 0.108333333333333],...
    'EdgeColor','k',...
    'Color','w','fontsize',25)

yyaxis right;
plot(dpe_continue,C_sum(:,1),'LineWidth',2,'linestyle','-','Color',[0.00,0.79,0.25]);hold on;
plot(dpe_continue,R_sum(:,1),'LineWidth',2,'linestyle','-','Color',[0.91,0.91,0.14]);hold on;

plot(dpe_continue,C_winter_sum(:,1),'LineWidth',2,'linestyle','-.','Color',[0.00,0.79,0.25]);hold on;
plot(dpe_continue,R_winter_sum(:,1),'LineWidth',2,'linestyle','-.','Color',[0.91,0.91,0.14]);hold on;

plot(dpe,linspace(0,0,length(dpe)),'linestyle','-','LineWidth',2,'Color',[0 0 0],'Marker','none');hold on;
set(gca,'ylim',[-90 90],'YTick',[-90:30:90],'fontname','Arial','fontweight','bold');
ylabel([' Cumulation  \newline ' ...
    ' $(MW)$'],'Interpreter','latex','Rotation',90,'FontSize',28,'FontWeight','bold','fontname','Arial')
set(gca,'YColor','k')

img=getframe(gcf);
imwrite(img.cdata,['BC_M2_energy_NDS_topo1.tiff'], 'tiff', 'Resolution', 300)
