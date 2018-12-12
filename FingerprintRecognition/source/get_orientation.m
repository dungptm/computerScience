%------------------------------------------------------------------------
% oimg = get_orientation(img,N)
% 
% X�c dinh huong bao qu�t theo tung block trong anh
% 
% img   - anh can x�c dinh huong
% N     - k�ch thuoc block
%------------------------------------------------------------------------
function oimg = get_orientation(img,N)
    g       = complex_gradient(img);
    gblk    = blkproc(g.^2,[N N],inline('sum(sum(x))'));
    oimg    = 0.5*angle(gblk)+pi/2;
%end function