%------------------------------------------------------------------------
% f = find_peak_distance(x)
% 
% T�m khoang c�ch giua c�c dinh trong t�n hieu x
% 
% x     - t�n hieu x
%------------------------------------------------------------------------
function f = find_peak_distance(x)
    len     =   length(x);
    p       =   [];
    x       =   x-mean(x);
    s       =   abs(fft(x,128));
    idx     =   find(s == max(s));
    f       =   128/idx(1);
%end function