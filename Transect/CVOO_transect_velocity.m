%Figure4b
addpath ../Model_info/
%% From timeA to timeB
load('Time_info.mat', 'SDtime','LDTRUN','time_index')
S_time = datenum(2011,08,14,18,0,0);
E_time = datenum(2011,08,14,18,0,0);
t_s = find ( SDtime == S_time);
t_e = find ( SDtime == E_time);
%%
load('CVOO_transect.mat');
[ie,ke]=size(zzout_line);

LAT = zeros(ie,ke+2);
for j = 1:size(LAT,2)
    LAT(:,j) = lat_line(:);
end
zzout_line(zzout_line==0)=nan;
%% PIC
Save_Location = ['./Transect_CVOO/'];
load('NCV_bright.mat')
load('BlueDarkRed18.mat');
 load('MPL_RdYlBu_r.mat');
 load('NCV_jaisnd.mat');
 Lon_CVOO = -24.2497;
 Lat_CVOO = 17.6067;


for t= t_s:1:t_e
    % roo
    eval(['load ',Save_Location,'roo/roo_20110801T000000','.mat']);
    roo_ini = roo_line;
    clear roo_line
    eval(['load ',Save_Location,'roo/roo_',datestr(SDtime(t),30),'.mat'])
    % voe
    eval(['load ',Save_Location,'voe/voe_',datestr(SDtime(t),30),'.mat'])
    % vse
    eval(['load ',Save_Location,'vse/vse_',datestr(SDtime(t),30),'.mat'])

    % uoo
    eval(['load ',Save_Location,'uoo/uoo_',datestr(SDtime(t),30),'.mat'])
    % uso
    eval(['load ',Save_Location,'uso/uso_',datestr(SDtime(t),30),'.mat'])



    for i=1:size(voe_line,1)
           for k = 1:ke
                vke_line(i,k) = voe_line(i,k)- vse_line(i);
                uko_line(i,k) = uoo_line(i,k)- uso_line(i);
                % roo_line(i,k) = roo_line(i,k)- roo_ini(i);
           end

           uoo_across(i,:) = project_line_u_new(uko_line(i,:),vke_line(i,:),theta);
           uoo_along(i,:) = project_line_v_new(uko_line(i,:),vke_line(i,:),theta);
           % Ri(1,:) = Richardson(roo_line(i,:),uoo_across(i,:),zzout_line(i,:),Depth_line(i));

        [VKE(i,:),ZZ_v(i,:)] = Fillcolumn(zzout_line(i,:),vke_line(i,:),Depth_line(i));
        [UKO(i,:),~] = Fillcolumn(zzout_line(i,:),uko_line(i,:),Depth_line(i));
        % U_across(i,:) = project_line_u_new(UKO(i,:),VKE(i,:),theta);

        [U_across(i,:),ZZ_v(i,:)] = Fillcolumn(zzout_line(i,:),uoo_across(i,:),Depth_line(i));
        [U_along(i,:),ZZ_v(i,:)] = Fillcolumn(zzout_line(i,:),uoo_along(i,:),Depth_line(i));
        [ROO(i,:),~] = Fillcolumn(zzout_line(i,:),roo_line(i,:),Depth_line(i));
        [ROO_INI(i,:),~] = Fillcolumn(zzout_line(i,:),roo_ini(i,:),Depth_line(i));
        [ROO_change(i,:),~] = Fillcolumn(zzout_line(i,:),roo_line(i,:)-roo_ini(i,:),Depth_line(i));
        % [Ri_grid(i,:),~] = Fillcolumn(zzout_line(i,:),Ri(1,:),Depth_line(i));

    end

    % h1 = axes('position',[0.08 0.81 0.85 0.15]);

     h1 = axes('position',[0.08 0.38 0.85 0.25]);

    
    pcolor(LAT,ZZ_v,U_across);shading interp;
        clim([-0.4001 0.40001])
    colormap(MPL_RdYlBu_r)
       load('NCV_jaisnd.mat');
    colormap(h1,NCV_jaisnd);hold on;
   %   [c1,h1] = contour(LAT,ZZ_v,ROO,20,'color','k','linewidth',0.8,'linestyle','-.');hold on
   % ylim([0 1200]);
   %  set(gca,'YScale','log')
   % [c,h] = contour(LAT,ZZ_v,ROO_INI-1000,[27.0,27.0],'color','b','linewidth',0.5,'linestyle','-');hold on    
   % [c,h] = contour(LAT,ZZ_v,ROO-1000,[27.0,27.0],'color','k','linewidth',0.5,'linestyle','-');hold on
  [c1,h1] = contour(LAT,ZZ_v,ROO_change,[-0.4:0.2:-0.2],'color','k','linewidth',0.8,'linestyle','-.');hold on
  clabel(c1,h1,'LabelSpacing',1000,'fontsize',24,'color','k','fontname','Arial','fontSmoothing','on'); 
  hold on;
  [c2,h2] = contour(LAT,ZZ_v,ROO_change,[0.2:0.2:0.4],'color','k','linewidth',0.8,'linestyle','-');hold on
   clabel(c2,h2,'LabelSpacing',1000,'fontsize',24,'color','k','fontname','Arial','fontSmoothing','on'); 
  hold on;

 % 
 %    pcolor(LAT,ZZ_v,ROO_change);shading interp;clim([-1 1])
 %   % [c,h] = contour(LAT,ZZ_v,ROO_INI-1000,[27.0,27.0],'color','b','linewidth',0.5,'linestyle','-');hold on    
 %   % [c,h] = contour(LAT,ZZ_v,ROO-1000,[27.0,27.0],'color','k','linewidth',0.5,'linestyle','-');hold on
 %  [c1,h1] = contour(LAT,ZZ_v,U_across,[-2:0.05:0],'color','k','linewidth',1.0,'linestyle','-.');hold on
 %  [c2,h2] = contour(LAT,ZZ_v,U_across,[0:0.05:2],'color','k','linewidth',1.0,'linestyle','-');hold on
 % ylim([0 100]);

  % plot(lat_line,linspace(110,110,length(lat_line)),'-','Color','k','LineWidth',2);hold on;
    % clabel(c,h,'LabelSpacing',1000,'fontsize',9,'color','k','fontname','Arial','fontweight','bold','fontSmoothing','on');      
    % [c,h] = contour(LAT,ZZ_v,VKE,[-0.5:0.1:0.5],'color','k','linewidth',1.0,'linestyle','-');hold on
    % pcolor(XX(:,1:je),zzout_18,uko);shading interp;


 
    plot(Lat_CVOO,20,'ok','linewidth',1.5,'Markersize',20,'MarkerFaceColor','r',...
    'DisplayName','CVOO mooring'); hold on;

    % title(['Meridional velocity V along CVOO transect on ',datestr(SDtime(t))],'fontname','Arial',...
    %     'fontweight','bold','fontsize',12)
    set(gca,'fontsize',28,'LineWidth',2,'fontname','Arial',...
        'Ydir','reverse','Xaxislocation','bottom');
    % m_gshhs_h('patch',[.8 .8 .8],'edgecolor','k','linewidth',1.5);
    h2=colorbar('location','eastOutside','fontsize',28,'fontweight','bold');
    set(get(h2,'Title'),'string','m s^-^1','fontname','Arial','fontweight','bold');
    set(h2,'position',[0.936711581616437 0.41 0.018 0.25])

    ylabel('Depth(m)','fontsize',28,'fontname','Arial')
    % xlabel('Lat(°N)','fontsize',16,'fontname','Arial','fontweight','bold')
    % area(lat_line,Depth_line,'FaceColor',[.4 .4 .4],'BaseValue',max(Depth_line),'linewidth',2.0);hold on
    ylim([0 500]);
    xlim([min(lat_line) max(lat_line)])
    set(gca,'XTick',[14:0.5:18],'XTickLabel',{' '},'YTick',[0:100:500])
    set(gca,'Layer','top');

    annotation(figure(1),'textbox',...
    [0.123 0.56 0.0300691778009588 0.0765714277539935],...
    'String','$u^\prime$',...
    'LineStyle','none',...
    'Interpreter', 'latex',...
    'FontSize',28,...
    'FontName','Arial',...
    'FitBoxToText','on');   
%%
    h2 = axes('position',[0.08 0.10 0.85 0.25]);

    pcolor(LAT,ZZ_v,log10(1025*0.5*(U_across.^2 + U_along.^2)));shading interp;
      colormap(h2,MPL_RdYlBu_r);hold on;
    area(lat_line,Depth_line,'FaceColor',[1 1 1],'BaseValue',max(Depth_line),'linewidth',2.0);hold on
    xlim([min(lat_line) max(lat_line)]);ylim([0, max(Depth_line)]);
    clim([-2 2]);
    % ylim([0, 100]);
     
    bar2=colorbar('location','eastOutside','fontsize',28,'fontweight','bold');
    set(get(bar2,'Title'),'string','J m^-^3','fontname','Arial','fontweight','bold');
    set(bar2,'Ticks',[-2:1:2])
    set(bar2,'position',[0.936711581616437 0.10 0.018 0.25])

   % [c1,h1] = contour(LAT,ZZ_v,Ri_grid,[0.25,0,25],'color','k','linewidth',0.8,'linestyle','-.');hold on
   % clabel(c1,h1,'LabelSpacing',1000,'fontsize',9,'color','k','fontname','Arial','fontSmoothing','on'); 

    set(gca,'fontsize',28,'LineWidth',2,'fontname','Arial',...
        'Ydir','reverse','Xaxislocation','bottom');
    plot(Lat_CVOO,200,'ok','linewidth',2.5,'Markersize',20,'MarkerFaceColor','r',...
    'DisplayName','CVOO mooring'); hold on;
    plot([Lat_CVOO,Lat_CVOO],[100,3570],'-.','linewidth',2.0,'Color','k'); hold on;

    %xlabel('Latitude (°N)','fontsize',28,'fontname','Arial','fontweight','bold')
    set(gca,'Layer','top');

    annotation(figure(1),'textbox',...
    [0.558454545454545 0.112285713468279 0.151862397627397 0.114285714285714],...
    'String','$\log_{10}(HKE)$',...
    'LineStyle','none',...
    'Interpreter', 'latex',...
    'FontSize',28,...
    'FontName','Arial',...
    'FitBoxToText','on');  



end