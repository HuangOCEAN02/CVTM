clear;clc;close all
 load('./obcs/CVOO_Tidal_Constants.mat')
Ellipse = res_bt;
 isellipse_3d = 0;
 isellipse_2d = 1;

 if isellipse_2d
figure(1);clf;set(gcf,'color','w');set(gcf,'position',[180 10 580 230]);
H=axes;hold(H,'on');
xmin = 0;
xmax = 3;
% not depth


y_interval = 1; % depth interval

ymin = -5; % The first ellipse
ymax = 5 ; % The last ellipse

tide_num = 2; % M2 S2 N2 K1 O1
xlim([xmin xmax]);
ylim([ymin ymax]);

set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
       'Ydir','reverse','Xaxislocation','bottom','fontweight','bold',...
       'YTick',[-5:5:5],'YTickLabel',{' '},...
       'XTick',[1:2],'XTickLabel',{' '});
grid on;

set(gca,'GridAlpha',0.4,'GridLineWidth',0.5,'GridLineStyle','-.')

y_level = 2;
Tide_inv =H.Position(3)/(tide_num+1); 
dep_inv = H.Position(4)/y_level; 

box on; 
title(['Tidal ellipse'],'fontsize',28,'fontname','Arial',...
    'fontweight','bold');
ylabel(['Barotropic tide'],'fontsize',25,'fontname','Arial',...
    'fontweight','bold');
% axis loc
ax_ellpise = zeros(4,tide_num); % Four positions

itde = [11 12 10];% 1month

% itde = [15 17 14 8 6]; % 2month

for it = 1:tide_num
    count = 1; % From sea floor to top
    % for k = length(depinx): -1 : 1
    
        El(count,it) = axes;hold(El(count,it),'on');
        x_length = H.Position(3)./((tide_num+1)*0.2); % 0.5 and 0.2 can be adjusted
        y_length = H.Position(4)./(((ymax-ymin))*0.12);

        x_start = H.Position(1) + Tide_inv*it- x_length/2;
        y_start = H.Position(2) + dep_inv*(y_level-1) - y_length/2;

        ax_ellpise(1:4,it)= [x_start y_start x_length y_length];
        set(El(count,it),'Position',...
            [x_start y_start x_length y_length]);


        SEMA = Ellipse(itde(it),1); % Semi-major axes
        ECC = Ellipse(itde(it),3)/Ellipse(itde(it),1); % Eccentricity, 
        % the ratio of semi-minor axis over the semi-major axis;
        INC = Ellipse(itde(it),5); % Inclination
        PHA = Ellipse(itde(it),7); %  Phase angles
        plot_ell_depth(SEMA, ECC, INC, PHA, 1,'2d');

        if it == 1 % M2
            axis equal
            xlim([-0.025 0.025]);ylim([-0.028 0.028]);box on;    
            % xlim([-0.2 0.2]);ylim([-0.2 0.2]);box on;  
            % draw scalar
            bar_x = [-0.01 -0.01];
            bar_y = [0.01,-0.01];
            plot(bar_x,bar_y,'k','linewidth',2.0);hold on;
            plot(bar_x,bar_y,'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
            % plot([-0.075],[-0.01],'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
            %text(mean(bar_x)-0.012,bar_y(2)-0.005,[num2str(2),' cm s^-^1'], ...
            %'Color','k','FontSize',18, ...
            %    'fontname','Arial','fontweight','bold');
            % 2cm /s
        end

        if it == 2 % S2
            axis equal
            xlim([-0.008 0.008]);ylim([-0.015 0.015]);box on;
            % draw scalar
            bar_x = [-0.004 -0.004];
            bar_y = [0.005,-0.005];
            plot(bar_x,bar_y,'k','linewidth',2.0);hold on;
            plot(bar_x,bar_y,'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
            % plot([-0.075],[-0.01],'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
            %text(mean(bar_x)-0.005,bar_y(2)-0.004,[num2str(1),' cm s^-^1'], ...
            %'Color','k','FontSize',18, ...
            %    'fontname','Arial','fontweight','bold');
            % 1cm /s
              %text(mean(bar_x)-0.012,bar_y(2)-0.005,[num2str(2),' cm s^-^1'], ...
            %'Color','k','FontSize',18, ...
            %    'fontname','Arial','fontweight','bold');
        end
 
        if it == 3 % N2
            axis equal
        xlim([-0.008 0.008]);ylim([-0.008 0.008]);box on;
   % draw scalar
            bar_x = [-0.003 -0.003];
            bar_y = [0.0025,-0.0025];
            plot(bar_x,bar_y,'k','linewidth',2.0);hold on;
            plot(bar_x,bar_y,'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
            % plot([-0.075],[-0.01],'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
            text(mean(bar_x)-0.002,bar_y(2)-0.0005,[num2str(0.5),' cm s^-^1'], ...
            'Color','k','FontSize',18, ...
                'fontname','Arial','fontweight','bold');
        end

        if it == 4 % K1
            axis equal
        xlim([-0.008 0.008]);ylim([-0.008 0.008]);box on;
            % draw scalar
           bar_x = [-0.003 -0.003];
            bar_y = [0.0025,-0.0025];
            plot(bar_x,bar_y,'k','linewidth',2.0);hold on;
            plot(bar_x,bar_y,'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
            % plot([-0.075],[-0.01],'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
            text(mean(bar_x)-0.001,bar_y(2)-0.001,[num2str(0.5),' cm s^-^1'], ...
            'Color','k','FontSize',18, ...
                'fontname','Arial','fontweight','bold');
        end

        if it == 5 % O1
            axis equal
            xlim([-0.008 0.008]);ylim([-0.008 0.008]);box on;
            % draw scalar
            bar_x = [-0.002 -0.002];
            bar_y = [0.0025,-0.0025];
            plot(bar_x,bar_y,'k','linewidth',2.0);hold on;
            plot(bar_x,bar_y,'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
            % plot([-0.075],[-0.01],'ko','linewidth',1.0,'MarkerSize',5,'MarkerFaceColor','k');hold on;
            text(mean(bar_x)-0.001,bar_y(2)-0.001,[num2str(0.5),' cm s^-^1'], ...
            'Color','k','FontSize',18, ...
                'fontname','Arial','fontweight','bold');
        end

        axis off;
        
        count = count + 1;
end
end



img=getframe(gcf);
imwrite(img.cdata,['CVOO_Barotropic_ellipse.tiff'], 'tiff', 'Resolution', 300)




