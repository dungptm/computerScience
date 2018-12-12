function [vertices,m_adj,m_edges,stroke_points_seq] = graphConstruction(skel,stroke_width)

    fprintf('\n- Running Graph Construction ...\n');
    vertices = [];
    m_adj = [];
    m_edges = [];
    stroke_points_seq = {};
    [dmap,exy,jxy] = anaskel(skel);
    %{%
    figure; imshow(skel);title('Junction detection');
    hold on
    plot(exy(1,:),exy(2,:),'go');
    plot(jxy(1,:),jxy(2,:),'ro');
    %}%

    %% I. Extract point seqs of edges
    % point is formated [r c]
    % 1. list of feature points
    list_fp = [exy jxy]';
    list_fp = fliplr(list_fp);
    list_fp = normalizedFeatures(list_fp);
    if(size(list_fp,1)==0)
        return;
    end
    % 2. extract edges
    stroke_points_seq = extractPointSequence(skel,list_fp);
    
    %% 3. remove spurs
    [stroke_points_seq,list_fp] = removeSpur(skel,stroke_points_seq,list_fp,stroke_width);
    
    %% 4. m_adj
    len_list_fp = size(list_fp,1);
    m_adj = zeros(len_list_fp);
    m_edges{len_list_fp,len_list_fp} = [];
    for i=1:size(stroke_points_seq,2)
        
        seq = stroke_points_seq{1,i};
        s = max(1,getIdx(list_fp,seq(1,:)));
        t = max(1,getIdx(list_fp,seq(size(seq,1),:)));
        
        m_adj(s,t) = m_adj(s,t) + 1;
        m_adj(t,s) = m_adj(s,t);
        
        if(m_edges{s,t})
            m_edges{s,t} = [m_edges{s,t} i];  
            m_edges{t,s} =  m_edges{s,t};
        else
            m_edges{s,t} = i;
            m_edges{t,s} =  m_edges{s,t};
        end
    end
    
    %% output
    % vertices: matrix mx2
    % m_adj: mxm, matrix of scalar, number of edges between 2 vertices
    % m_edges: mxm, each element is an array, list of edge between two
    % vertices
    % stroke_points_seq: list of sequence (stroke)
    % stroke_width: scalar
    vertices = list_fp;   

end
%%
function list_tmp = normalizedFeatures(list_fp)
    list_tmp = [];
    idx = [];
    for i=1:size(list_fp)-1
        for j=i+1:size(list_fp)
            if( norm(list_fp(i,:)-list_fp(j,:))^2 < 4 ) % adjacent
                % remove indx
                idx = [idx;i];
            end
        end
    end
    % remove
    for i=1:size(list_fp,1)
        if(~ismember(i,idx))
            list_tmp = [list_tmp;list_fp(i,:)];
        end
    end
    
end
%%
function [o_stroke_points_seq,o_list_fp] = removeSpur(skel,stroke_points_seq,list_fp,stroke_width)

    o_stroke_points_seq = {};
    o_list_fp = list_fp;
    nc = 1;
    for i=1:size(stroke_points_seq,2)
        seq = stroke_points_seq{1,i};
        if(size(seq,1) < 0.7*stroke_width)
            
            start_point = seq(1,:);
            end_point = seq(size(seq,1),:);
            num1 = neigborNum(start_point,skel);
            num2 = neigborNum(end_point,skel);
            
            if(num1 == 1 && num2 ~= 1)
                % delete spur stroke
                o_list_fp = deleteFP(o_list_fp,start_point);
                continue;
            end
            if(num2 == 1 && num1 ~= 1)
                % delete spur stroke
                o_list_fp = deleteFP(o_list_fp,end_point);
                continue;
            end            
        end
        o_stroke_points_seq{1,nc} = stroke_points_seq{1,i};            
        nc = nc+1;
            
    end
end
%%
function stroke_points_seq = extractPointSequence(skel,list_fp)

debug = 0;
    %% end extract point seq
    flag1 = 1;
    stroke_points_seq = {};
    skel_tmp = skel;
    list_fp_tmp = list_fp;
    if(size(list_fp,1)==0)
        return;
    end
    
    nc = 1;
    start_point = list_fp_tmp(1,:);
    cur_point = start_point;
    prev_point = [0 0];
    
    if(debug)
     % showing skel_tmp; imshow(skel_tmp);
     figure;
     hold on
    end
    while(flag1)
        
        flag2 = 1;
        count = 1;
        seq = cur_point;
        while(flag2)
            
            % check current point is null
            if(size(cur_point,1)==0)
                skel_tmp = deletePoint(skel_tmp,cur_point);
                list_fp_tmp = deleteFP(list_fp_tmp,cur_point);
                if(size(list_fp_tmp,1)>0)
                    cur_point = list_fp_tmp(1,:);
                end
                flag2 = 0;
                break;
            end
            
            % add to list of seqs
            if(isFeature(cur_point,list_fp_tmp))
                %% feature point
                if(count == 1)
                    % start point
                    if(neigborNum(cur_point,skel_tmp) == 0 ...
                        || isfpNeighbor(cur_point,list_fp_tmp,skel_tmp)==1)
                        % 1 point sequence
                        skel_tmp = deletePoint(skel_tmp,cur_point);
                        list_fp_tmp = deleteFP(list_fp_tmp,cur_point);
                        if(size(list_fp_tmp,1)>0)
                            cur_point = list_fp_tmp(1,:);
                        end
                        flag2 = 0;
                        break;
                    end
                    
                    if(neigborNum(cur_point,skel_tmp) == 1 ...
                            || isfpNeighbor(cur_point,list_fp_tmp,skel_tmp)==1)   
                        % feature is 1 degree 
                        skel_tmp = deletePoint(skel_tmp,cur_point);
                        list_fp_tmp = deleteFP(list_fp_tmp,cur_point);
                    end
                    
                    [prev_point,cur_point] = nextPoint(prev_point,cur_point,skel_tmp,list_fp);
              
                    if(size(cur_point,1)==0)
                        skel_tmp = deletePoint(skel_tmp,cur_point);
                        list_fp_tmp = deleteFP(list_fp_tmp,cur_point);
                        if(size(list_fp_tmp,1)>0)
                            cur_point = list_fp_tmp(1,:);
                        end
                        flag2 = 0;
                        break;
                    end
                    seq = [seq; cur_point];
                else
                    % count > 1
                    % end point
                    
                    if( neigborNum(cur_point,skel_tmp) == 0 ...
                        || (count == 2 && neigborNum(cur_point,skel_tmp) == 1 ) ...
                        || isfpNeighbor(cur_point,list_fp_tmp,skel_tmp)==1)
                        % 1 point sequence
                        skel_tmp = deletePoint(skel_tmp,cur_point);
                        list_fp_tmp = deleteFP(list_fp_tmp,cur_point);
                        if(size(list_fp_tmp,1)>0)
                            cur_point = list_fp_tmp(1,:);
                        end
                    end
                    flag2 = 0;
                    break;
                end
            else   
                %%
                % non-feature point
                % neighborNum > 0
                skel_tmp = deletePoint(skel_tmp,cur_point);                
                [prev_point,cur_point] = nextPoint(prev_point,cur_point,skel_tmp,list_fp);
                if(size(cur_point,1)==0)
                    skel_tmp = deletePoint(skel_tmp,cur_point);
                    list_fp_tmp = deleteFP(list_fp_tmp,cur_point);
                    if(size(list_fp_tmp,1)>0)
                        cur_point = list_fp_tmp(1,:);
                    end
                    flag2 = 0;
                    break;
                end
                seq = [seq;cur_point];
            end
            count = count + 1;
            if(debug)
                imshow(skel_tmp);title('Skel tmp');            
            end
            if(count == 2000)
                flag2 = 0;
            end
        %end_point
        end % end while
        
        stroke_points_seq{1,nc} = seq;
        nc = nc + 1;        
        if(sum(sum(skel_tmp)) == 0 || size(list_fp_tmp,1) == 0)
            flag1 = 0;
        end
    end
    %% end extract point seq
    %figure;imshow(skel_tmp);title('Skel tmp');            
end
%%
function idx = getIdx(list_fp,point)    
    idx = find(ismember(list_fp,point,'rows'),1);
    if(size(idx,1)==0)
        idx = 0;
    end
end
%%
function olist_fp_tmp = deleteFP(list_fp_tmp,cur_point)

    olist_fp_tmp = [];
    for i=1:size(list_fp_tmp,1)
        if(isequal(list_fp_tmp(i,:),cur_point)==0)
            olist_fp_tmp = [olist_fp_tmp; list_fp_tmp(i,:)];
        end
    end
end
%%
function [oprev_point,next_point] = nextPoint(prev_point,cur_point,skel_tmp,list_fp)

% should consider feature point first. todo
    next_point = [];
    oprev_point = cur_point;
    list_next_point = [];
    r_cur = cur_point(1,1);
    c_cur = cur_point(1,2);
    [m,n] = size(skel_tmp);
    
    rmin = max(1,r_cur-1);
    rmax = min(r_cur+1,m);
    cmin = max(1,c_cur-1);
    cmax = min(c_cur+1,n);
    
    r = rmin; c = c_cur;
    if(isequal([r c], cur_point)==0 && skel_tmp(r,c) ~= 0 && isequal([r c],prev_point) == 0)
        %next_point = [r c];
        list_next_point = [list_next_point; r c];        
    end
    
    r = rmax; c = c_cur;
    if(isequal([r c], cur_point)==0 && skel_tmp(r,c) ~= 0 && isequal([r c],prev_point) == 0)
        list_next_point = [list_next_point; r c];
    end
    
    r = r_cur; c = cmin;
    if(isequal([r c], cur_point)==0 && skel_tmp(r,c) ~= 0 && isequal([r c],prev_point) == 0)
        list_next_point = [list_next_point; r c];
    end
    
    r = r_cur; c = cmax;
    if(isequal([r c], cur_point)==0 && skel_tmp(r,c) ~= 0 && isequal([r c],prev_point) == 0)
        list_next_point = [list_next_point; r c];
    end
    
    for r=rmin:rmax
        for c=cmin:cmax
            if(isequal([r c], cur_point)==0 && skel_tmp(r,c) ~= 0 && isequal([r c],prev_point) == 0)
                list_next_point = [list_next_point; r c];
            end
        end
    end
    
    % find feature point
    for i=1:size(list_next_point,1)
        for j=1:size(list_fp,1)
            if(isequal(list_next_point(i,:),list_fp(j,:)) && isequal([r c],prev_point) == 0)
                next_point = list_next_point(i,:);
                return;
            end
        end
    end
    if(size(list_next_point) > 0)
        next_point = list_next_point(1,:);
    end
    
    if(size(next_point,1)==0)
        fprintf('Next point is null\n');
    end
    
end
%%
function flag = isFeature(cur_point,list_fp_tmp)
    flag = false;
    for i=1:size(list_fp_tmp)
        if( isequal(cur_point,list_fp_tmp(i,:)) )
            flag = true;
            break;
        end
    end
end

%%
function oskel = deletePoint(skel,cur_point)
    oskel = skel;
    if(size(cur_point,1)~=0)
        oskel(cur_point(1,1),cur_point(1,2)) = 0;
    end
    
end
%%
function flag = isfpNeighbor(cur_point,list_fp,skel_tmp)
% function nfp = countFP(cur_point,list_fp)
nfp = 0;
nnb = 0;
mask = [-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];
for i=1:size(mask,1)
    np = cur_point+mask(1,:);
    if( (skel_tmp(np(1),np(2))==1) && isFeature(np,list_fp) )
        nfp = nfp + 1;
    else
        nnb = nnb + 1;
    end
end
if(nnb==0)
    flag = 1;
else 
    flag = 0;
end
end
%%
function num = neigborNum2(cur_point,skel_tmp,list_fp)
    % todo
    num = 0;
    if(skel_tmp(cur_point(1,1),cur_point(1,2)))
        [r,c] = size(skel_tmp);
        nfp = countFP(cur_point,list_fp);
        mask = skel_tmp(max(1,cur_point(1,1)-1):min(r,cur_point(1,1)+1),max(1,cur_point(1,2)-1):min(c,cur_point(1,2)+1));
        num = sum(sum(mask))-1-nfp;
    end
end
%%
function num = neigborNum(cur_point,skel_tmp)
    % todo
    num = 0;
    if(skel_tmp(cur_point(1,1),cur_point(1,2)))
        [r,c] = size(skel_tmp);
        mask = skel_tmp(max(1,cur_point(1,1)-1):min(r,cur_point(1,1)+1),max(1,cur_point(1,2)-1):min(c,cur_point(1,2)+1));
        num = sum(sum(mask))-1;
    end
end