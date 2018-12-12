function img = binaryAndEnhancement(img)

    %Preprocessing
%     filter_size = 6;
%     sigma = 0.3;
%     h = fspecial('gaussian', filter_size, sigma); 
%     g = imfilter(img, h, 'replicate');
%    figure; imshow(g);title('Image');  

    g = img;
%     g = im2bw(g, graythresh(g));
    
    g = 1 - g;
 %   figure; imshow(g);title('Binary Image');
        
    g = bwmorph(g,'fill','holes');
    ginv = 1 - g;
    se = strel('line',5,90);
    ginv = imopen(ginv,se);
    g = 1 - ginv;
    img=g;
    img=bwmorph(img,'spur',3);
    
%    se = strel('disk',2);
%    img = imclose(img,se);
%   figure; imshow(img);title('Enhanced Image');
end