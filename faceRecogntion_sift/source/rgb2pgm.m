function rgb2pgm(f)
    
    image = imread(f);
    image = rgb2gray(image);
    [rows, cols] = size(image); 
    f = fopen('tmp.pgm', 'w');
    if f == -1
        error('Could not create file tmp.pgm.');
    end
    fprintf(f, 'P5\n%d\n%d\n255\n', cols, rows);
    fwrite(f, image', 'uint8');
    fclose(f);
end