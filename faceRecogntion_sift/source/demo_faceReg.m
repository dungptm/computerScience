% Full-name: PHAN THI MY DUNG
% Face Recognition using SIFT feature
% Training Data: 10 faces of 10 person

function demo_faceReg

    % indicate test images
    tDir = 'test/';
    listTest = dir(strcat(tDir,'*.*p*'));
    mT = size(listTest,1);
    
    % indicate database
    dbDir = 'database/';
    listDB = dir(strcat(dbDir,'*.*p*'));
    mDB = size(listDB,1);
    
    for i=1:mT
        tFile = strcat(tDir,listTest(i).name);
        for j=1:mDB            
            dbFile = strcat(dbDir,listDB(j).name);
            num(j) = match(tFile,dbFile,0);                
        end
        % find the best matching        
        [vmax,nmax] = max(num);
        dbFile = strcat(dbDir,listDB(nmax).name);
        match(tFile,dbFile,1);
    end
    
end