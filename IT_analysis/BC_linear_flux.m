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
load('Grid_info.mat','ke','weto_p','ddpo_grid','depto_grid');
load('Grid_info_u.mat', 'deuto_grid','dduo_grid');
load('Grid_info_v.mat', 'deute_grid','ddue_grid');
% load('Grid_resolution.mat', 'dlxp','dlxv','dlyu');

iw = 30;ie = 1;
jn = 30;js = 30;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
% zzout  = Exclude_sponge(iw,ie,jn,js,zzout);

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
deuto_grid  = Exclude_sponge(iw,ie,jn,js,deuto_grid);
deute_grid  = Exclude_sponge(iw,ie,jn,js,deute_grid);

ddpo_grid  = Exclude_sponge(iw,ie,jn,js,ddpo_grid);
dduo_grid  = Exclude_sponge(iw,ie,jn,js,dduo_grid);
ddue_grid  = Exclude_sponge(iw,ie,jn,js,ddue_grid);
% dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
% dlxv = Exclude_sponge(iw,ie,jn,js,dlxv);
% dlyu = Exclude_sponge(iw,ie,jn,js,dlyu);

Dtime = 3600; % timestep of outputs [s]
ie = size(depto_grid,1);
je = size(depto_grid,2);

load('Background_stratification.mat','poo_bg');
poo_bg = poo_bg.*1025;
poo_bg(weto_p==0)=0;
%%
up_layer_u =  zeros(ie,je,ke);
up_layer_v =  zeros(ie,je,ke);
summie_u = zeros(ie,je);
summie_v = zeros(ie,je);

Location = ['../data/'];
for t= t_s:1:t_e
    if (LDTRUN(t)<10)
        % name_t = [Location,'tho/THO_0000000',num2str(LDTRUN(t)),'.nc'];
        % name_s = [Location,'sao/SAO_0000000',num2str(LDTRUN(t)),'.nc'];
        % name_r = [Location,'roo/ROO_0000000',num2str(LDTRUN(t)),'.nc'];
        name_p = [Location,'poo/POO_0000000',num2str(LDTRUN(t)),'.nc'];
        name_u = [Location,'uoo/UOO_0000000',num2str(LDTRUN(t)),'.nc'];
        name_v = [Location,'voe/VOE_0000000',num2str(LDTRUN(t)),'.nc'];

     else if(LDTRUN(t) < 100)
        % name_t = [Location,'tho/THO_000000',num2str(LDTRUN(t)),'.nc'];
        % name_s = [Location,'sao/SAO_000000',num2str(LDTRUN(t)),'.nc'];
        % name_r = [Location,'roo/ROO_000000',num2str(LDTRUN(t)),'.nc'];
        name_p = [Location,'poo/POO_000000',num2str(LDTRUN(t)),'.nc'];
        name_u = [Location,'uoo/UOO_000000',num2str(LDTRUN(t)),'.nc'];
        name_v = [Location,'voe/VOE_000000',num2str(LDTRUN(t)),'.nc'];

       else if(LDTRUN(t) < 1000)
           % name_t = [Location,'tho/THO_00000',num2str(LDTRUN(t)),'.nc'];
           % name_s = [Location,'sao/SAO_00000',num2str(LDTRUN(t)),'.nc'];
           % name_r = [Location,'roo/ROO_00000',num2str(LDTRUN(t)),'.nc'];
           name_p = [Location,'poo/POO_00000',num2str(LDTRUN(t)),'.nc'];
           name_u = [Location,'uoo/UOO_00000',num2str(LDTRUN(t)),'.nc'];
           name_v = [Location,'voe/VOE_00000',num2str(LDTRUN(t)),'.nc'];

        else if(LDTRUN(t) < 10000)
           % name_t = [Location,'tho/THO_0000',num2str(LDTRUN(t)),'.nc'];
           % name_s = [Location,'sao/SAO_0000',num2str(LDTRUN(t)),'.nc'];
           % name_r = [Location,'roo/ROO_0000',num2str(LDTRUN(t)),'.nc'];
           name_p = [Location,'poo/POO_0000',num2str(LDTRUN(t)),'.nc'];
           name_u = [Location,'uoo/UOO_0000',num2str(LDTRUN(t)),'.nc'];
           name_v = [Location,'voe/VOE_0000',num2str(LDTRUN(t)),'.nc'];

          else if(LDTRUN(t) < 100000)
           % name_t = [Location,'tho/THO_000',num2str(LDTRUN(t)),'.nc'];
           % name_s = [Location,'sao/SAO_000',num2str(LDTRUN(t)),'.nc'];
           % name_r = [Location,'roo/ROO_000',num2str(LDTRUN(t)),'.nc'];
           name_p = [Location,'poo/POO_000',num2str(LDTRUN(t)),'.nc'];
           name_u = [Location,'uoo/UOO_000',num2str(LDTRUN(t)),'.nc'];
           name_v = [Location,'voe/VOE_000',num2str(LDTRUN(t)),'.nc'];

          else if(LDTRUN(t) < 1000000)
           % name_t = [Location,'tho/THO_00',num2str(LDTRUN(t)),'.nc'];
           % name_s = [Location,'sao/SAO_00',num2str(LDTRUN(t)),'.nc'];
           % name_r = [Location,'roo/ROO_00',num2str(LDTRUN(t)),'.nc'];
           name_p = [Location,'poo/POO_00',num2str(LDTRUN(t)),'.nc'];
           name_u = [Location,'uoo/UOO_00',num2str(LDTRUN(t)),'.nc'];
           name_v = [Location,'voe/VOE_00',num2str(LDTRUN(t)),'.nc'];
          end
          end
        end
      end
     end
    end

    % roo = ncread(name_p,'ROO',...
    %              [iw+1 jn+1 1],[ie,je,ke]);
    poo = ncread(name_p,'POO',...
                 [iw+1 jn+1 1],[ie,je,ke]);
    uko = ncread(name_u,'UOO',...
                 [iw+1 jn+1 1],[ie+1,je,ke]);   
    vke = ncread(name_v,'VOE',...
                 [iw+1 jn+1 1],[ie,je+1,ke]);

    poo(weto_p==0)=0; poo = poo.*1025;

   % barotropical tidal currents
    u_bt = sum((uko).*dduo_grid,3)./deuto_grid; 
    v_bt = sum((vke).*ddue_grid,3)./deute_grid;    
    p_bt = sum((poo - poo_bg).*ddpo_grid,3)./depto_grid; 

   % decompose the pressure work
    for k = 1:ke
        uko(:,:,k) = uko(:,:,k) - u_bt(:,:);
        vke(:,:,k) = vke(:,:,k) - v_bt(:,:);  
       p_bc(:,:,k) = poo(:,:,k) - poo_bg(:,:,k) - p_bt(:,:);
    end
    
    % upstream scheme
    % We exclude the boundary up' and vp'
    % up(1:end-1,:) refers to UOO(1:end-1,:)
    % up(:,1:end-1) refers to VOE(:,1:end-1)
    % hence,up(end,:)=0; vp(:,end)=0
    up_layer_u(1:end-1,:,:) = ...
         uko(2:end-1,:,:).*p_bc(1:end-1,:,:).*ddpo_grid(1:end-1,:,:) .*(uko(2:end-1,:,:)>0) ...
       + uko(2:end-1,:,:).*p_bc(2:end,:,:).*ddpo_grid(2:end,:,:) .*(uko(2:end-1,:,:)<0);
        
    up_layer_v(:,1:end-1,:,:) = ...
         vke(:,2:end-1,:).*p_bc(:,1:end-1,:).*ddpo_grid(:,1:end-1,:) .*(vke(:,2:end-1,:)<0) ...
       + vke(:,2:end-1,:).*p_bc(:,2:end,:).*ddpo_grid(:,2:end,:) .*(vke(:,2:end-1,:)>0);   
           
     up_layer_u(weto_p==0)=0;
     up_layer_v(weto_p==0)=0;

     summie_u(:,:) = summie_u(:,:) + ((sum(up_layer_u,3))./depto_grid)*Dtime;
     summie_v(:,:) = summie_v(:,:) + ((sum(up_layer_v,3))./depto_grid)*Dtime;  


     disp([datestr(SDtime(t))])

end
Length = t_e - t_s + 1;

Flux_u = summie_u/(Dtime*Length); 
Flux_v = summie_v/(Dtime*Length);

Flux_u(isnan(depto_grid)==1)=nan;
Flux_v(isnan(depto_grid)==1)=nan;

save Linear_flux.mat Flux_u Flux_v
