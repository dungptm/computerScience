%--------------------------------------------------------------------------
% t = get_threshold(img)
%
% C�i dat phuong ph�p t�m nguong theo gi� tri x�m cua anh cua t�c gia Otsu
% 
% Tham khao:
% Otsu, A Threshold Selection Method from Gray-Level Histogram, IEEE Trans.
% on Systems, Man and Cybernetics, 1979
%--------------------------------------------------------------------------
function t = get_threshold(img)
    [ht,wt] = size(img);
    [p,x]   = imhist(img,256);
    p       = p/(ht*wt);
    w       = zeros(1,256);
    m       = zeros(1,256);
    w(1)    = p(1);
    m(1)    = p(1);
    for i=2:256
        w(i)= w(i-1)+p(i);
        m(i)= i*p(i)+m(i-1);
    end;
    mt = m(end);
    w  = w+eps;
    sigma_b = ((mt*w-m).^2)./(w.*(1-w));
    t       = find(sigma_b == max(sigma_b));
    t       = x(t(1));
%end function
