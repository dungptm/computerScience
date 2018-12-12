function oskel = removeCorner(skel)

    oskel = skel;
    [m,n] = size(oskel);
    
    % mask1
    mask_1 = [0 1 0;1 1 1];
    % mask 2
    mask_2 = [1 1;1 0;0 1];
    sol_mask_2 = [1 1;0 1;0 1]; 
    for i=2:m-1
        for j=2:n-1
            m1_1 = oskel(i-1:i,j-1:j+1);
            m1_2 = oskel(i-1:i+1,j-1:j);
            m1_3 = oskel(i:i+1,j-1:j+1);
            m1_4 = oskel(i-1:i+1,j:j+1);
    
            if(isequal(m1_1,mask_1))
                oskel(i,j) = 0;
            end
            
            if(isequal(m1_2',mask_1))
                oskel(i,j) = 0;
            end
            
            if(isequal(flipud(m1_3),mask_1))
                oskel(i,j) = 0;
            end
            
            if(isequal(flipud(m1_4'),mask_1))
                oskel(i,j) = 0;
            end
            
            m2_1 = oskel(i-1:i+1,j:j+1);
            if(isequal(m2_1,mask_2))
                oskel(i-1:i+1,j:j+1) = sol_mask_2;
            end
            
        end
    end        
end