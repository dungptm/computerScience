function demo
im = imread('original.png');
for i = 1:7
z = i*0.5;
z0_5 = blnrm2(im, z);
figure;
imshow(z0_5);
imwrite(z0_5,strcat('z',num2str(z),'.png'));
end
end