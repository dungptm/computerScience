%--------------------------------------------------------------------------
% [msk,bound]= segment(img,iters,verbose)
%
% Tach vùng anh vân tay va tim bien cua vung van tay tu vùng anh nen dua 
% vào các phép toán hình thái hoc
% 
% img       - anh goc 
% verbose   - neu có giá tri là 1 se hien thi ket qua phan doan
%--------------------------------------------------------------------------
function [msk,bound]    =   segment(img,verbose)
    [ht,wt]     =   size(img);
    y           =   im2double(img);
    img         =   im2double(img);
    ITERS       =   4;
    %-----------------
    %Tính mat na vùng
    %-----------------
    for i=1:ITERS
        y           =   imerode(y,ones(5,5));      %khuech tán bang ma tran 5x5      
        c           =   y.^2;                       %tang do tuong phan
        msk         =   ~im2bw(c,get_threshold(c)); %tìm mat na vùng
        %------------------------------------------------------------------
        %Loai bo nhung vùng có the phát trien lan vào vùng vân tay can dóng
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
    %Lay ma tran lon nhat -> vùng vân tay can dóng
    %----------------------------------------------
    msk = bwareaopen(msk,round(0.15*ht*wt));
    msk = imerode(msk,ones(13,13));           %co biên dóng vùng vân tay   
    msk = imfill(msk,'holes');              %lap các lo trên mat na vùng

    bound = bwmorph(msk,'remove');          %lay bien cua mat na
    
    %---------------------------------------------------
    %Hien thi ket qua cuoi cùng
    %---------------------------------------------------
    if(verbose==1)
        figure, imagesc(msk.*img),axis image,colormap('gray'),title('Anh da duoc dong vung van tay');
    end;
%end function

