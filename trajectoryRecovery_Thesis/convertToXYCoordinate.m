function list_point_seq_xy = convertToXYCoordinate(list_point_seq_rc, left, right, top, bot)

% INPUT:
% list_point_seq_rc
% left, right, top, bot: bounding box information of word
% OUTPUT:
% list_point_seq_xy
    list_point_seq_xy = {};
    for i=1:size(list_point_seq_rc,2)
       seq_t = list_point_seq_rc{1,i};       
       seq_n = seq_t;
       % convert to global coordinate
       seq_n(:,1) = seq_n(:,1) + top - 1;
       seq_n(:,2) = seq_n(:,2) + left-1;
       % [r c] -> [x y] : x = c, y = r
       seq_n = fliplr(seq_n);
       list_point_seq_xy{1,i} = list_point_seq_xy;
    end
    
end