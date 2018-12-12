%------------------------------------------------------------------------
% [t,flag] = label(t1,t2,i,j,label,W)
% 
% Danh dau lan can cho diem re nhanh dang xet
% 
% t1       - 
% W        - kích thuoc block
%------------------------------------------------------------------------
function [t,flag] = label(t1,t2,i,j,label,W)
        flag = 1;
        while ((i~=1) && (i~=W) && (j~=1) && (j~=W))
            count = 0;
            if (t1(i-1,j-1) == 1 && t2(i-1,j-1) == 0)
                t2(i-1,j-1) = label; count = count + 1; n1 = i-1; n2 = j-1;
            end
            if (t1(i-1,j) == 1 && t2(i-1,j) == 0)
                t2(i-1,j) = label; count = count + 1; n1 = i-1; n2 = j;
            end
            if (t1(i-1,j+1) == 1 && t2(i-1,j+1) == 0)
                t2(i-1,j+1) = label; count = count + 1; n1 = i-1; n2 = j+1;
            end

            if (t1(i,j-1) == 1 && t2(i,j-1) == 0)
                t2(i,j-1) = label; count = count + 1; n1 = i; n2 = j-1;
            end
            if (t1(i,j+1) == 1 && t2(i,j+1) == 0)
                t2(i,j+1) = label; count = count + 1; n1 = i; n2 = j+1;
            end

            if (t1(i+1,j-1) == 1 && t2(i+1,j-1) == 0)
                t2(i+1,j-1) = label; count = count + 1; n1 = i+1; n2 = j-1;
            end
            if (t1(i+1,j) == 1 && t2(i+1,j) == 0)
                t2(i+1,j) = label; count = count + 1; n1 = i+1; n2 = j;
            end
            if (t1(i+1,j+1) == 1 && t2(i+1,j+1) == 0)
                t2(i+1,j+1) = label; count = count + 1; n1 = i+1; n2 = j+1;
            end

            if (count ~= 1)
                flag = 0;
                break;
            end

            i = n1;
            j = n2;
        end
    t = t2;
% end function