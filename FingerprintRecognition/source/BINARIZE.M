%------------------------------------------------------------------------
% [B] = binarize(im,msk,blksze)
% 
% Nhi phan hoa anh
% 
% img       - anh da nang cao chat luong 
% msk       - mat na vung
% blksze    - kích thuoc block
%------------------------------------------------------------------------
function [B] = binarize(im,msk,blksze)
    [w,h] = size(im);
    B = zeros(w,h);
    W = blksze;
    
    for i=1:W:w
        for j=1:W:h
            if (i+W-1 <= w && j+W-1 <= h)
                thresh = get_threshold(im(i:i+W-1 , j:j+W-1));                
                B(i:i+W-1 , j:j+W-1) = im(i:i+W-1 , j:j+W-1) < thresh & msk(i:i+W-1 , j:j+W-1);
            end
        end
    end
% end fuction