function [count] = count_matched(list1,list2)
    count = 0;
    xyrange = 15;
    sl1 = size(list1);
    tree = kdtree_build(list2(:,2:3));
                            
    for i=1:sl1
        idxs = kdtree_k_nearest_neighbors(tree,list1(i,2:3),1);
        if (abs(list1(i,2)-list2(idxs,2)) < xyrange && abs(list1(i,3)-list2(idxs,3)) < xyrange && abs(list1(i,4)-list2(idxs,4)) < pi/6 && list1(i,1)==list2(idxs,1))
                count = count+1;     
        end
    end
end