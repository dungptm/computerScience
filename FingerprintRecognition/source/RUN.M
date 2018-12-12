listFile = dir('input');
s = size(listFile,1);
pathName = 'input\';
t = 0;
for i=3:s
    fileName = listFile(i).name;
    id = fileName(1:size(fileName,2)-6);
    [enfn] = run_getFeature(fileName,pathName);   
    id
    enfn
    t = t + enfn;
    % save du lieu gom id va vecto dac trung ma hoa de truyen di.
    save('var_input.mat','id','enfn');
    DEMO_GUI_AUTH;
end