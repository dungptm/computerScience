close all;
clc;
% matgraph library
addpath('D:\STUDY\Study\Programming\Matlab\lib\matgraph\matgraph');

% read in a sample image -- also see letters.png, bagel.png
img = imread('image/shoes.png');
%img = imread(imgfile);
[r s c] = size(img);
if(c==3)
    img = rgb2gray(img);
end

%% FIGURE 1 
%figure; imshow(img);title('Input');
o_im1 = img;

img = 1-im2bw(img, graythresh(img));
%% FIGURE 2
%figure;imshow(img);title('Binarization');
o_im2 = img;

% in more detail:
[skr,rad] = skeleton(img);

% thresholding the skeleton can return skeletons of thickness 2,
% so the call to bwmorph completes the thinning to single-pixel width.
skel = bwmorph(skr > 35,'skel',inf);
%% FIGURE 3
%figure;imshow(skel);title('Skeletonization');
o_im3 = skel;
% subplot images
figure; 
%subplot(3,1,1);
imshow(o_im1);title('Input');
%subplot(3,1,2);
figure; 
imshow(o_im2);title('Binarization');
%subplot(3,1,3);
figure; 
imshow(o_im3);title('Skeletonization');

% try different thresholds besides 35 to see the effects
% anaskel returns the locations of endpoints and junction points
[dmap,exy,jxy] = anaskel(skel);
% hold on
% plot(exy(1,:),exy(2,:),'go');
% plot(jxy(1,:),jxy(2,:),'ro');

% return
% end points: exy
% junctions: jxy
% strokes: skel
% remove junction
strokes = skel;
% for i=1:size(jxy,2)
%     strokes(jxy(2,i)-1:jxy(2,i)+1,jxy(1,i)-1:jxy(1,i)+1) = 0;             
% end
% for i=1:size(exy,2)
%     strokes(exy(2,i)-1:exy(2,i)+1,exy(1,i)-1:exy(1,i)+1) = 0;             
% end
%figure;imshow(strokes);title('Stroke Segmentation');
% labling skeleton stroke
[L, num] = bwlabel(strokes, 8);

% point sequences extraction
exy = sortrows(exy',1)';
% start_point = [exy(2,1),exy(1,1)]; 
% end_point = [exy(2,size(exy,2)),exy(1,size(exy,2))];
% hard code for testing circle.png
% start_point = [43,196];
% end_point = [43,196];
single_stroke = (L==1);
seq = extractPointSeqs(single_stroke, start_point, end_point);
% figure;
% imshow(L);
% for i=1:size(seq,1)    
%     text(seq(i,2),seq(i,1),num2str(i));
% end

plotPointSeq(size(L),seq);
