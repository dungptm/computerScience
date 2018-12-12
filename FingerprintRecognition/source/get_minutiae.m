%------------------------------------------------------------------------
% [M] = get_minutiae(imthin,orient,N)
% 
% Trich xuat diem ki di tu anh da lam manh
% 
% imthin       - anh da lam manh 
% orient       - anh huong
% N            - kích thuoc block
% 
% M            - danh sach dac trung gom 5 thanh phan
%       1. Diem re nhanh (3) hoac diem ket thuc (1)
%       2. toa do x
%       3. toa do y
%       4. huong cuc bo
%------------------------------------------------------------------------
function [M] = get_minutiae(imthin,orient,N)
    tmp = imthin;    
    s = size(imthin);
    srd = sum(sum(tmp));
    [x y] = find(tmp == 1);
    ridge = [x,y];
    M = zeros(srd,4);
    count = 1;
    
    for i=1:srd
        x = ridge(i,1);
        y = ridge(i,2);
        if (x-1>0 & x+1<=s(1) & y-1>0 & y+1<=s(2))
            neighborNum = sum(sum(imthin(x-1:x+1,y-1:y+1))) - 1;

            if (neighborNum == 1)
                M(count,:) = [neighborNum, x, y, orient(ceil(x/N),ceil(y/N))];
                count = count + 1;
            else if (sum(sum(tmp(x-1:x+1,y-1:y+1))) - 1 == 3)
                    t = tmp(x-1:x+1,y-1:y+1);
                    t(2,2) = 0;
                    [abr,bbr] = find(t==1);

                    if isempty(M)
                        M(count,:) = [neighborNum, x, y, orient(ceil(x/N),ceil(y/N))];
                        count = count + 1;
                    else
                        for p=1:3
                            cbr = find(M(:,2)==(abr(p)-2+x) & M(:,3)==(bbr(p)-2+y));
                            if ~isempty(cbr)
                                M(cbr,:) = [neighborNum, x, y, orient(ceil(x/N),ceil(y/N))];
                                p = 4;
                                break;
                            end
                        end

                        if (p==4)
                            tmp(x-1:x+1,y-1:y+1) = zeros(3,3);
                        end

                        if (p==3)
                            M(count,:) = [neighborNum, x, y, orient(ceil(x/N),ceil(y/N))];
                            count = count + 1;
                        end
                    end
                end
            end
        end
    end
    M(count:srd,:) = [];
% end function