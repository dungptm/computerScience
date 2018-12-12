function [list_euler_trail,list_point_seq, stroke_width] = trajectoryFromSingleStroke(img,debug,eval)
    %% 
    if(eval)
        debug = 0;
    end
    
    %% INITLIALIZATION
    list_euler_trail = [];
    list_point_seq = {};
    stroke_width = 0;
    % END INITIALIZATION
    %%
    % 1. call pre-processing function    
    %set(0,'DefaultFigureVisible','off');
    fprintf('\n- Running Skeletonization ...\n');
   %[vertices,m_adjacent,m_edges,stroke_points_seq,skel,stroke_width] = skeletonAndPostProcessing(img,debug);
   %img = im2bw(img,0.5)
   
tic
   skel = ZSkeleton(img);   
toc
   skel = bwmorph(skel,'skel',inf);
   skel = removeCorner(skel);


          
    %stroke width
    nWhiteSkeleton = sum(skel(:));
    nWhiteOriginal = sum(img(:));
    stroke_width = round(nWhiteOriginal/nWhiteSkeleton);
    % graph construction
   %figure;imshow(skel);title('Skeleton');
   [vertices,m_adjacent,m_edges,stroke_points_seq] = graphConstruction(skel,stroke_width);
    
    %% check invalid output from Skeleton
    invalid = checkInValidOutput(vertices,m_adjacent,m_edges,stroke_points_seq);
    
    % Write variable to text file for testing in C function
    %exportInfo(vertices,m_adjacent,m_edges,stroke_points_seq,skel,stroke_width);
    if(invalid)
        fprintf('\n[ERROR] - INVALID OUTPUT FROM SKELETON => IGNORE THIS COMPONENT ********\n');
        return;
    end
    
    vertices = double(vertices);
%     if(debug)
%         figure; imshow(skel);title('Skeleton');
%         hold on 
%         plot(vertices(:,2),vertices(:,1),'ro');        
%     end
    % 2. call graph construction
    %[] = graphConstruction();
    % 3. call semi-euler graph reconstruction
    
    e_num = size(stroke_points_seq,2);
    v_num = size(vertices,1);
    %% SHOW GRAPH ON FIGURE 
    % show figure + vertices
    if(debug)
        figure;imshow(skel);title('Stroke Segmentation');
        hold on
        for i=1:v_num    
            plot(vertices(i,2),vertices(i,1),'r*');
            text(vertices(i,2)+3,vertices(i,1),num2str(i),'BackgroundColor',[.7 .9 .7]);
            % show loop vertex
    %         if(m_adjacent(i,i) == 2)
    %             fprintf('+++++++\nLoop: %d\n',i);
    %         end        
        end
        
        for i=1:size(stroke_points_seq,2)
            str_t = stroke_points_seq{i};
            st = uint16(size(str_t,1)/2);
            ed = ['e' num2str(i)];
            text(str_t(st,2),str_t(st,1),ed,'BackgroundColor',[0 0 1]);
        end
    end
    %% semi-euler graph reconstruction    
    % find start point and end point
    fprintf('\n- Tracing ...\n');
    [idx_start_point,idx_end_point] = findStartEndPoint(vertices,m_adjacent,stroke_width);
    
    % [m_adj] = SEGraphReconstruction(v_num,vertices,e_num,m_adjacent,idx_start_point,idx_end_point);
    m_adj = m_adjacent;
    % multi strokes detection
    % if graph is not semi_euler -> multi strokes
 

    [list_euler_trail,list_point_seq] = smoothestEulerTrail(v_num,vertices,e_num,m_edges,m_adj,idx_start_point,idx_end_point,stroke_points_seq,stroke_width,debug);
    
end