function [U] = project_line_v_new(u,v,theta)
% The theta is the less than 90 and larger than 0
% 求取发香速度
[M,N] = size(u);

for i = 1 : M
    for j = 1 : N
        U(i,j) = u(i,j)*cosd(theta) + v(i,j)*cosd(90-theta);
    end
end

