function demo1()

listFiles = dir('images_50/001.jpg');
m = size(listFiles,1);

for j=1:m
    fprintf('\nSegmenting %s ...\n', listFiles(j).name);
    SI =50; SX = 5; r = 5; sNcut = 0.14; sArea = 5; % default    
   
    nGrayLevel = 100; % default    
    file = ['images_50/' listFiles(j).name];
    oI = imread(file);
    I = rgb2gray(oI);
    segI = NcutImageSegment(I, SI, SX, r, sNcut, sArea, nGrayLevel);

    % show result
    m = length(segI);
    param = ['SI=',num2str(SI),'; r=',num2str(r),'; sNcut=',num2str(sNcut),'; sArea=',num2str(sArea)];
    figure;
    uicontrol('Style', 'text', 'String', ['RESULT: ',param], ...
'HorizontalAlignment', 'center', 'Units', 'normalized', ...
'Position', [0 .9 1 .05], 'BackgroundColor', [.8 .8 .8]);

    subplot(ceil(sqrt(m))+1,ceil(sqrt(m))+1,1);
    imshow(oI);
    for i=1:m
        subplot(ceil(sqrt(m))+1,ceil(sqrt(m))+1,i+1);
        imshow(segI{i});
    end
end
end
