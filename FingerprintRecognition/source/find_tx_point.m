%------------------------------------------------------------------------
% [u,v] = find_tx_point(x,y,th)
% 
% T�m t�n hieu x
% 
% x     - toa do d�ng
% y     - toa do cot
% th    - huong cuc bo tai block dang x�t
%------------------------------------------------------------------------
function [u,v] = find_tx_point(x,y,th)
    u = x*cos(th)-y*sin(th);
    v = x*sin(th)+y*cos(th);
%end fuction