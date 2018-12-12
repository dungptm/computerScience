function run1test()
    
    file = '035.jpg';
    %SI =50; SX = 5; r = 5; sNcut = 0.2; sArea = 5; % default    
    SI =50; SX = 10; r = 5; sNcut = 0.2; sArea = 5; % for 007.jpg
      
    nGrayLevel = 100; % default       
    oI = imread(file);
    I = rgb2gray(oI);
    segI = NcutImageSegment(I, SI, SX, r, sNcut, sArea, nGrayLevel);

    % show result
    m = length(segI);
    param = ['SI=',num2str(SI),'; r=',num2str(r),'; sNcut=',num2str(sNcut),'; sArea=',num2str(sArea)];
    figure;
    %{
    uicontrol('Style', 'text', 'String', ['RESULT: ',param], ...
'HorizontalAlignment', 'center', 'Units', 'normalized', ...
'Position', [0 .9 1 .05], 'BackgroundColor', [.8 .8 .8]);
%}
    subplot(ceil(sqrt(m))+1,ceil(sqrt(m))+1,1);
    imshow(oI);
    for i=1:m
        subplot(ceil(sqrt(m))+1,ceil(sqrt(m))+1,i+1);
        imshow(segI{i});
    end

end
