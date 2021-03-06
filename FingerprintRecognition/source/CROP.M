%--------------------------------------------------------------------------
% [im,m,b] = crop(img,msk,bound)
%
% Thu gon k�ch thuoc anh v�n tay theo mat na v�ng v�n tay de l�m tang hieu 
% suat xu l� tr�n anh o c�c buoc sau.
% 
% img       - anh goc 
% msk       - mat na v�ng v�n tay
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