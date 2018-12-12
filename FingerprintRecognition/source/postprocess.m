%------------------------------------------------------------------------
% [newlist] = postprocess(imthin,M,w1,w2,bound)
% 
% Hau xu li sau khi rut trich dac trung de loai bo dac trung sai
% 
% imthin       - anh da lam manh 
% M            - danh sach cac diem ki di da rut trich
% w1, w2       - kích thuoc block
% bound        - duong bien cua vung dong van tay
%------------------------------------------------------------------------
function [newlist] = postprocess(imthin,M,w1,w2,bound)
    n = size(M,1);
    [h,w] = size(imthin);
    newlist = zeros(n,4);
    count = 1;
 
% Xay dung cay nhi phan 2 chieu
    [r,c] = find(bound);
    lst = [r,c];
    tree = kdtree_build(lst);

    for k=1:n
        i = M(k,2);
        j = M(k,3);   
        idxs = kdtree_k_nearest_neighbors(tree, [i,j], 1);
        dist = sqrt((i - lst(idxs,1))^2 + (j - lst(idxs,2))^2);

% Diem can kiem tra duoc danh dau la diem ket thuc
        if (M(k,1) == 1)
            if (dist > w1/2)
                W = w1;
                if ((i-floor(W/2) >= 1) && (i+floor(W/2) <=h) && (j-floor(W/2) >= 1) && (j+floor(W/2) <= w))
                    t1 = imthin(i-floor(W/2):i+floor(W/2) , j-floor(W/2):j+floor(W/2));
                    s = real_end(t1,W);
                    if (s == 1)
                        newlist(count,:) = M(k,:);
                        count = count + 1;
                    end
                end
            end
        else
% Diem can kiem tra duoc danh dau la diem re nhanh  
            if (dist > w2/2)
                W = w2;
                if ((i-floor(W/2) >= 1) && (i+floor(W/2) <=h) && (j-floor(W/2) >= 1) && (j+floor(W/2) <= w))
                    t1 = imthin(i-floor(W/2):i+floor(W/2) , j-floor(W/2):j+floor(W/2));
                    [s1,s2,s3] = real_bifur(t1,W);
                    if (s1==1) && (s2==1) && (s3==1)
                        newlist(count,:) = M(k,:);
                        count = count + 1;
                    end
                end
            end
        end
    end
    
    newlist(count:n,:) = [];
% end function