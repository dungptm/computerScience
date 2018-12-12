%------------------------------------------------------------------------
% [u,v] = find_tx_point(x,y,th)
% 
% Tìm tín hieu x
% 
% x     - toa do dòng
% y     - toa do cot
% th    - huong cuc bo tai block dang xét
%------------------------------------------------------------------------
function [u,v] = find_tx_point(x,y,th)
    u = x*cos(th)-y*sin(th);
    v = x*sin(th)+y*cos(th);
%end fuction