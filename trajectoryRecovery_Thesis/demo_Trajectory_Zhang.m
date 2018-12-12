function demo_Trajectory_Zhang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USING ZHANG-SUEN SKELETONIZATION %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    close all;
    warning off;
    eval = 0;
    
    revert = 1;
    %list_file = dir('./image/unexplorted.PNG');
    %list_file = dir('./image/chon.PNG');
    %list_file = dir('./image/11.PNG');
%     dirname = './image/binary_set1/';
%     list_file = dir([dirname '*.png']);
%      revert = 1;
    
%     dirname = './image/icdar2013/';
%     data = {'single_stroke','multi_stroke'};
        data = {'multi_stroke'};
    
    for k=1:size(data,2)        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        dirname = ['../trajectoryRecovery_builddataset/data/' data{1,k} '/images/'];
        outdir = ['../trajectoryRecovery_builddataset/data/' data{1,k} '/test_Zhang/'];
        outfile_txt = ['../trajectoryRecovery_builddataset/data/time_per_' data{1,k} '_Zhang.csv'];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        list_file = dir([dirname '*.png']);
        fid = fopen(outfile_txt,'w');
        
        if(size(list_file,1)==0)
            fprintf('\n[WARN] - FILE NOT FOUND\n');
        end
        for i=1:size(list_file,1)
            close all
            display(i);
            t1 = tic;
            imgfile = [dirname list_file(i).name];
%            imgfile = 'D:\Dropbox\working\Thesis\trajectoryRecovery\dev\trajectory_intergration\failed\11.jpg';
           revert = 0;
%             %%%%%%%%%%%%%%%%%%%% TEST ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%             imgfile = '../trajectoryRecovery_builddataset/data/single_stroke/images/1014.png';
            
            fprintf('\n Tracing %s ...\n', imgfile);
            %% READING IMAGE

            img = imread(imgfile);
            %figure; imshow(img);title('Original Image');
            [r s c] = size(img);
            if(c==3)
                img = rgb2gray(img);
            end

            bw_img = binaryAndEnhancement(img);

            % if image is gray image, comment this line 
            if(revert)
                bw_img = 1-bw_img;
            end

    %         figure; imshow(bw_img);title('Enhanced Image');

            left = 1;
            right = 1;
            top = 1;
            bot = 1;
            
%             outfile = [imgfile '_res_'];
            mkdir([dirname '/out_traj/']);
            outfile = [dirname '/out_traj_zhang/' list_file(i).name '_traj.png'];
            [list_point_seq, num_of_stroke, stroke_width, stroke_color] = ...
                trajectory_mainFunction(bw_img, left, right, top, bot, outfile,eval);

            % save mat
            matfile = [outdir list_file(i).name];
            matfile = strrep( matfile,'.png','.mat');
            save(matfile,'list_point_seq');
            t2 = toc(t1);
            fprintf('%s,%.2f\n',list_file(i).name,t2);
            fprintf(fid,'%s,%.2f\n',list_file(i).name,t2);
        end
        fclose(fid);
    end
end