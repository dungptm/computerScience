function [list_point_seq_xy, num_of_stroke, stroke_width, stroke_color] ...
    = trajectory_mainFunction(bw_img, left, right, top, bot, outfile, eval)
% INPUT
% bw_img: binary image of word
% left, right, top, bot: bounding box information of word
% outfile: file path of output file
% OUTPUT
% list_point_seq    
% stroke_width
% stroke_color
%%

% bw_img = binaryAndEnhancement(bw_img);        
% bw_img = 1-bw_img;

%padding
% [r,c]=size(bw_img);
% bw_img=[zeros(r,1) bw_img zeros(r,1)];
% bw_img=[zeros(c+2,1) bw_img' zeros(c+2,1)]';

debug = 1;
if(eval)
    debug = 0;
end

%% INITALIZATION
list_point_seq_xy = {};
num_of_stroke = 0;
stroke_width = 0;
stroke_color = [0 0 0];
%%
    num_of_stroke = 0;    
    word_size = size(bw_img);    
   
    % get connected components
    [L, num] = bwlabel(bw_img, 8);
    
    if(debug)
        figure;imshow(bw_img);title('Binary Image');
        RGB = label2rgb(L);
        figure; imshow(RGB);
    end
    list_point_seq_rc = {};
    
    seq_count = 1;
    %set(0,'DefaultFigureVisible','off');
    num = 1;
    for i=1:num
        %single_stroke = (L==i);       
        single_stroke = (L>0);       
        if(debug)
            figure; imshow(single_stroke);
        end
        % extract point sequence from binary image    
        % get list of point sequence    
        
        [list_euler_trail_t,list_point_seq_t,stk_width] = trajectoryFromSingleStroke(single_stroke,debug,eval);
        
        
        %% DUNG: In case, there is no result from skeleton of a dot, temporarily result is ignore this component
        if(size(list_point_seq_t,2)==0)
            continue;
        end
        
        for ik=1:size(list_point_seq_t,2)
            list_point_seq_rc{1,seq_count} = list_point_seq_t{1,ik};
            list_euler_trail{1,seq_count} = list_euler_trail_t{1,ik};
            stroke_width(seq_count,1) = stk_width;
            seq_count = seq_count + 1;
        end
        
        %figure;imshow(single_stroke);title('Trajectory of single stroke');
        %plotPointSeq(word_size, list_point_seq);
    end
%     set(0,'DefaultFigureVisible','on');
%% show euler trail result
%     fprintf('\n**********EULER TRAIL*********\n');
%     
%     for ik=1:size(list_euler_trail,2)
%         fprintf('[Euler] Trail %d\n',ik);
%         disp(list_euler_trail{1,ik});
%     end
    
    % skeleton image
    skel = zeros(size(bw_img));
    for i=1:size(list_point_seq_rc,2)
        seq = list_point_seq_rc{1,i};
         for j=1:size(seq,1)
            skel(seq(j,1),seq(j,2)) = 1;
         end
    end
            
    list_point_seq_xy = list_point_seq_rc;
    if(eval)
        return;
    end
    %%
    %// Will open an avi file name test.avi in local folder
    writerObjVideo = [];
%     vfilename = [outfile '_out_trajectory.avi'];
%     writerObjVideo = VideoWriter(vfilename);
%     writerObjVideo.FrameRate = 10;  % Default 30
%     open(writerObjVideo);    
    h_trajectory = figure;imshow(skel);title('Trajectory of Word');
    hold on;
    %% PLOT LIST OF POINT SEQUENCES        
    for i=1:size(list_point_seq_rc,2)        
        if(mod(i,3)==0)
            color = 'cyan';
        elseif (mod(i,3)==1)
            color = 'yellow';
        else
            color = 'magenta';
        end
        seq = list_point_seq_rc{1,i};
        
%         plot(seq(:,2),seq(:,1),'g*');
        plotPointSeq(word_size, list_point_seq_rc{1,i}, writerObjVideo,stroke_width(i,1),color);       
    end
    %// close the file handle.
    close(writerObjVideo);
    
    swf = strrep(outfile,'.png','');
    im_filename = [swf '_out_trajectory.jpg'];
    saveas(h_trajectory,im_filename);
    num_of_stroke = size(list_point_seq_rc,2);
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CONVERT list_point_seq (local, [row column]) to list_point_seq_xy (global, [x y])    
    list_point_seq_xy = convertToXYCoordinate(list_point_seq_rc, left, right, top, bot);
    %% output to ink data -> WRITE TO FILE
    ink_filename = [swf '_out_inkData.txt'];
    % delete old data file
    fid = fopen(ink_filename,'w');
    fclose(fid);
    for i=1:size(list_point_seq_rc,2)        
        stroke_idx = i;
        stroke_color = [0,0,0]; % default color        
        outToInkData(ink_filename,stroke_idx,stroke_width(i,1),stroke_color,list_point_seq_rc{1,i});        
    end
% output 
% list_point_seq    
% stroke_width
% stroke_color
% video of trajectory in video_name.avi
end
