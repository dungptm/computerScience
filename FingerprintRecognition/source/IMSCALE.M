%-----------------------------------------------------
% y = imscale(x)
%
% Chuan hoa anh de moi diem anh deu co gia tri trong khoang [0-1]
% 
% x     - anh can chuan hoa
%-----------------------------------------------------
function y = imscale(x)
    mn = min(min(x));
    mx = max(max(x));
    y  = (x-mn)/(mx-mn);
%end function