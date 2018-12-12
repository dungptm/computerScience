function invalid = checkInValidOutput(vertices,m_adjacent,m_edges,stroke_points_seq)

invalid = 0;
%% DUNG: In case, there is no result from skeleton of a dot, temporarily result is ignore this component
    if(size(vertices,1)==0)
        fprintf('\n[WARN] - IGNORE TOO SMALL COMPOMENT *******\n');
        invalid = 1;
        return;
    end
    
    if(size(m_adjacent,1) ~= size(vertices,1) )...
            %|| size(m_adjacent,1) ~= size(m_edges,1) ...
            %|| size(m_edges,1) ~= size(vertices,1))        
        fprintf('\n[WARN] - ADJACENT MATRIX AND LIST OF VERTICES IS NOT VALID *******\n');        
        invalid = 1;
        return;
    end
    
%     for i=1:size(m_adjacent,2)
%         for j=1:size(m_adjacent,2)
%             if(m_adjacent(i,j) > 2)
%                 fprintf('\n[WARN] - EDGES INFO MATRIX IS NOT VALID *******\n');
%                 invalid = 1;
%                 return;
%             end
%         end
%     end
end