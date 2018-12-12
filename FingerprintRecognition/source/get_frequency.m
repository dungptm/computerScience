%------------------------------------------------------------------------
% fimg = get_frequency(img,oimg,N)
% 
% Xác dinh tan so cuc bo cua tung block anh tu khoang cách trung bình giua 
% các duong vân trong moi block dua vào khoang cách giua các dinh duong vân
% 
% img       - anh can xác dinh tan so
% oimg      - anh huong
% N         - kích thuoc block
%------------------------------------------------------------------------
function fimg = get_frequency(img,oimg,N)
    dbg_show_lines  =   0;
    dbg_show_windows=   0;
    [x,y]           =   meshgrid(-8:7,-16:15);
    [blkht,blkwt]   =   size(oimg);
    [ht,wt]         =   size(img);

    if(dbg_show_lines)
       imagesc(img),axis image,colormap('gray');
    end;
    
    yidx = 1; %chi so cua block theo dòng
    for i = 0:blkht-1
        row     = (i*N+N/2);%+N de tang kích thuoc
        xidx    = 1; %chi so cua block theo cot
        for j = 0:blkwt-1
            col = (j*N+N/2);
            %------------------------------------------------
            %row,col xác dinh chi so cua diem anh trung tâm
            %------------------------------------------------
            th  = oimg(yidx,xidx);
            if(dbg_show_lines)
                [lx,ly] = find_tx_point(-8,0,th);
                [rx,ry] = find_tx_point(8,0,th);
                [tx,ty] = find_tx_point(0,16,th);
                [bx,by] = find_tx_point(0,-16,th);
                hold on;line([lx+col;rx+col],[ly+row;ry+row],'color','red','lineWidth',2)
                hold on;line([tx+col;bx+col],[ty+row;by+row],'color','blue','lineWidth',2);
                pause;
            end;
            [u,v]       =   find_tx_point(x,y,th);
            u           =   round(u+col); u(u<1)  = 1; u(u>wt) = wt;
            v           =   round(v+row); v(v<1)  = 1; v(v>ht) = ht;
            %--------------------------------------
            %Tìm block dã dinh huong
            %--------------------------------------
            idx         =   sub2ind(size(img),v,u);
            blk         =   img(idx);
            blk         =   reshape(blk,[32,16]);
            %-------------------------------------
            %Tìm tín hieu x
            %-------------------------------------
            xsig        =   sum(blk,2);
            if(dbg_show_windows)
                subplot(1,2,1),imagesc(blk),colormap('gray'),axis image;
                subplot(1,2,2),plot(xsig);
                pause;
            end;
            fimg(yidx,xidx) = find_peak_distance(xsig);
            xidx = xidx +1;
        end;
        yidx = yidx +1;
    end;
%end function