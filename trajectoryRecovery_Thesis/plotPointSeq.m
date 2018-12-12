function plotPointSeq(img_size, seq, writerObjVideo,stroke_width,color)

    img = zeros(img_size);
    seq = uint16(seq);
%     hold on
%     for i=1:size(seq,1)
%         plot(seq(i,2),seq(i,1),'black');        
%         %img(seq(i,1),seq(i,2)) = 1;
%     end
    %figure;imshow(img);title('Trajectory');
    %imshow(img);
    step = min(uint16(size(seq,1)/3), uint16(stroke_width));
    length = 3*stroke_width/4;
    length = double(min(length, step));

    for i=1:step:size(seq,1)-step;
       
       if(i==1)
           cl = 'r';
       else           
           cl = color;
       end
       
       start_point = [seq(i,2) seq(i,1)];
       stop_point = [seq(i+step,2) seq(i+step,1)];
       start_point = double(start_point);
       stop_point = double(stop_point); 
       arrow([start_point(1,1), start_point(1,2)],[stop_point(1,1), stop_point(1,2)], 'Length',length,'FaceColor',cl);
       
%        frame = getframe;
%        writeVideo(writerObjVideo,frame);
%        pause(0.09) %in seconds
       
    end
    % draw end arrow
   i = size(seq,1)-step;
   
   start_point = [seq(i,2) seq(i,1)];
   stop_point = [seq(i+step,2) seq(i+step,1)];
   start_point = double(start_point);
   stop_point = double(stop_point); 
   arrow([start_point(1,1), start_point(1,2)],[stop_point(1,1), stop_point(1,2)], 'Length',length,'FaceColor','b');
end