%------------------------------------------------------------------------
% [percent] = match_minutiae(lst_test,lst_tmp)
% 
% Tinh so luong dac trung khop giua 2 vector dac trung dau vao
% 
% lst_test     - danh sach dac trung cua vector can chung thuc 
% lst_tmp      - danh sach dac trung cua vector da luu tru
%------------------------------------------------------------------------
function [percent] = match_minutiae(lst_test,lst_tmp)
    s1 = size(lst_test);
    max = 0;
        
    tree = kdtree_build(lst_tmp(:, 2:3));
    for k1=1:s1(1)/2
        q = [lst_test(k1,2),lst_test(k1,3)];
        idxs = kdtree_k_nearest_neighbors(tree,q,3);
        
        for k2=1:3
            trans_all1 = transform_minutiae(lst_test,k1);
            trans_all2 = transform_minutiae(lst_tmp,idxs(k2));

            if (size(trans_all1)<size(trans_all2))
                count = count_matched(trans_all1,trans_all2);
            else
                count = count_matched(trans_all2,trans_all1);
            end

            if (max<count)
                max = count;
            end  
        end
    end

    percent = max/min(size(lst_test,1),size(lst_tmp,1));
end