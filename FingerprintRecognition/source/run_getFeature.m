%-----------------------------------------------------------
% [outFile] = run_getFeature(fileName,pathName)
% 
% Rut trich vector dac trung cua anh van tay
% 
% fileName    - ten anh van tay
% pathName    - duong dan day du cua anh van tay
%-----------------------------------------------------------
function [outFile] = run_getFeature(fileName,pathName)
    fprintf(1,'Rut trich va ma hoa dac trung van tay...\n');
    blk                  = 16;

    %-----------------------------------
    %Tìm vùng vân tay trong anh dau vào
    %-----------------------------------
    img = imread(strcat(pathName,fileName));
    [msk,bound]     =   segment(img,0);

    %-------------------------------------------------------
    %Cat anh de thu nho kích thuoc và chi chua vùng vân tay
    %-------------------------------------------------------
    [img,msk,bound] = crop(img,msk,bound);

    msk     =   pad_image(msk,blk);
    bound   =   pad_image(bound,blk);
    img     =   pad_image(img,blk);
    img     =   im2double(img);

    %---------------------------------------
    %Chuan hóa anh
    %---------------------------------------
    nimg    =   normalize(img,0,100);

    %---------------------------------------
    %Xác dinh huong cuc bo
    %---------------------------------------
    oimg            =   get_orientation(nimg,blk);
%     [blkht,blkwt]   =   size(oimg);

    %---------------------------------------
    %Làm tron huong cuc bo cua anh
    %---------------------------------------
    oimg            =   smoothen_orientation_field(oimg);

    %---------------------------------------
    %Xác dinh tan so cuc bo
    %---------------------------------------
    f       =   get_frequency(nimg,oimg,blk);
    fimg    =   filter_frequency_image(f);

    %---------------------------------------
    %Loc anh bang bo loc Gabor
    %---------------------------------------
    y         =   filter_gabor(nimg,oimg,fimg);
    y(msk==0) =   0;
    y         =   imscale(y);
    
    %---------------------------------------
    %Nhi phan hoa anh
    %---------------------------------------
    [B] = binarize(y,msk,blk);

    %---------------------------------------
    %Lam manh anh van tay
    %---------------------------------------
    [T] = thin(B);

    %---------------------------------------
    %Rut trich diem ki di
    %---------------------------------------
    [M] = get_minutiae(T,oimg,blk);

    %---------------------------------------
    %Hau xu li -> loai bo dac trung sai
    %---------------------------------------
    [list] = postprocess(T,M,35,27,bound);
   
    %---------------------------------------
    %Ma hoa bang thuat toan AES
    %---------------------------------------
    inFile = [fileName(1:size(fileName,2)-4) '.mat'];
    outFile = ['en_' fileName(1:size(fileName,2)-4) '.mat']; % en_fileName.mat

    cmd = 'AES_Run.exe';
    op = 'E';
    key = random_key(now);
    % luu xuong file
    save(inFile,'list'); 
    
    % cau lenh se duoc thuc thi tren dos 
    cmd = [cmd ' ' inFile ' ' outFile ' ' op ' ' key];
    
    % ma hoa bang cach thuc thi cau lenh tre dos
    dos(cmd);
    delete(inFile);
end