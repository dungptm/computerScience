%------------------------------------------------------------------------
% [T] = thin(im)
% 
% Lam manh anh
% 
% im       - anh da nhi phan 
%------------------------------------------------------------------------
function [T] = thin(im)
    T = bwmorph(im,'thin',Inf);
    T = bwmorph(T,'spur');
    T = bwmorph(T,'hbreak');
    T = bwmorph(T,'clean',Inf);
% end function