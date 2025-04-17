function [U] = project_line_u_new(u,v,theta)
% The theta is the less than 90 and larger than 0
% Theta Larger than 90 is also right!!!
% 求取切线速度
[M,N] = size(u);
% alpah = zeros(M);

for i = 1 : M
    for j =1:N
       U(i,j) = u(i,j)*cosd(90-theta) - v(i,j)*cosd(theta);
    end
end


