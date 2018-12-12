function [o_m_adj] = SEGraphReconstruction(v_num,vertices,e_num,m_adj,idx_start_point,idx_end_point)

%% POST PROCESSING: construct the semi-eulerian graph
% 1. LOOP: Add extra/virtual vertices to put loop information into graph
% 2. DOUBLE TRACE: Add extra/virtual edge and vertices at odd vertices
% TODO
%%
    start_point = vertices(idx_start_point,:);
    end_point = vertices(idx_end_point,:);
    [o_m_adj] = doubleTraceProcessing(v_num,vertices,e_num,m_adj,start_point,end_point);

end
%%

function [o_m_adj] = doubleTraceProcessing(v_num,vertices,e_num,m_adj,sp,ep)
    % 2. Process double trace
    % double trace should be connect to 2 odd vertices
    
    %drawGraph(m_adj);title('Original Graph');
    o_m_adj = m_adj;
    
    % list of deg of vertices
    list_deg = [];
    for i=1:size(m_adj,1)        
        list_deg = [list_deg; i degVertex(m_adj,i)];
    end
    list_deg = sortrows(list_deg,2);
    for ideg=1:size(list_deg,1)
        
        % odd vertices
        %if(mod(list_deg(ideg,2),2) == 1)
        if(list_deg(ideg,2) == 1)
            i = list_deg(ideg,1);
        
            for j=1:v_num            
                if(j~=i && m_adj(i,j)>0)
                    if( mod(degVertex(o_m_adj,i),2) == 1 && mod(degVertex(o_m_adj,j),2) == 1 ...
                    && ~(isequal(vertices(i,:),sp(1,:)))...
                    && ~(isequal(vertices(i,:),ep(1,:)))...            
                    && ~(isequal(vertices(j,:),sp(1,:)))...
                    && ~(isequal(vertices(j,:),ep(1,:)))...
                    )

                        % update adjacent matrix   
                        o_m_adj(i,j) = o_m_adj(i,j)+1;                             
                        o_m_adj(j,i) = o_m_adj(i,j); 
                        %fprintf('*******\nDouble trace from %d to %d\n',i ,j);
                    end
                end
            end
        else % not degree 1
            % odd degree but > 1
            if(mod(list_deg(ideg,2),2) == 1)
                i = list_deg(ideg,1);
        
                for j=1:v_num            
                    if(j~=i && m_adj(i,j)>0)
                        if( mod(degVertex(o_m_adj,i),2) == 1 ...
                        && mod(degVertex(o_m_adj,j),2) > 1 ...
                        && ~(isequal(vertices(i,:),sp(1,:)))...
                        && ~(isequal(vertices(i,:),ep(1,:)))...            
                        && ~(isequal(vertices(j,:),sp(1,:)))...
                        && ~(isequal(vertices(j,:),ep(1,:)))...                        
                        && m_adj(ideg,i) > 1 ... % > 2 edges b/w them
                        )

                            % update adjacent matrix   
                            o_m_adj(i,j) = o_m_adj(i,j)+1;                             
                            o_m_adj(j,i) = o_m_adj(i,j); 
                            %fprintf('*******\nDouble trace from %d to %d\n',i ,j);
                        end
                    end
                end
            end
        end
        % consider ood 
    end
        
    %drawGraph(o_m_adj);title('Graph - after processing double traces');    
    
end
function deg = degVertex(m_adj, i)
    deg = sum(m_adj(i,:));
end