%-------------------------------------------------------------------
% [match] = authen_fingerprint(dir_id,enfn)
% 
% Chung thuc van tay voi mau luu trong co so du lieu
% 
% dir_id    - thu muc chua mau van tay cua tai khoan
% enfn      - file luu vector dac trung cua van tay can chung thuc
%-------------------------------------------------------------------
function [match] = authen_fingerprint(dir_id,enfn)

    fprintf(1,'Chung thuc van tay tai ngan hang ...\n');
    %---------------------------------------
    %Giai ma bang thuat toan AES
    %---------------------------------------
    list_in = load_endata(enfn);
    delete(enfn);
    
% load du lieu la cac vector dac trung len cac bien
    if(size(dir(dir_id),1) == 5)
        % lay cac file trong database cua khach hang co id
        listf = dir(dir_id);
        
        list1 = load_endata(strcat(dir_id,listf(3).name));
        list2 = load_endata(strcat(dir_id,listf(4).name));
        list3 = load_endata(strcat(dir_id,listf(5).name));

    % lay phan tram dac trung khop o moi cap vector dac trung (giua vector test voi 3 vector luu tru)
        p1 = match_minutiae(list_in,list1);
        p2 = match_minutiae(list_in,list2);
        p3 = match_minutiae(list_in,list3);

        res = (p1+p2+p3)/3;    

        % so sanh voi nguong gama 
        gama = 0.4;
        if(res > gama)
            match = 1;
        else 
            match = 0;
        end
    end
end