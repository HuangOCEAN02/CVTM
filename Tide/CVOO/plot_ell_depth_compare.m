function w = plot_ell_depth_compare(SEMA, ECC, INC, PHA, depth,Eye)

% xis:(x,y) complex coordinate
% Y should be scaled

   SEMI = SEMA.*ECC;
   Wp = (1+ECC)/2 .*SEMA;
   Wm = (1-ECC)/2 .*SEMA;
   THETAp = INC-PHA;
   THETAm = INC+PHA;

   %convert degrees into radians
   THETAp = THETAp/180*pi;
   THETAm = THETAm/180*pi;
   INC = INC/180*pi;
   PHA = PHA/180*pi;

   %Calculate wp and wm.
   wp = Wp.*exp(i*THETAp);
   wm = Wm.*exp(i*THETAm);
   
   dot = pi/36;
   ot = [0:dot:2*pi];
   a = wp*exp(i*ot); % anti-clockwise circle
   b = wm*exp(-i*ot);% clockwise circle
   w = a+b;

   wmax = SEMA*exp(i*INC);
   wmin = SEMI*exp(i*(INC+pi/2));
%% 坐标调整
    if (Eye == '3d')
   Depth_plan = linspace(depth,depth,length(w));
   plot3(real(w), imag(w),Depth_plan);hold on;grid on;
   % axis('equal');
  
   % maxmimum
   plot3([0 real(wmax)], [0 imag(wmax)],[depth depth], 'color',[.4 .2 .9],'linewidth',2,'LineStyle',':');
   hold on;
   % plot3([real(wmax)], [imag(wmax)],[depth], 'color',[.4 .2 .9],'linewidth',3,'marker','+');
   % minimum
   plot3([0 real(wmin)], [0 imag(wmin)],[depth depth], 'color',[.2 .5 .3],'linewidth',2,'LineStyle',':');
   hold on;
   % plot3([real(wmin)], [imag(wmin)],[depth], 'color',[.2 .5 .3],'linewidth',3,'marker','x');
  
   % xlim([min(real(w)) max(real(w))])
   % ylim([min(imag(w)) max(imag(w))])

   % plot3(real(a), imag(a), Depth_plan,'r'); %anti-clockwise circle
   % plot3(real(b), imag(b), Depth_plan,'g'); % clockwise circle

%% Scaled Ellipse
   % Ly = max(imag(w)) -  min(imag(w));
   % Lx = max(real(w)) -  min(real(w));
   % 
   % w_new = real(w)/Lx + sqrt(-1)*imag(w)/Ly; 
   % wmax_new =  real(wmax)/Lx + sqrt(-1)*imag(wmax)/Ly;
   % wmin_new =  real(wmin)/Lx + sqrt(-1)*imag(wmin)/Ly;
   % 
   % x_new = real(xis);
   % y_new = imag(xis);
   % 
   % w_new = w_new + xis;
   % wmax_new = wmax_new + xis;
   % wmin_new = wmin_new + xis;
   w_new = w;
%% 
   if ECC > 0
     plot3(real(w_new), imag(w_new),Depth_plan,'color','r','LineWidth',1.2);hold on;
   % initial position
     % hnd_w=line([0 real(w_new(1))], [0 imag(w_new(1))],[depth,depth],'color', [.4 .4 .4], ...
     %     'linewidth',1.2);
     % ini_w=plot3([real(w_new(1))], [imag(w_new(1))],[depth],'color', [.4 .4 .4], ...
     %     'marker','o','linewidth',1.2);   
   else
     plot3(real(w_new), imag(w_new),Depth_plan,'color','b','LineWidth',1.2);hold on;
   % initial position
     % hnd_w=line([0 real(w_new(1))], [0 imag(w_new(1))],[depth,depth],'color', [.4 .4 .4], ...
     %     'linewidth',1.2);  
     % ini_w=plot3([real(w_new(1))], [imag(w_new(1))],[depth],'color', [.4 .4 .4], ...
     %     'marker','o','linewidth',1.2);   
   end

    elseif Eye == '2d'


    plot(real(w), imag(w));hold on;

   % maxmimum
     plot([0 real(wmax)], [0 imag(wmax)], 'color',[.4 .2 .9],'linewidth',1,'LineStyle',':');
     hold on;
    plot3([real(wmax)], [imag(wmax)],[depth], 'color',[.4 .2 .9],'linewidth',1,'marker','+');
    % minimum
     % plot([0 real(wmin)], [0 imag(wmin)], 'color',[.2 .5 .3],'linewidth',2,'LineStyle',':');
     % hold on;
     % plot([0], [0], 'color','k','linewidth',1,'marker','o');
   % plot3([real(wmin)], [imag(wmin)],[depth], 'color',[.2 .5 .3],'linewidth',3,'marker

   w_new = w;
   if ECC > 0
     plot(real(w_new), imag(w_new),'color','r','LineWidth',1.2,'LineStyle',':');hold on;
   % initial position
     hnd_w=line([0 real(w_new(1))], [0 imag(w_new(1))],'color', [.4 .4 .4], ...
         'linewidth',1.2,'LineStyle',':');
     ini_w=plot([real(w_new(1))], [imag(w_new(1))],'color', [.4 .4 .4], ...
         'marker','o','linewidth',1.2,'MarkerSize',0.2);      
   else
     plot(real(w_new), imag(w_new),'color','b','LineWidth',1.2,'LineStyle',':');hold on;
   % initial position
     hnd_w=line([0 real(w_new(1))], [0 imag(w_new(1))],'color', [.4 .4 .4], ...
         'linewidth',1.2,'LineStyle',':');  
     ini_w=plot([real(w_new(1))], [imag(w_new(1))],'color', [.4 .4 .4], ...
         'marker','o','linewidth',1.2,'MarkerSize',0.2);   
   end
    
    end

   hold on;
end