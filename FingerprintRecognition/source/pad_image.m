%-----------------------------------------------------------
% y = pad_image(x,N)
% 
% Tang kích thuoc ma tran de kích thuoc là cap so nhân cua N
% 
% x    - ma tran
% N    - kích thuoc block de chia anh trong quá trình xu lý
%-----------------------------------------------------------
function y = pad_image(x,N)
    [ht,wt] = size(x);
    
    padcol  = N-mod(wt,N);
    if(padcol ~= N) %can tang kích thuoc
        padleft = floor(padcol/2);
        padright= padcol-padleft;
        x       = [ones(ht,padleft),x,ones(ht,padright)];
    else
        padcol  = 0;
    end;
    
    padrow  = N-mod(ht,N);
    if(padrow~= N) 
        padtop = floor(padrow/2);
        padbot = padrow-padtop;
        x      = [ones(padtop,padcol+wt);x;ones(padbot,padcol+wt)];
    else        
        padrow = 0;
    end;
    y = x;
%end function
