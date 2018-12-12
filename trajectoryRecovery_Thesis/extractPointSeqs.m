function seq = extractPointSeqs(single_stroke, start_point, end_point)

    [m,n] = size(single_stroke);    
    seq = start_point;
    r_cur = start_point(1,1); % row
    c_cur = start_point(1,2); % column
    stroke_tmp = single_stroke;
    flag_findPoint = 0;
    flag_loop = 0;
    if(isequal(start_point,end_point))
        flag_loop = 1;
    end
    while(1)
        % neighbors of current pixel
        flag_findPoint = 0;
       
        % change temporarily because current implementation delete the
        % junction and its 3x3 neighbors
                
        if(isequal(start_point,[r_cur c_cur]))
            rmin = max(1,r_cur-1);
            rmax = min(r_cur+1,m);
            cmin = max(1,c_cur-1);
            cmax = min(c_cur+1,n);
        else
            rmin = max(1,r_cur-1);
            rmax = min(r_cur+1,m);
            cmin = max(1,c_cur-1);
            cmax = min(c_cur+1,n);
        end
        
        for r=rmin:rmax
            for c=cmin:cmax
                if(isequal([r c], start_point)==0 && ...
                    stroke_tmp(r,c) ~= 0)
                    flag_findPoint = 1;
                    r_cur = r;
                    c_cur = c;
                    seq = [seq; r c];
                    stroke_tmp(r,c) = 0;
                    break;                
                end
                % check for loop
                if(flag_loop && isequal([r c],start_point) && size(seq,1)>1)
                    flag_findPoint = 1;
                    r_cur = r;
                    c_cur = c;
                    seq = [seq; r c];
                    stroke_tmp(r,c) = 0;
                    break;                           
                end
            end            
            if(flag_findPoint)                
                break;
            end
        end
        if(flag_findPoint==0 || ...
            isequal([r c],end_point))% meet end point            
            break;
        end
    end
    
end
%end function