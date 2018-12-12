function [list] = load_endata(fullName)

    % giai ma file vecto dac trung
    inFile = fullName;
    
    f = dir(fullName);
    fileName = f.name;
    outFile = strcat('re_',fileName(4:size(fileName,2))); % re_filename.mat
    
    op = 'D';% option : decrypt
    cmd = 'AES_Run.exe';
    
    key = random_key(f.date);
    cmd = [cmd ' ' inFile ' ' outFile ' ' op ' ' key];
    dos(cmd);
    
    % load vecto dac trung cua van tay tu file len
    load(outFile);
    delete(outFile);
end