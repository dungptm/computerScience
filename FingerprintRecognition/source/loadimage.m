function [im] = loadimage(handles)
    [FileName,PathName] = uigetfile('*.tif','Select the Image-file');     
    PathName = strcat(PathName,FileName);
    im = imread(PathName);   
    axes(handles.axes_im);
    image(im);
%     colormap(gray);
    set(gca,'visible','off');
%     im = imread('D:\AUTHENTICATION FINGERPRINT\DATABASE\database\013_4_8.tif');
end