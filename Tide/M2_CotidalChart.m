% Figure2b

load('res_eta_level1_CV.mat')
ie = 817; je = 619;
spongee = 0;
spongew = 30;
spongen = 30;
sponges = 30;
ie = ie - spongee - spongew;
je = je - sponges - spongen;

% LONLIMS = [-28.4 -12.8];
% LATLIMS = [7.8 20];
% load('../../A.2.3(ControlRun)/TPXO/topo_origin.mat')

LONLIMS = [min(lono) max(lono)];
LATLIMS = [min(lato) max(lato)];

% LONLIMS = [-16.6 -14.6];
% LATLIMS = [10.0 12.2];

lon = reshape(lono,[ie,je]);
lat = reshape(lato,[ie,je]);

%%

tide_names = ['O1';'K1';'M2';'S2'];  %the tide
t_order    =  [4,6,11,12];  %the ID, the 29 tide

% figure(1);clf;set(gcf,'color','w');set(gcf,'position',[100 20 800 750])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
% M2
AMPH=amph(:,4)';
AMPH(AMPH==0)=nan;
AMPH = reshape(AMPH,[ie,je]);
m_pcolor(lon,lat,AMPH);hold on;shading interp;hold on;
% m=colormap(m_colmap('jet','step',10));


 h2=colorbar('location','eastOutside','fontsize',28,'FontWeight','bold');
set(get(h2,'Title'),'string','m','fontname','Arial','fontsize',28);

set(h2,'Ticks',[0.2:0.4:2.2])
m_gshhs_h('patch',[1 1 1],'edgecolor','none','linewidth',1);
m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',28,'fontname','Arial');
clim([0.2 2.2])

load('hotres.mat');colormap(hotres)

sigma=gphh(:,4)'; 
sigma(masko'==0)=nan;

sigma1=sigma;sigma2=sigma;
sigma1(sigma1>345) = sigma1(sigma1>345) - 360; 
sigma1(sigma1>15) = nan; % -15 : 15

sigma2(sigma2<15) = nan; 
sigma2(sigma2>345) = nan; % 15 : 345
% sig2=griddata(lono,lato,sigma2,xq,yq);

sigma1 = reshape(sigma1,[ie,je]);
[c2,h2]=m_contour(lon,lat,sigma1,[0 0],'color','k','linestyle','-','linewidth',1.5); 
clabel(c2,h2,'LabelSpacing',2500,'fontsize',18,'color','k','fontname','Arial','fontweight','bold');

sigma2 = reshape(sigma2,[ie,je]);
[c2,h2]=m_contour(lon,lat,sigma2,[15:15:285],'color','k','linestyle','-','linewidth',1.5);
clabel(c2,h2,'LabelSpacing',6890,'fontsize',18,'color','k','fontname','Arial','fontweight','bold');
set(gca,'Layer','top')

% img = getframe(gcf);
% img=getframe(gcf);
% imwrite(img.cdata,['M2 Tide Cotidal Chart Amp.tiff'], 'tiff', 'Resolution', 300)
%%




