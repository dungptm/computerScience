function [M] = NcutComputeAfinityMatrix(H,W)
% compute affinity matrix M which contains weight value between 2 grayscale
% level group

    l = size(H,2);
    M = zeros(l,l);   
    for i=1:l              
        if( size(H{i},1) == 0 )
            M(i,:) = 0;
        else           
            for j=i:l          
                M(i,j) = sumWeight(H{i},H{j},W);                       
                M(j,i) = M(i,j);
            end
        end
    end
end
function [s] = sumWeight(H1,H2,W)
    s = 0;    
    if( size(H1,1) ~= 0 && size(H2,1) ~= 0 )
        W1 = W(H1',H2');
        s = sum(sum(W1));
    end
end