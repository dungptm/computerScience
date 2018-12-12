function new = fillHoles(img)

    %Preprocessing 

%     g = img;    
%     g = 1 - g;
%     figure;imshow(img);title('binary');     
%     
%     g = bwmorph(g,'fill','holes');
%     ginv = 1 - g;
%     se = strel('line',5,90);
%     ginv = imopen(ginv,se);
%     g = 1 - ginv;
%     img=g;
%     img=bwmorph(img,'spur',3);
%     figure;imshow(img);title('result');
    
%     1. Fill all holes using imfill
original = img;
% figure;imshow(img);title('binary');     
   filled = imfill(original, 'holes');

% 2. Identify filled pixels using logical operators:

   holes = filled & ~original;

% 3. Use bwareaopen to eliminate connected components in the holes image 
% smaller than your threshold.

   bigholes = bwareaopen(holes, 100);

% 4. Use logical operators to identify small holes:

   smallholes = holes & ~bigholes;

% 5. Use logical operator to fill in identified small holes:

   new = original | smallholes;
%    figure;imshow(new);title('result');
end