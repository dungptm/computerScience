%------------------------------------------------------------------------
% nimg = normalize(img,m0,v0)
% 
% Chuan hóa anh
%
% img     - anh can chuan hóa
% m0      - giá tri trung bình mong muon
% v0      - do dao dong muc xám mong muon
%------------------------------------------------------------------------
function nimg = normalize(img,m0,v0)
    [ht,wt] =   size(img);
    %Tính giá tri trung bình và do dao dong muc xám cua anh
    m       =   mean(img(:));
    v       =   var(img(:));
    
    gmidx   =   find(img > m); %Các diem anh có giá tri lon hon giá tri trung bình
    lmidx   =   find(img <= m); %Các diem anh có giá tri nho hon giá tri trung bình
    
    nimg(gmidx) = m0 + sqrt((v0*(img(gmidx)-m).^2)/v);
    nimg(lmidx) = m0 - sqrt((v0*(img(lmidx)-m).^2)/v);
    nimg        = reshape(nimg,[ht,wt]);
%end function