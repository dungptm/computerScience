%------------------------------------------------------------------------
% oimg = smoothen_orientation_field(oimg)
% 
% L�m tron huong cuc bo cua duong v�n trong anh su dung bo loc Gauss
% 
% oimg      - anh huong
%------------------------------------------------------------------------
function oimg = smoothen_orientation_field(oimg)
    g   =   cos(2*oimg)+i*sin(2*oimg);
    g   =   imfilter(g,fspecial('gaussian',5));
    oimg=   0.5*angle(g);
%end function