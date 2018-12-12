%------------------------------------------------------------------------
% showMinutiae(imthin,M)
% 
% Hien thi diem ki di da rut trich tren anh goc da lam manh
% 
% imthin       - anh da lam manh
% M            - danh sach diem ki di da rut trich
%------------------------------------------------------------------------
function showMinutiae(imthin,M)
    colormap(gray);imagesc(imthin);
    hold on;

    if (~isempty(M))
        s = size(M);
        
        for i=1:s(1)
            if (M(i,1) == 1)
                hold on;
                plot(M(i,3),M(i,2),'*r');
            else
                hold on;
                plot(M(i,3),M(i,2),'+b');
            end
        end
    end
% end function