function exportInfo(vertices,m_adjacent,m_edges,stroke_points_seq,skel,stroke_width)
    
    dir = './var/'
    % vertices
    fid2 = fopen([dir 'vertices.txt'],'w');        
    fprintf(fid2, '%d\n', size(vertices,1));
    for i=1:size(vertices,1)
        fprintf(fid2, '%d ', vertices(i,:));
        fprintf(fid2, '\n');
    end
    fclose(fid2);
    
    %m_adjacent
    fid2 = fopen([dir 'm_adj.txt'],'w');   
    fprintf(fid2, '%d\n', size(m_adjacent,1));
    for i=1:size(m_adjacent,1)
        fprintf(fid2, '%d ', m_adjacent(i,:));
        fprintf(fid2, '\n');
    end
    fclose(fid2);
    
    %m_edges
    fid2 = fopen([dir 'm_edges.txt'],'w');       
    [r,c] = size(m_edges);
    fprintf(fid2, '%d\n', r);
    for i=1:r        
        for j=1:c            
            fprintf(fid2, '%d %d ',i,j);
            fprintf(fid2, '%d ',m_edges{i,j});
            fprintf(fid2, '\n');
        end        
    end
    fclose(fid2);
    
    %stroke_points_seq
    fid2 = fopen([dir 'stroke_points_seq.txt'],'w');   
    len = size(stroke_points_seq,2);
    fprintf(fid2, '%d\n', len);
    for i=1:len
        t = stroke_points_seq{1,i};
        for j=1:size(t,1)
            fprintf(fid2, '%d ', t(j,:));
            fprintf(fid2, '\n');
        end
        fprintf(fid2, '\n');
    end
    fclose(fid2);
    
    fid2 = fopen([dir 'stroke_width.txt'],'w');
    fprintf(fid2,'%d', stroke_width);
    fclose(fid2);
end