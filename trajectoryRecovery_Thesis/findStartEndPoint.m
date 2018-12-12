function [idx_start_point,idx_end_point] = findStartEndPoint(vertices,m_adjacent,stroke_width)

% start point: most left e point
% end point: most right e point
% consider left right and top bottom value
    eps = 2*stroke_width;
    idx_start_point = 0;
    idx_end_point = 0;
    
    % initialize value is not important
    [most_right, default_idx_end] = min(vertices(:,2)); % 0 
    [most_left,default_idx_start] = max(vertices(:,2)); % max value
    
    % 1 vertex
    if(size(vertices,1)==1)
        idx_start_point = 1;
        idx_end_point = idx_start_point;
        return;
    end
    
    for i=1:size(m_adjacent,1)
        % start or end point
        if(mod(sum(m_adjacent(i,:)),2)==1)
            t1 = most_left - vertices(i,2);
            if(t1 >= 0 ...
            || ...
            ((idx_start_point~=0 && abs(t1) < eps) && (vertices(i,1) < vertices(idx_start_point,1))) ...
            )
                most_left = vertices(i,2);
                idx_start_point = i;
            end
            
            t2 = most_right - vertices(i,2);
            if(t2 <= 0 ...
            || ...
            ((idx_end_point~=0 && abs(t2) < eps) && (vertices(i,1) > vertices(idx_start_point,1))) ...
                    )
                most_right = vertices(i,2);
                idx_end_point = i;
            end
        end
    end
    
    for i=1:size(m_adjacent,1)
        % start or end point, no odd vertex, consider even vertex
        if(mod(sum(m_adjacent(i,:)),2) == 0 ...
            && sum(m_adjacent(i,:)) ~= 0)
            
            t1 = most_left - vertices(i,2);
            if( ...
            (idx_start_point==0 && t1 >= 0) ...
            || ...
            ((idx_start_point==0 && abs(t1) < eps) && (vertices(i,1) < vertices(idx_start_point,1))) ...
            )
                most_left = vertices(i,2);
                idx_start_point = i;
            end
            
            t2 = most_right - vertices(i,2);
            if( ...
            (idx_end_point==0 && t2 <= 0) ...
            || ...
            ((idx_end_point==0 && abs(t2) < eps) && (vertices(i,1) > vertices(idx_start_point,1))) ...
            )
                most_right = vertices(i,2);
                idx_end_point = i;
            end
        end
    end
    
    if(idx_start_point == 0)        
        fprintf('***********************************\n');
        fprintf('ERROR - CANNOT FIND START POINT\n');
        %fprintf('WARN - USING DEFAULT VALUE OF START END POINT\n');
        fprintf('***********************************\n');
    end
    if(idx_end_point == 0)        
        fprintf('***********************************\n');
        fprintf('ERROR - CANNOT FIND END POINT\n');
        %fprintf('WARN - USING DEFAULT VALUE OF START END POINT\n');
        fprintf('***********************************\n');
    end
end