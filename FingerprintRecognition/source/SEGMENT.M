%--------------------------------------------------------------------------
% [msk,bound]= segment(img,iters,verbose)
%
% Tach v�ng anh v�n tay va tim bien cua vung van tay tu v�ng anh nen dua 
% v�o c�c ph�p to�n h�nh th�i hoc
% 
% img       - anh goc 
% verbose   - neu c� gi� tri l� 1 se hien thi ket qua phan doan
%--------------------------------------------------------------------------
function [msk,bound]    =   segment(img,verbose)
    [ht,wt]     =   size(img);
    y           =   im2double(img);
    img         =   im2double(img);
    ITERS       =   4;
    %-----------------
    %T�nh mat na v�ng
    %-----------------
    for i=1:ITERS
        y           =   imerode(y,ones(5,5));      %khuech t�n bang ma tran 5x5      
        c           =   y.^2;                       %tang do tuong phan
        msk         =   ~im2bw(c,get_threshold(c)); %t�m mat na v�ng
        %------------------------------------------------------------------
        %Loai bo nhung v�ng c� the ph�t trien lan v�o v�ng v�n tay can d�ng
        %------------------------------------------------------------------
        if(i == 2)
            small       =   msk & ~bwareaopen(msk,floor(0.1*ht*wt),4);
            y(small==1) =   sum(sum(img))/(ht*wt);
        end;

        %---------------------------------------------------
        %Hien thi ket qua sau moi vong lap
        %---------------------------------------------------
        if(verbose==1)
            subplot(1,4,1),imagesc(img),title('Original');
            subplot(1,4,2),imagesc(y),title('Eroded');
            subplot(1,4,3),imagesc(c);colormap('gray'),title('Enhanced');
            subplot(1,4,4),imagesc(msk),title('Segmented');
            pause;
            drawnow;
        end;
    end;
    %----------------------------------------------
    %Lay ma tran lon nhat -> v�ng v�n tay can d�ng
    %----------------------------------------------
    msk = bwareaopen(msk,round(0.15*ht*wt));
    msk = imerode(msk,ones(13,13));           %co bi�n d�ng v�ng v�n tay   
    msk = imfill(msk,'holes');              %lap c�c lo tr�n mat na v�ng

    bound = bwmorph(msk,'remove');          %lay bien cua mat na
    
    %---------------------------------------------------
    %Hien thi ket qua cuoi c�ng
    %---------------------------------------------------
    if(verbose==1)
        figure, imagesc(msk.*img),axis image,colormap('gray'),title('Anh da duoc dong vung van tay');
    end;
%end function

