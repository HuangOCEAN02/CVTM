clear;clc;close all
%%
 load('./obcs/CVOO_tidal_ellipse_D2.mat')
Ellipse =zeros(3,size(res_m2,1),size(res_m2,2));
Ellipse(1,:,:) = res_m2;
Ellipse(2,:,:) = res_s2;
Ellipse(3,:,:) = res_n2;
dd_o(:) =  d_inter(:);
% 40 -100
ko_level = [16:5:46];
% inclination 
inc_m2 = mean(res_m2(5,16:end))
inc_s2 = mean(res_s2(5,16:end))
% major
maj_m2 = mean(res_m2(1,16:end))
maj_s2 = mean(res_s2(1,16:end))
% minor
min_m2 = mean(res_m2(3,16:end))
min_s2 = mean(res_s2(3,16:end))
%%
clear d_inter res_n2 res_m2 res_s2
load('./Model/CVOO_Model_Tidal_BC_Constants.mat');
Ellipse_model =zeros(3,size(res_m2,1),size(res_m2,2));
Ellipse_model(1,:,:) = res_m2;
Ellipse_model(2,:,:) = res_s2;
Ellipse_model(3,:,:) = res_n2;
isellipse_2d = 1;
dd_m(:) =  d_inter(:);
% 40 -100
km_level = [4:1:10];
% inclination 
inc_m2_model = mean(res_m2(5,km_level))
inc_s2_model = mean(res_s2(5,km_level))
% major
maj_m2_model = mean(res_m2(1,km_level))
maj_s2_model = mean(res_s2(1,km_level))
% minor
min_m2_model = mean(res_m2(3,km_level))
min_s2_model = mean(res_s2(3,km_level))

maj_m2 - maj_m2_model
min_m2 - min_m2_model
maj_s2 - maj_s2_model
min_s2 - min_s2_model
%%
figure(1);clf;set(gcf,'color','w');set(gcf,'position',[180 10 580 550]);
H=axes;hold(H,'on');
xmin = 0;
xmax = 3;
% not depth

% vertical level
% depinx = [21:5:length(dd_m)]; % index of dd_m

y_interval = 10; % depth interval
ymin = 30; % The first ellipse
ymax = 100 + y_interval ; % The last ellipse

tide_num = 2; % M2 S2 N2 
xlim([xmin xmax]);
ylim([ymin ymax]);

set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
       'Ydir','reverse','Xaxislocation','bottom','fontweight','bold',...
       'YTick',[0:10:110],...
       'XTick',[1:2],'XTickLabel',{'M2','S2'});
grid off;

set(gca,'GridAlpha',0.4,'GridLineWidth',0.5,'GridLineStyle','-.')
set(gca,'YTick',[40:10:100])
Tide_inv =H.Position(3)/(tide_num+1); 
dep_inv = H.Position(4)/((ymax-ymin)/y_interval); % depth interval

box off; 
xlabel('Baroclinic tide ','fontsize',28,'fontname','Arial',...
    'fontweight','bold');
ylabel('Depth (m) ','fontsize',28,'fontname','Arial',...
    'fontweight','bold');
% axis loc
ax_ellpise = zeros(length(km_level),4,tide_num); % Four positions

% itde = [4 5 3]; % rayleigh
itde = [1 2 3];
itdeo = [1 2 3];
for it = 1:tide_num
    count = 1; % From sea floor to top
    NAME_bc(itde(it),:)
    for k = length(ko_level): -1 : 1
        El(count,it) = axes;hold(El(count,it),'on');
        x_length = H.Position(3)./((tide_num+1)*0.3); % 0.5 and 0.2 can be adjusted
        y_length = H.Position(4)./(((ymax-ymin)/y_interval)*0.4);

        x_start = H.Position(1) + Tide_inv*it- x_length/2;
        y_start = H.Position(2) + dep_inv*count - y_length/2;

        ax_ellpise(k,1:4,it)= [x_start y_start x_length y_length];
        set(El(count,it),'Position',...
            [x_start y_start x_length y_length]);

        dd_o(ko_level(k))
        SEMA = Ellipse(itdeo(it),1,ko_level(k)); % Semi-major axes
        ECC = Ellipse(itdeo(it),3,ko_level(k))/Ellipse(itdeo(it),1,ko_level(k)); % Eccentricity, 
        % the ratio of semi-minor axis over the semi-major axis;
        INC = Ellipse(itdeo(it),5,ko_level(k)); % Inclination
        PHA = Ellipse(itdeo(it),7,ko_level(k)); %  Phase angles
        plot_ell_depth(SEMA, ECC, INC, PHA, k,'2d');hold on;

         dd_m(km_level(k))
        SEMA = Ellipse_model(itde(it),1,km_level(k)); % Semi-major axes
        ECC = Ellipse_model(itde(it),3,km_level(k))/Ellipse_model(itde(it),1,km_level(k)); % Eccentricity, 
        % the ratio of semi-minor axis over the semi-major axis;
        
        INC = Ellipse_model(itde(it),5,km_level(k)); % Inclination
        PHA = Ellipse_model(itde(it),7,km_level(k)); %  Phase angles
        plot_ell_depth_compare(SEMA, ECC, INC, PHA, k,'2d');      
        
        if it == 1 % M2
            axis equal
            xlim([-0.1 0.1]);ylim([-0.1 0.1]);box on;     
            if count == 1 
            % draw scalar
            plot([-0.08 -0.05],[-0.05,-0.05],'k','linewidth',2.0);hold on;
            plot([-0.08],[-0.05],'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
            plot([-0.05],[-0.05],'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
            % text(mean([-0.05 -0.03])-0.015,0-0.015,[num2str(3),' cm s^-^1'], ...
            % 'Color','k','FontSize',12, ...
            %     'fontname','Arial','fontweight','bold');
            end
        end

        if it == 2 % S2
            axis equal
            xlim([-0.05 0.05]);
            ylim([-0.05,0.05]);box on;
            if count == 1 
            % draw scalar
            plot([-0.045 -0.025],[-0.025,-0.025],'k','linewidth',2.0);hold on;
            plot([-0.045],[-0.025],'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
            plot([-0.025],[-0.025],'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
            % text(mean([-0.075 -0.035])-0.02,0-0.01,[num2str(2),' cm s^-^1'], ...
            % 'Color','k','FontSize',12, ...
            %     'fontname','Arial','fontweight','bold');
            end
        end
 
        % if it == 3 % N2
        %     axis equal
        %     xlim([-0.02 0.02]);ylim([-0.02 0.02]);box on;
        %     if count == 1 
        %     % draw scalar
        %     plot([-0.015 -0.005],[-0.01,-0.01],'k','linewidth',2.0);hold on;
        %     plot([-0.015],[-0.01],'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
        %     plot([-0.005],[-0.01],'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
        %     text(mean([-0.015 -0.0075])-0.002,0-0.008,[num2str(0.75),' cm s^-^1'], ...
        %     'Color','k','FontSize',12, ...
        %         'fontname','Arial','fontweight','bold');
        %     end
        % end
        % 


        axis off;
        
        count = count + 1;
    end
end




img=getframe(gcf);
imwrite(img.cdata,['Compare_CVOO_Baroclinic_ellipse_new.tiff'], 'tiff', 'Resolution', 300)




