%--------------------------------------------------------------------------
% [im,m,b] = crop(img,msk,bound)
%
% Thu gon kích thuoc anh vân tay theo mat na vùng vân tay de làm tang hieu 
% suat xu lý trên anh o các buoc sau.
% 
% img       - anh goc 
% msk       - mat na vùng vân tay
%--------------------------------------------------------------------------
function [im,m,b] = crop(img,msk,bound)  

    [r,c] = find(msk);
    rmin = min(r);
    rmax = max(r);
    cmin = min(c);
    cmax = max(c);

    im = img(rmin:rmax,cmin:cmax);
    m = msk(rmin:rmax,cmin:cmax);
    b = bound(rmin:rmax,cmin:cmax);
%end function