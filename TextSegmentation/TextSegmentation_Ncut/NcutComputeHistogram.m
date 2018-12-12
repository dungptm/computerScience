function [H] = NcutComputeHistogram(V, numLevel)
    H = [];
    p = 255/numLevel;    
    j = 1;
    [m,n,c] = size(V);
    if( c == 3)
        % convert to principal color y = 0.3R + 0.59G + 0.11B
        V = 0.3*V(:,1) + 0.59*V(:,2) + 0.11*V(:,3);
    end
    for i=1:numLevel-1
        ind = [];        
        [ind] = find(V>=(i-1)*p & V<i*p);        
        %H{i} = ind;           
        %
        if( size(ind,1) ~= 0 )
            H{j} = ind;           
            j = j + 1;
        end
        %
    end
    i = numLevel;
    [ind] = find(V>=(i-1)*p & V<=255);    
    if( size(ind,1) ~= 0 )
        H{j} = ind;            
    end
    %
end