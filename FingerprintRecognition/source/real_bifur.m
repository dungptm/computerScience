%------------------------------------------------------------------------
% [s1,s2,s3] = real_bifur(t1,W)
% 
% Kiem tra xem diem re nhanh dua vao co phai la diem ki di that
% 
% t1       - anh con chua diem re nhanh la diem anh trung tam 
% w        - kích thuoc block
%------------------------------------------------------------------------
function [s1,s2,s3] = real_bifur(t1,W)
        s1 = 0; s2 = 0; s3 = 0;
        t2 = zeros(W,W);

        i = ceil(W/2); j = ceil(W/2);
        t2(i,j) = -1;
        
        count = 0;
        if (t1(i-1,j-1) == 1 && t2(i-1,j-1) == 0)
            count = count + 1;
            if (count == 1)
                t2(i-1,j-1) = 1; i1 = i-1; j1 = j-1;
            else if (count == 2)
                    t2(i-1,j-1) = 2; i2 = i-1; j2 = j-1;
                else if (count == 3)
                        t2(i-1,j-1) = 3; i3 = i-1; j3 = j-1;
                    end
                end
            end
        end
        if (t1(i-1,j) == 1 && t2(i-1,j) == 0)
            count = count + 1;
            if (count == 1)
                t2(i-1,j) = 1; i1 = i-1; j1 = j;
            else if (count == 2)
                    t2(i-1,j) = 2; i2 = i-1; j2 = j;
                else if (count == 3)
                        t2(i-1,j) = 3; i3 = i-1; j3 = j;
                    end
                end
            end
        end
        if (t1(i-1,j+1) == 1 && t2(i-1,j+1) == 0)
            count = count + 1;
            if (count == 1)
                t2(i-1,j+1) = 1; i1 = i-1; j1 = j+1;
            else if (count == 2)
                    t2(i-1,j+1) = 2; i2 = i-1; j2 = j+1;
                else if (count == 3)
                        t2(i-1,j+1) = 3; i3 = i-1; j3 = j+1;
                    end
                end
            end
        end

        if (t1(i,j-1) == 1 && t2(i,j-1) == 0)
            count = count + 1;
            if (count == 1)
                t2(i,j-1) = 1; i1 = i; j1 = j-1;
            else if (count == 2)
                    t2(i,j-1) = 2; i2 = i; j2 = j-1;
                else if (count == 3)
                        t2(i,j-1) = 3; i3 = i; j3 = j-1;
                    end
                end
            end
        end
        if (t1(i,j+1) == 1 && t2(i,j+1) == 0)
            count = count + 1;
            if (count == 1)
                t2(i,j+1) = 1; i1 = i; j1 = j+1;
            else if (count == 2)
                    t2(i,j+1) = 2; i2 = i; j2 = j+1;
                else if (count == 3)
                        t2(i,j+1) = 3; i3 = i; j3 = j+1;
                    end
                end
            end
        end

        if (t1(i+1,j-1) == 1 && t2(i+1,j-1) == 0)
            count = count + 1;
            if (count == 1)
                t2(i+1,j-1) = 1; i1 = i+1; j1 = j-1;
            else if (count == 2)
                    t2(i+1,j-1) = 2; i2 = i+1; j2 = j-1;
                else if (count == 3)
                        t2(i+1,j-1) = 3; i3 = i+1; j3 = j-1;
                    end
                end
            end
        end
        if (t1(i+1,j) == 1 && t2(i+1,j) == 0)
            count = count + 1;
            if (count == 1)
                t2(i+1,j) = 1; i1 = i+1; j1 = j;
            else if (count == 2)
                    t2(i+1,j) = 2; i2 = i+1; j2 = j;
                else if (count == 3)
                        t2(i+1,j) = 3; i3 = i+1; j3 = j;
                    end
                end
            end
        end
        if (t1(i+1,j+1) == 1 && t2(i+1,j+1) == 0)
            count = count + 1;
            if (count == 1)
                t2(i+1,j+1) = 1; i1 = i+1; j1 = j+1;
            else if (count == 2)
                    t2(i+1,j+1) = 2; i2 = i+1; j2 = j+1;
                else if (count == 3)
                        t2(i+1,j+1) = 3; i3 = i+1; j3 = j+1;
                    end
                end
            end
        end

        if (count == 3)
            [t2,s1] = label(t1,t2,i1,j1,1,W);
            [t2,s2] = label(t1,t2,i2,j2,2,W);
            [t2,s3] = label(t1,t2,i3,j3,3,W);
        end
% end function