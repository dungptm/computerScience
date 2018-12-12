%------------------------------------------------------------------------
% [s] = real_end(t1,W)
% 
% Kiem tra xem diem ket thuc dua vao co phai la diem ki di that
% 
% t1       - anh con chua diem ket thuc la diem anh trung tam 
% w        - kích thuoc block
%------------------------------------------------------------------------
function [s] = real_end(t1,W)
        s = 0;
        t2 = zeros(W,W);

        i = ceil(W/2); j = ceil(W/2);
        t2(i,j) = -1;
        flag = 1;
        while ((i~=1) && (i~=W) && (j~=1) && (j~=W))
            count = 0;
            if (t1(i-1,j-1) == 1 && t2(i-1,j-1) == 0)
                t2(i-1,j-1) = 1; count = count + 1; n1 = i-1; n2 = j-1;
            end
            if (t1(i-1,j) == 1 && t2(i-1,j) == 0)
                t2(i-1,j) = 1; count = count + 1; n1 = i-1; n2 = j;
            end
            if (t1(i-1,j+1) == 1 && t2(i-1,j+1) == 0)
                t2(i-1,j+1) = 1; count = count + 1; n1 = i-1; n2 = j+1;
            end

            if (t1(i,j-1) == 1 && t2(i,j-1) == 0)
                t2(i,j-1) = 1; count = count + 1; n1 = i; n2 = j-1;
            end
            if (t1(i,j+1) == 1 && t2(i,j+1) == 0)
                t2(i,j+1) = 1; count = count + 1; n1 = i; n2 = j+1;
            end

            if (t1(i+1,j-1) == 1 && t2(i+1,j-1) == 0)
                t2(i+1,j-1) = 1; count = count + 1; n1 = i+1; n2 = j-1;
            end
            if (t1(i+1,j) == 1 && t2(i+1,j) == 0)
                t2(i+1,j) = 1; count = count + 1; n1 = i+1; n2 = j;
            end
            if (t1(i+1,j+1) == 1 && t2(i+1,j+1) == 0)
                t2(i+1,j+1) = 1; count = count + 1; n1 = i+1; n2 = j+1;
            end

            if (count ~= 1)
                flag = 0;
                break;
            end

            i = n1;
            j = n2;
        end

        if (flag == 1)
            s1 = sum(sum(t2(:,1)));
            s2 = sum(sum(t2(:,W)));
            s3 = sum(sum(t2(1,:)));
            s4 = sum(sum(t2(W,:)));
            s = s1 + s2 + s3 + s4;
        end
% end function