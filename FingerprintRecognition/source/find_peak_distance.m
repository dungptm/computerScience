%------------------------------------------------------------------------
% f = find_peak_distance(x)
% 
% Tìm khoang cách giua các dinh trong tín hieu x
% 
% x     - tín hieu x
%------------------------------------------------------------------------
function f = find_peak_distance(x)
    len     =   length(x);
    p       =   [];
    x       =   x-mean(x);
    s       =   abs(fft(x,128));
    idx     =   find(s == max(s));
    f       =   128/idx(1);
%end function