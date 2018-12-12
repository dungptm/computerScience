%------------------------------------------------------------------------
% nimg = normalize(img,m0,v0)
% 
% Chuan h�a anh
%
% img     - anh can chuan h�a
% m0      - gi� tri trung b�nh mong muon
% v0      - do dao dong muc x�m mong muon
%------------------------------------------------------------------------
function nimg = normalize(img,m0,v0)
    [ht,wt] =   size(img);
    %T�nh gi� tri trung b�nh v� do dao dong muc x�m cua anh
    m       =   mean(img(:));
    v       =   var(img(:));
    
    gmidx   =   find(img > m); %C�c diem anh c� gi� tri lon hon gi� tri trung b�nh
    lmidx   =   find(img <= m); %C�c diem anh c� gi� tri nho hon gi� tri trung b�nh
    
    nimg(gmidx) = m0 + sqrt((v0*(img(gmidx)-m).^2)/v);
    nimg(lmidx) = m0 - sqrt((v0*(img(lmidx)-m).^2)/v);
    nimg        = reshape(nimg,[ht,wt]);
%end function