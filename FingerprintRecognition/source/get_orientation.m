%------------------------------------------------------------------------
% oimg = get_orientation(img,N)
% 
% Xác dinh huong bao quát theo tung block trong anh
% 
% img   - anh can xác dinh huong
% N     - kích thuoc block
%------------------------------------------------------------------------
function oimg = get_orientation(img,N)
    g       = complex_gradient(img);
    gblk    = blkproc(g.^2,[N N],inline('sum(sum(x))'));
    oimg    = 0.5*angle(gblk)+pi/2;
%end function