function outToInkData(filename,stroke_idx,stroke_width,stroke_color,seq)
    fid = fopen(filename,'a');
    if(fid~= -1)
        %fprintf(fid,'%d\n',stroke_idx);
        fprintf(fid,'stroke %d\n', stroke_idx);
        fprintf(fid,'%d %d %d\n',stroke_color(1,1),stroke_color(1,2),stroke_color(1,3));
        fprintf(fid,'%d\n',stroke_width);
        %fprintf(fid,'%d\n',size(seq,1));
        % write point sequence
        for i=1:size(seq,1)
            fprintf(fid,'%d %d\n',seq(i,1),seq(i,2));
        end
    else
        fprintf('\nCannot open file!!!\n');
    end
   fclose(fid); 
end