function [new_minutiae] = transform_minutiae(list,r)
    theta = list(r,4);
    theta = pi/2-theta;
    m_rotate = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];
    
    p = list(r,2:4);
    lst = list(:,2:4);
    tmp = zeros(size(lst));
    tmp(:,1) = lst(:,1) - ones(size(lst,1),1)*p(1);
    tmp(:,2) = lst(:,2) - ones(size(lst,1),1)*p(2);
    tmp(:,3) = lst(:,3) - ones(size(lst,1),1)*p(3);
    
    new_minutiae = zeros(size(list(:,1:4)));
    new_minutiae(:,1) = list(:,1);
    new_minutiae(:,2:4) = tmp*m_rotate;
end