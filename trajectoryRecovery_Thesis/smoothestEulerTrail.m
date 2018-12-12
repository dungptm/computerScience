function  [list_euler_trail,list_point_seq] = smoothestEulerTrail(v_num,vertices,e_num,m_edges,m_adj,idx_start_point,idx_end_point,stroke_points_seq,stroke_width,debug)
    % m_edge: contains edge info between 2 vertices
    point_seq = [];
    % find the smoothest path
    m_adj_t = m_adj;
    % C = list of vertices of trail
    current_v = idx_start_point;
    C = current_v;
    count = 0;
    n_stroke = 1; % number order of stroke
    e_idx = 0;
    % in case, there are many strokes, input graph is not semi euler graph         
    while(sum(sum(m_adj_t)) > 0)
        
        count = count + 1;
        if(debug)
            disp(count);
        end
        e_seq = [];
        %count = count + 1
        % check loop vertices
        if(m_adj_t(current_v,current_v) == 2)
            % loop vertices            
            cand_v = current_v;

            % delete edges of a loop vertex            
            m_adj_t(current_v,cand_v) = 0;
            m_adj_t(cand_v,current_v) = 0;

            % extract edge sequence
            % index of edge
            % get list of edges b/t 2 vertices
            %for i=1:size(m_edges{current_v,cand_v},2)
                
            e_adj_list = m_edges{current_v,cand_v};
            %e_idx = uint16(m_edges{current_v,cand_v});
                        
            min_cost = 100000;
            for k=1:size(e_adj_list,2)
                e_adj = e_adj_list(1,k);
            
                e_seq = stroke_points_seq{1,e_adj};      
                % correct direction
                % previous direction
                loop_junction = vertices(current_v,:);
                r = size(point_seq,1);            
                eps = uint16(1.5*stroke_width);
                if(r>0)                
                    eps = max(1,uint16(min([eps r/2])));

                    vec1 = point_seq(r,:) - point_seq(r-eps,:);
                else
                    % vec 1 will be x axis +
                    vec1 = [0 1];
                end
                eps = max(1,min(eps, size(e_seq,1)-1));

                vec2 = e_seq(eps,:) - loop_junction;
                vec3 = e_seq(max(1,size(e_seq,1)-eps),:) - loop_junction;
                %
                vec1 = fliplr(vec1);
                vec2 = fliplr(vec2);
                vec3 = fliplr(vec3);
                w1 = getCost(vec1, vec2);
                w2 = getCost(vec1, vec3);                
                   
                if(w1<min_cost)
                    min_cost = w1;
                    e_seq = e_seq;
                end
                if(w2<min_cost)                    
                    min_cost = w2;  
                    e_seq = flipud(e_seq);
                end             
                
            end
        else
            %% vertex is not a loop
            % find adjacent edges of vertex
            if(degVertex(m_adj_t, current_v) > 1 )
                % consider weight
                % list of adj edges
                v_adjacents = find(m_adj_t(current_v,:) > 0);
                min_W = 10000; 
                cand_v = 0;
                cand_v1_v2 = [];% unused
                cand_e_idx = 0;
                for i=1:size(v_adjacents,2)
                    v_adj = v_adjacents(1,i);
                    junct = vertices(current_v,:);
                    
                    % consider lst edge
                    e_adj_list = m_edges{current_v,v_adj};
                    for k=1:size(e_adj_list,2)
                        e_adj = e_adj_list(1,k);                               
                    
                        weight = computeWeight(stroke_points_seq,junct,e_idx,e_adj,stroke_width);

                        if(weight <= min_W)
                            min_W = weight;
                            cand_v = v_adj;
                            cand_v1_v2 = [current_v v_adj];
                            cand_e_idx = e_adj;                 
                        end
                    end
                end                     
                %cand_v = cand_v; 
            else
                %degVertex(m_adj_t, v) == 1                
                % go
                idx_ver = find(m_adj_t(current_v,:) > 0);
                if(size(idx_ver,2) ~= 0)            
                    cand_v = idx_ver(1,1);
                    cand_v1_v2 = [current_v cand_v]; % unused
                    cand_e_idx = m_edges{current_v,cand_v}(1,1);
                else
                    cand_v = 0;
                end                
            end

            %% delete edge and add vertex to trail            
            if(cand_v~=0)
                % delete edges                
                e_idx = cand_e_idx;
                e_list = m_edges{current_v,cand_v};
                if(m_adj_t(current_v,cand_v)==2 && size(e_list,2)==1 )
                    % double trace, so dont remove edges
                    fprintf('double trace edge - process');
                else
                    % remove edges
                    [val,idx] = find(e_list==e_idx);
                    it = idx(1,1);
                    tend = size(e_list,2);
                    e_list = [e_list(1,1:it-1) e_list(1,it+1:tend)];
                    m_edges{current_v,cand_v} = e_list;
                    m_edges{cand_v,current_v} = e_list;
                end
                
                % update m_adj
                m_adj_t(current_v,cand_v) = m_adj_t(current_v,cand_v) - 1;
                m_adj_t(cand_v,current_v) = m_adj_t(current_v,cand_v);

                % index of edge                
                % e_idx = uint16(m_edges(cand_v1_v2(1,1),cand_v1_v2(1,2)));
                % consider reverse direction v2->v1
%                 if(m_edges(cand_v1_v2(1,2),cand_v1_v2(1,1)) ~= m_edges(cand_v1_v2(1,1),cand_v1_v2(1,2)))
%                     m_edges(cand_v1_v2(1,1),cand_v1_v2(1,2)) = m_edges(cand_v1_v2(1,2),cand_v1_v2(1,1));
%                 end                
                
                e_seq = stroke_points_seq{1,e_idx};                
                if( isequal(e_seq(1,:), vertices(cand_v,:)))
                    % flip up down to change direction of sequence
                    e_seq = flipud(e_seq);            
                end            
            else %if(cand_v~=0)
                % cand_v == 0: not found next vertex
                % go to next stroke                
                list_euler_trail{1,n_stroke} = C;
                list_point_seq{1,n_stroke} = point_seq;
                
                n_stroke = n_stroke + 1;
                
                % reset value
                C = [];
                point_seq = [];
                
                % find next vertex
                if(sum(sum(m_adj_t)) == 0)
                    break;
                end
                [idx_start,idx_end_dontcare] = findStartEndPoint(vertices,m_adj_t,stroke_width);
                current_v = idx_start; 
                C = [current_v];
                continue;
            end %if(v1~=0)
        end %if(m_adj_t(current_v,current_v) == 2)

        % update global variable
        point_seq = [point_seq; e_seq];
        % put v into C
        C = [C cand_v];
        %%
        % reset v for new loop
        current_v = cand_v;
        if(sum(sum(m_adj_t)) == 0)
            list_euler_trail{1,n_stroke} = C;
            list_point_seq{1,n_stroke} = point_seq;
        end
    end % end while
    % temporarily for testing XXXXXXXXXXXXXXXXXXXXXX
    %list_euler_trail = C;    
end
%%
function w = computeWeight(stroke_points_seq,junct,idx_e1,idx_e2,stroke_width)
    %esp = stroke_width;
    w = 10000;
    eps = 1.5*stroke_width;
    
    if(idx_e1~=0)        
        e1 = stroke_points_seq{1,idx_e1};
        eps = uint16(min([eps size(e1,1)-1]));
    end
    if(idx_e2~=0)        
        e2 = stroke_points_seq{1,idx_e2};
        eps = uint16(min([eps size(e2,1)-1]));
    end
        
    %calculate v1,v2        
    if(idx_e1~=0)
        if(isequal(e1(1,:),junct))
            %vec1 = e1(1+eps,:)-junct;        
            vec1 = junct-e1(1+eps,:);        
        else
            %vec1 = e1(r1-eps,:)-junct;
            r1 = size(e1,1);
            vec1 = junct-e1(r1-eps,:);
        end
    else
        vec1 = [0 1];
    end
    
    if(idx_e2~=0)
        if(isequal(e2(1,:),junct))
            vec2 = e2(1+eps,:)-junct;
        else
            r2 = size(e2,1);
            vec2 = e2(r2-eps,:)-junct;
        end
    else
        vec2 = [0 1];
    end 
    
    vec1 = fliplr(vec1);
    vec2 = fliplr(vec2);
    w = getCost(vec1, vec2);
    if(isnan(w))
        w = 0;
    end
end
%%
function w = getCost(vec1, vec2)

    cos_theta = sum(vec1.*vec2)/(norm(vec1)*norm(vec2));
    sin_theta = sqrt(1-cos_theta*cos_theta);
    w = sin_theta;
    %w = 1/cos_theta;
end
%%
function deg = degVertex(m_adj, i)
    deg = sum(m_adj(i,:));
end
%%
% function flag = isBridges(m_adj,v1,v2)
%     flag = 0;
%     v_num = size(m_adj,2);
%     m_adj(v1,v2) = m_adj(v1,v2) - 1;
%     m_adj(v2,v1) = m_adj(v1,v2);
%     m_adj_t = (m_adj > 0);
%     % do thi lien thong e_num >= v_num-1
%     if(sum(sum(m_adj_t))/2 < v_num-1)
%         flag = 1;
%     end
% end