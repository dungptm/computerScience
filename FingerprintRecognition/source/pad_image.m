%-----------------------------------------------------------
% y = pad_image(x,N)
% 
% Tang k�ch thuoc ma tran de k�ch thuoc l� cap so nh�n cua N
% 
% x    - ma tran
% N    - k�ch thuoc block de chia anh trong qu� tr�nh xu l�
%-----------------------------------------------------------
function y = pad_image(x,N)
    [ht,wt] = size(x);
    
    padcol  = N-mod(wt,N);
    if(padcol ~= N) %can tang k�ch thuoc
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
