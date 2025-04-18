clear;clc;close all
% addpath /gxfs_home/geomar/smomw557/Model_H2/seawater_ver3_3.1
addpath ../Model_info/
%% From timeA to timeB
load('Time_info.mat', 'SDtime','LDTRUN','time_index')
% S_time = datenum(2011,08,12,0,0,0);
% E_time = datenum(2011,08,17,23,0,0);
S_time = datenum(2011,08,16,0,0,0);
E_time = datenum(2011,08,31,23,0,0);
t_s = find ( SDtime == S_time);
t_e = find ( SDtime == E_time);
Dtime = 3600;
%% Model GRID & background stratification 
load('Grid_info.mat','ke','weto_p','ddpo_grid','depto_grid','zzout','bottom_index');
load('Grid_info_u.mat', 'deuto_grid','dduo_grid');
load('Grid_info_v.mat', 'deute_grid','ddue_grid');
load('Grid_resolution.mat', 'dlxp','dlxv','dlyu','dlyp');

iw = 30;ie = 1;
jn = 30;js = 30;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
zzout  = Exclude_sponge(iw,ie,jn,js,zzout);

ddpo_grid  = Exclude_sponge(iw,ie,jn,js,ddpo_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);

dduo_grid  = Exclude_sponge(iw,ie,jn,js,dduo_grid);
deuto_grid  = Exclude_sponge(iw,ie,jn,js,deuto_grid);

ddue_grid  = Exclude_sponge(iw,ie,jn,js,ddue_grid);
deute_grid  = Exclude_sponge(iw,ie,jn,js,deute_grid);

dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);
dlxv = Exclude_sponge(iw,ie,jn,js,dlxv);
dlyu = Exclude_sponge(iw,ie,jn,js,dlyu);


ie = size(depto_grid,1);
je = size(depto_grid,2);
%  Averaged density and pressure
load('Background_stratification.mat','rao_bg');
%% 

Conv = zeros(ie,je);
w_bt = zeros(ie,je,ke);
w_bt_itp = zeros(ie,je,ke);
rao_bc = zeros(ie,je,ke);
summie = zeros(ie,je);

Location = ['../data/'];
for t= t_s:1:t_e
    if (LDTRUN(t)<10)
        % name_t = [Location,'tho/THO_0000000',num2str(LDTRUN(t)),'.nc'];
        % name_s = [Location,'sao/SAO_0000000',num2str(LDTRUN(t)),'.nc'];
        % name_p = [Location,'poo/POO_0000000',num2str(LDTRUN(t)),'.nc'];
        name_r = [Location,'roo/ROO_0000000',num2str(LDTRUN(t)),'.nc'];
        name_u = [Location,'uoo/UOO_0000000',num2str(LDTRUN(t)),'.nc'];
        name_v = [Location,'voe/VOE_0000000',num2str(LDTRUN(t)),'.nc'];
     else if(LDTRUN(t) < 100)
        % name_t = [Location,'tho/THO_000000',num2str(LDTRUN(t)),'.nc'];
        % name_s = [Location,'sao/SAO_000000',num2str(LDTRUN(t)),'.nc'];
        % name_p = [Location,'poo/POO_000000',num2str(LDTRUN(t)),'.nc'];
        name_r = [Location,'roo/ROO_000000',num2str(LDTRUN(t)),'.nc'];
        name_u = [Location,'uoo/UOO_000000',num2str(LDTRUN(t)),'.nc'];
        name_v = [Location,'voe/VOE_000000',num2str(LDTRUN(t)),'.nc'];
       else if(LDTRUN(t) < 1000)
           % name_t = [Location,'tho/THO_00000',num2str(LDTRUN(t)),'.nc'];
           % name_s = [Location,'sao/SAO_00000',num2str(LDTRUN(t)),'.nc'];
           % name_p = [Location,'poo/POO_00000',num2str(LDTRUN(t)),'.nc'];
           name_r = [Location,'roo/ROO_00000',num2str(LDTRUN(t)),'.nc'];
           name_u = [Location,'uoo/UOO_00000',num2str(LDTRUN(t)),'.nc'];
           name_v = [Location,'voe/VOE_00000',num2str(LDTRUN(t)),'.nc'];
        else if(LDTRUN(t) < 10000)
           % name_t = [Location,'tho/THO_0000',num2str(LDTRUN(t)),'.nc'];
           % name_s = [Location,'sao/SAO_0000',num2str(LDTRUN(t)),'.nc'];
           % name_p = [Location,'poo/POO_0000',num2str(LDTRUN(t)),'.nc'];
           name_r = [Location,'roo/ROO_0000',num2str(LDTRUN(t)),'.nc'];
           name_u = [Location,'uoo/UOO_0000',num2str(LDTRUN(t)),'.nc'];
           name_v = [Location,'voe/VOE_0000',num2str(LDTRUN(t)),'.nc'];
          else if(LDTRUN(t) < 100000)
           % name_t = [Location,'tho/THO_000',num2str(LDTRUN(t)),'.nc'];
           % name_s = [Location,'sao/SAO_000',num2str(LDTRUN(t)),'.nc'];
           % name_p = [Location,'poo/POO_000',num2str(LDTRUN(t)),'.nc'];
           name_r = [Location,'roo/ROO_000',num2str(LDTRUN(t)),'.nc'];
           name_u = [Location,'uoo/UOO_000',num2str(LDTRUN(t)),'.nc'];
           name_v = [Location,'voe/VOE_000',num2str(LDTRUN(t)),'.nc'];
          else if(LDTRUN(t) < 1000000)
           % name_t = [Location,'tho/THO_00',num2str(LDTRUN(t)),'.nc'];
           % name_s = [Location,'sao/SAO_00',num2str(LDTRUN(t)),'.nc'];
           % name_p = [Location,'poo/POO_00',num2str(LDTRUN(t)),'.nc'];
           name_r = [Location,'roo/ROO_00',num2str(LDTRUN(t)),'.nc'];
           name_u = [Location,'uoo/UOO_00',num2str(LDTRUN(t)),'.nc'];
           name_v = [Location,'voe/VOE_00',num2str(LDTRUN(t)),'.nc'];
          end
          end
        end
      end
     end
    end


    % tho = ncread(name_t,'THO',...
    %               [iw+1 jn+1 1],[ie,je,ke]);     
    rao = ncread(name_r,'ROO',...
                 [iw+1 jn+1 1],[ie,je,ke]);   
    % poo = ncread(name_p,'POO',...
    %              [iw+1 jn+1 1],[ie,je,ke]);
    uko = ncread(name_u,'UOO',...
                 [iw+1 jn+1 1],[ie+1,je,ke]);   
    vke = ncread(name_v,'VOE',...
                 [iw+1 jn+1 1],[ie,je+1,ke]);

% % 1 decibar to Pascal = 10000 Pascal
%      poo = poo*1e-4; poo = poo.*1025;
% 
%      clear poo
     %-------------------------------------%
     %------decompose the velocity---------%  
        % barotropical part
          u_b = sum(uko.*dduo_grid,3)./deuto_grid;
          v_b = sum(vke.*ddue_grid,3)./deute_grid;
          r_bt = sum((rao - rao_bg).*ddpo_grid,3)./depto_grid; 

          u_b(deuto_grid==0)=0;v_b(deute_grid==0)=0;r_bt(depto_grid==0)=0;

          for k = 1:ke
             if( k ==1 )
                 dz_n = deute_grid(:,1:end-1) ;
                 dz_s = deute_grid(:,2:end);
                 dz_e = deuto_grid(2:end,:);
                 dz_w = deuto_grid(1:end-1,:);                  
             else
                 dz_n = deute_grid(:,1:end-1) - sum(ddpo_grid(:,:,1:k-1),3); dz_n(dz_n<=0)=0; % 当n爬坡，n_flux = 0，只能n下坡 v>0
                 dz_s = deute_grid(:,2:end)   - sum(ddpo_grid(:,:,1:k-1),3); dz_s(dz_s<=0)=0; % 当s下坡，s_flux = 0，只能s爬坡 v>0
                 dz_e = deuto_grid(2:end,:)   - sum(ddpo_grid(:,:,1:k-1),3); dz_e(dz_e<=0)=0; % 当e爬坡，e_flux = 0，只能e下坡 u>0
                 dz_w = deuto_grid(1:end-1,:) - sum(ddpo_grid(:,:,1:k-1),3); dz_w(dz_w<=0)=0; % 当w下坡，e_flux = 0，只能w爬坡 u>0         
             end
              
             n_flux(:,:) = dz_n(:,:).*dlxv(:,1:end-1).*v_b(:,1:end-1);
             s_flux(:,:) = dz_s(:,:).*dlxv(:,2:end).*v_b(:,2:end);      
             e_flux(:,:) = dz_e(:,:).*dlyu(2:end,:).*u_b(2:end,:);
             w_flux(:,:) = dz_w(:,:).*dlyu(1:end-1,:).*u_b(1:end-1,:);
        
             % barotropical vertical velocity
             w_bt(:,:,k) = (w_flux-e_flux+s_flux-n_flux)./(dlxp(:,:).*dlyp(:,:));
            
             rao_bc(:,:,k) =  9.8.*(rao(:,:,k) - rao_bg(:,:,k) - r_bt(:,:));  
          end

        clear n_flux s_flux e_flux w_flux
        clear dz_n dz_s dz_w dz_e
 
    %-------------------------%
    %------conversion---------%
        w_bt_itp(:,:,1:ke-1) = (w_bt(:,:,1:ke-1) +w_bt(:,:,2:ke))./2.;
        w_bt_itp(:,:,ke) = w_bt(:,:,ke)./2.;
        
        % w_bt_itp = w_b_itp - w_bm_itp;
        
        Conv(:,:) = sum(rao_bc.*w_bt_itp.*ddpo_grid,3).*Dtime;        
        summie(:,:) = summie + Conv(:,:); 

        disp([datestr(SDtime(t))])
end

Length = t_e - t_s + 1;

C_linear = summie/(Dtime*Length); % time average
C_linear(isnan(depto_grid) == 1)=nan;

save Linear_conversion_rate.mat C_linear
