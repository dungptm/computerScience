% Full-name: PHAN THI MY DUNG
% Face Recognition using PCA
% Training Data: 10 faces of 10 person
% Test data: 12 images of human faces
%            2 images of apple (not human face)
function demo

    % training
    [eigenFaces,si,omega,listTrainFiles] = faceTraining();
    
    % testing
    listFiles = dir('Test/*.*p*');
    listTest = [];
    m = size(listFiles,1);    
    
    res = zeros(2,m);
    % support size of image W x H
    W = 160; H = 160;
    figure;title('Face Recognition - Known person');
    j = 1;
    for i = 1:m        
        fprintf('\nRecognizing %s''s face...', listFiles(i).name);
        f = strcat('Test/',listFiles(i).name);
        org_img = imread(f);
        img = imresize(rgb2gray(org_img), [W H]);
        img = reshape(img,[],1);              
        [res(1,i),res(2,i)] = faceRecognition(img,eigenFaces,si,omega);
        
        if( res(1,i) == 1 )
            fprintf('Result:Known person\nId:%d\n',res(2,i));      
            % show some of examples of known person
            if( j < 16 )
                subplot(4,4,j);imshow(org_img);
                j = j + 1;            
                subplot(4,4,j);imshow(imread(strcat('Train/',listTrainFiles(res(2,i)).name)));            
                j = j + 1;      
            end
        elseif( res(1,i) == -1 )
            fprintf('Result: Unknown person\n');            
        else
            fprintf('Result: Not a human face\n');            
        end            
    end
end
% A. Training phase
% Compute eigenvalues and eigenvectors from data set
% Input: Data set
% Output: 
%   - eigenfaces
%   - weight space
%   - list of trainning images (for show result) in testing
function [eigenFaces,si,omega_k,listFiles] = faceTraining 

    % set default number of eigens value
    m_eigens = 20;
    % get list of trainning images
    listFiles = dir('Train/*.*p*');
    m = size(listFiles,1);    
    si = 0;
    if( m < m_eigens )
        m_eigens = m;
    end
    for i = 1:m        
        f = strcat('Train/',listFiles(i).name);
        org_img = imread(f);  
        img = rgb2gray(org_img);
        [W,H] = size(img);
        % convert matrix of image to vector 
        im(:,i) = double(reshape(img,[],1));
        si = si + im(:,i);        
    end
    n = size(im(:,1),1);
    
    % average face
    si = double(si/m);
    mean_face = uint8(reshape(si,W,H));
    figure;imshow(mean_face);title('Mean face');
    % calculate L matrix to get eigenvector
    for i = 1:m
         % calculate face differs from average
         pi(:,i) = im(:,i) - si;
         pi_i = double(pi(:,i));        
    end 
    for i = 1:m
        for j = 1:m                       
            L(i,j) = pi(:,i)'*pi(:,j);
        end
    end
    [eVectors,eValues] = eigs(L,m_eigens);
    % eigenfaces
    for i=1:m_eigens        
        eigenFaces(:,i) = zeros(n,1);
        for j=1:m_eigens
            eigenFaces(:,i) = eigenFaces(:,i) + eVectors(j,i)*pi(:,j);
        end        
    end
    % show eigen faces
    figure;title('Eigenfaces');
    for i = 1:m_eigens             
        subplot(ceil(sqrt(m_eigens)),ceil(sqrt(m_eigens)),i);
        imshow(uint8(reshape(eigenFaces(:,i),W,H)));        
    end

    
    % calculate weight
    omega_k = zeros(m_eigens,m_eigens);
    for i= 1:m
        for j = 1:m_eigens
            omega_k(j,i) = eigenFaces(:,j)'*(im(:,i) - si);
        end
    end

end
% B. Recogntion phase
% Input:
%   img: gray scale
%   eigenFaces
%   si: mean face
%   omega_k: weight corresponding to each class
% Output:
%   flag = 1: known person
%          -1: unknown person
%           0: not a face image
%   id: index of person
function [flag,id] = faceRecognition(img,eigenFaces,si,omega_k)
    
    img = double(img);
    % threshold theta
    theta = 1.6e+12;
    theta_fclass = 4e+7;
    flag = 0;id = 0;
    esiplon = 0;m_esiplon_k = 0;
    
    % project into face space
    m_eigens = size(eigenFaces,2);
    omega = zeros(m_eigens,1);
    pi = img - si;
    for i=1:m_eigens
        omega(i) = eigenFaces(:,i)'*pi;
    end
    % check img close to face space
    pi_f = zeros(size(img,1)*size(img,2),1);
    for i=1:m_eigens
        pi_f = pi_f + omega(i)*eigenFaces(:,i);
    end
  
    % calculate distance to face space
    esiplon = norm(pi-pi_f);
    
    if( esiplon < theta )
        % check img close to face class                   
        for i=1:m_eigens
            esp_k(i) = norm(omega - omega_k(:,i));
        end
        [m_esiplon_k,index] = min(esp_k);
        
        if( m_esiplon_k < theta_fclass )
            flag = 1; % known person
            id = index(1,1);
        else
            flag = -1; % unknow person
        end
    else
        flag = 0; % not a face image
    end
    format short e;
    fprintf('\nesiplon=%g;m_esiplon_k=%g\n',esiplon,m_esiplon_k);
end