clear;clc;close all
% addpath /gxfs_home/geomar/smomw557/Model_H2/seawater_ver3_3.1
addpath ../Model_info/
load('Time_info.mat', 'SDtime','LDTRUN','time_index')
%% Density coordinates
% Mixed Layers excluded
r_min = 24.0;
r_max = 30.0;
r_inv = 0.2;
R_upper = [r_min:r_inv:r_max];
% Bottom Mixed Layers excluded
% we do not care about the area
% r_min = 30.5;
% r_max = 40.0;
% r_inv = 0.5;
% R_lower = [r_min:r_inv:r_max];
% R = [R_upper,R_lower];
R = R_upper;
KE = length(R);
%%
load('Grid_info.mat','ke','weto_p','ddpo_grid','depto_grid','zzout');
% iw = 15;ie = 1;
% jn = 15;js = 15;
% weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
% zzout  = Exclude_sponge(iw,ie,jn,js,zzout);
% ddpo_grid  = Exclude_sponge(iw,ie,jn,js,ddpo_grid);
% depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
iw = 0;ie = 0;
jn = 0;js = 0;

ie = size(depto_grid,1);
je = size(depto_grid,2);

zao_ini = zeros(ie,je,KE);
Location = ['../data/'];
Save_Location = ['./zao/'];
for t= 1:1:1
     % name_t = [Location,'tho/THO_0000000',num2str(LDTRUN(t)),'.nc'];
     % name_s = [Location,'sao/SAO_0000000',num2str(LDTRUN(t)),'.nc'];
     name_p = [Location,'poo/POO_0000000',num2str(LDTRUN(t)),'.nc'];
     name_r = [Location,'roo/ROO_0000000',num2str(LDTRUN(t)),'.nc'];
    % tho = ncread(name_t,'THO',...
    %               [iw+1 jn+1 1],[ie,je,ke]);     
    % sao = ncread(name_s,'SAO',...
    %              [iw+1 jn+1 1],[ie,je,ke]);   
    poo = ncread(name_p,'POO',...
                 [iw+1 jn+1 1],[ie,je,ke]);
    rao = ncread(name_r,'ROO',...
                 [iw+1 jn+1 1],[ie,je,ke]);

% 1 decibar to Pascal = 10000 Pascal
    poo = poo*1025;
     % poo = poo*1025*1e-4;
     % rao = sw_dens(sao,tho,poo);

     for i = 1:size(rao,1)
        for j = 1:size(rao,2)
               if (weto_p(i,j,1) ~= 0) 
                   clear r_point Z_point mask
                   r_point = rao(i,j,:) - 1000;
                   r_point = squeeze(r_point);
                   z_point = squeeze(zzout(i,j,:));
                   % mask = squeeze(weto_p(i,j,:));
                   % if sum(mask) <= 5
                   % -------25 m depth Excluded-------
                   %      zao_ini(i,j,:)  = nan;
                   % ---------------------------------
                   % else
                   % -------Mixed Layer Exclued-------
                   %      mask(1:3) = 0;
                   %      r_point(mask==0)=[];
                   %      z_point(mask==0)=[];
                   %      Z_point = Density_interp1(r_point,z_point,R); 
                   %      zao_ini(i,j,:)  = Z_point;
                   % end
                   Z_point = Density_interp1(r_point,z_point,R); 
                   % Z_point = interp1(r_point,z_point,R); 

                   zao_ini(i,j,:)  = Z_point;
               else
                   zao_ini(i,j,:)  = nan;
               end
        end
     end

end

rao_ini = rao;
poo_ini = poo;
save Density_coordinates.mat R KE zao_ini rao_ini poo_ini