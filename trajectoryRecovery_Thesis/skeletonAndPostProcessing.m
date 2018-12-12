function [List_of_feature_points,m_adjacent,m_edges,stroke_points_seq,skel_copy,stroke_width] = skeletonAndPostProcessing(img,debug)
%set(0,'DefaultFigureVisible','off');
%set threshold for distinguishing spurious segment from real segment
%% INITIALIZE VARIABLE
List_of_feature_points = [];
m_adjacent = [];
m_edges = [];
stroke_points_seq = {};
skel_copy = [];
stroke_width = 0;
% END INITIALIZATION
%%

%bo so nay duoc chon dua vao thuc nghiem tinh toan database
k1=0.01;
k2=0.002;
% 
% img = imread('D:\Projects\Skeleton_Postprocessing\image\6_1.png');
% % figure(01);
% % img=rgb2gray(img);
% % img = adapthisteq(img);
% % img = im2bw(img, 0.4);
% % the standard skeletonization:
% % imshow(bwmorph(img,'skel',inf));
% % img=~img;
% img =1-im2bw(img, graythresh(img));
[r,c]=size(img);
img=[zeros(r,1) img zeros(r,1)];
img=[zeros(c+2,1) img' zeros(c+2,1)]';
% imshow(img);
nWhiteOriginal = sum(img(:));
[height,width]=size(img);
img=fillholes(img);
%Preprocessing
% filter_size = 3;
% sigma = 0.3;
% h = fspecial('gaussian', filter_size, sigma); 
% g = imfilter(img, h, 'replicate');
% g = im2bw(g, graythresh(g));
% g = bwmorph(g,'fill','holes');
% ginv = 1 - g;
% se = strel('line',5,90);
% ginv = imopen(ginv,se);
% g = 1 - ginv;
% img=g;
% img=~img;
if(debug)
    figure(02);
    imshow(img);
end
%[skr,rad] = skeleton(img);
skel = ZSkeleton(img);
% the intensity at each point is proportional to the degree of evidence
% that this should be a point on the skeleton:
% if(debug)
%     imagesc(skr);
%     colormap jet
%     axis image off
%     % skeleton can also return a map of the radius of the largest circle that
%     % fits within the foreground at each point:
%     imagesc(rad)
%     colormap jet
%     axis image off
% end
% thresholding the skeleton can return skeletons of thickness 2,
% so the call to bwmorph completes the thinning to single-pixel width.
%skel = bwmorph(skr > 35,'skel',inf);
%delete stroke which have number of pixel equal to 1
%-----------------------------------------------------
[LABEL, number_of_stroke]=bwlabel(skel,8);
for k=1:number_of_stroke
    if(sum(sum(LABEL==k))==1)
    [r, c]=find(LABEL==k);
    skel(r,c)=0;
    end
end
%-----------------------------------------------------

if(debug)
    imshow(skel);
    figure(04);
    imshow(skel);
end
skel_copy=skel;
% anaskel returns the locations of endpoints and junction points
[dmap,exy,jxy] = anaskel(skel);
%fix incorrect when 4 junction is other' neighborhood
jxy=fix_four_connected_junction(jxy,height,width);

junctionIndexGroup = FindNearJunction( jxy, height,width );
% x=unique(junctionIndexGroup);
flag1 =0;
for i=1: size(junctionIndexGroup,1)
    if(junctionIndexGroup(i,1)~=0)
        flag1=1;
    end
end
if(size(exy,2)~=0)
    exy = remove_endpoint(jxy,exy,height,width);
end
endLength=size(exy,2);
junctionLength= size(jxy,2);
if((size(exy,2)~=0)&&(size(jxy,2)~=0))
hold on
plot(exy(1,:),exy(2,:),'go')
plot(jxy(1,:),jxy(2,:),'ro')
end

%count the number of white pixel in skeleton image ( length of stroke)
nWhiteSkeleton = sum(skel(:));
%calculate average width of stroke
w=2*nWhiteOriginal/nWhiteSkeleton;

%find two junction which connects to same segment

%find pairs of junction whose distance between them is less than 3
%khai bao mang chua so thu tu cua junction ma no duoc nhom vao dua tren
%dieu kien ben tren( khoang cach nho hon 3)

neighJunction = zeros(junctionLength,8);
for i=1:junctionLength
    neighJunction(i,1)=skel(jxy(2,i)-1,jxy(1,i));
    neighJunction(i,2)=skel(jxy(2,i)-1,jxy(1,i)+1);
    neighJunction(i,3)=skel(jxy(2,i),jxy(1,i)+1);
    neighJunction(i,4)=skel(jxy(2,i)+1,jxy(1,i)+1);
    neighJunction(i,5)=skel(jxy(2,i)+1,jxy(1,i));
    neighJunction(i,6)=skel(jxy(2,i)+1,jxy(1,i)-1);
    neighJunction(i,7)=skel(jxy(2,i),jxy(1,i)-1);
    neighJunction(i,8)=skel(jxy(2,i)-1,jxy(1,i)-1);
end
%delete junction point to divide stroke into segment (spurious segment and
%real segment)
for i=1: junctionLength
    skel(jxy(2,i),jxy(1,i))=0;
    skel(jxy(2,i)+1,jxy(1,i))=0;
    skel(jxy(2,i)-1,jxy(1,i))=0;
    skel(jxy(2,i),jxy(1,i)+1)=0;
    skel(jxy(2,i),jxy(1,i)-1)=0;
    skel(jxy(2,i)+1,jxy(1,i)+1)=0;
    skel(jxy(2,i)+1,jxy(1,i)-1)=0;
    skel(jxy(2,i)-1,jxy(1,i)-1)=0;
    skel(jxy(2,i)-1,jxy(1,i)+1)=0;
end

% D= bwdist(~img);
%L is matrix with labled line of stroke
[L, num]=bwlabel(skel,8);
%ve mau cho segment
segmentLength = zeros(1,num);
for k=1:num
    segmentLength(k) = sum(sum(L==k));
end

[label,numOfSpur] = finding_spurious_segment(w,jxy,skel_copy,img,k1,k2);

index=0;
%tinh toan de tinh toan 2 diem dau cuoi cua moi segment
featurePoints=zeros(2,junctionLength+endLength);
for i=1:junctionLength
    featurePoints(1,i)= jxy(1,i);
    featurePoints(2,i)=jxy(2,i);
end
for i=1:endLength
    featurePoints(1,junctionLength+i)=exy(1,i);
    featurePoints(2,junctionLength+i)=exy(2,i);
end

[ U ] = find_two_terminate_points_of_stroke( skel_copy,jxy,exy,junctionIndexGroup,featurePoints,height,width );

%code khong grouping















%code tinh toan ghep cac spurious segment


%array node show the node index which spurious segments belong to
%cot dau tien la so thu tu cua spurious segment trong so cac segment, cot
%thu 2 la so thu tu cua group ma spurious do thuoc ve
segmentNodeIndex=zeros(numOfSpur,2);
%array contain juctions which belong to spurious segments
spurSegmentJunction= zeros(numOfSpur,2);

for k=1:num
    if(label(k)==2)
        index=index+1;
        segmentNodeIndex(index,1)=k;
        spurSegmentJunction(index,1)=U(k,1);
        spurSegmentJunction(index,2)=U(k,2);
    end
end
%phai xem xet lai boi vi khong phai tat ca cac junction deu ket noi den
%spurious segmment nen de ap dung cai ben duoi can phai tinh tat ca cac
%junction ket noi den spurious, cac junction khong ket noi den thi phai xet
%rieng...........

%tinh toan cac junction ma khong ket noi den spurious segment, dieu nay phu
%thuoc vao viec xet mang? JunctionIndexGroup
%numOfnoConnected la so luong junction ko ket noi den spurious segment
%khai bao mang chua tat ca cac junction ket noi den spurious segment
% spurSegmentJunction(numOfSpur*2,1);

[group, uni, equiv]= groupspurioussegment( spurSegmentJunction, numOfSpur );

% chu y truong hop khi khong co spurious nhung sizeOfGroup van la 1

if(numOfSpur~=0)
sizeOfGroup=size(group,2);
sizeOfUni=size(uni,2);
else
    sizeOfGroup=0;
end
for k=1:numOfSpur
    for j=1:sizeOfUni
    if(spurSegmentJunction(k,1)==uni(j))
       segmentNodeIndex(k,2)=equiv(j);
    end
    end
end

%toa do x cua diem giao
xPosition=0;
yPosition=0;
%mang chua toa do trung diem cua spurious
centerPositionOfSpur=zeros(2,numOfSpur);
%mang chua toa do cua junction cua tung group
positionOfGroup=zeros(2,sizeOfGroup);
index=0;
for i=1:numOfSpur
    centerPositionOfSpur(i,1)=round((jxy(1,spurSegmentJunction(i,1))+jxy(1,spurSegmentJunction(i,2)))/2);
    centerPositionOfSpur(i,2)=round((jxy(2,spurSegmentJunction(i,1))+jxy(2,spurSegmentJunction(i,2)))/2);
end
%code tinh toan toa do cua junction moi cua tung group
for i=1:sizeOfGroup
    for j=1:numOfSpur
        if(segmentNodeIndex(j,2)==group(i))
        index=index+1;
        xPosition=xPosition+centerPositionOfSpur(j,1);
        yPosition=yPosition+centerPositionOfSpur(j,2);
        end
    end
        positionOfGroup(1,i)=round(xPosition/index);
        positionOfGroup(2,i)=round(yPosition/index);
        index=0;
        xPosition=0;
        yPosition=0;
end
%Tinh toan so luong diem noi sau khi ghep cac junction lai voi nhau
numOfNewJunction=0;
for i=1:junctionLength
    if(junctionIndexGroup(i)~=0)
        numOfNewJunction=numOfNewJunction+1;
    end
end
numOfGroupfromAd=numOfNewJunction/2;
numOfNewJunction=numOfNewJunction/2+sizeOfGroup;
%sua lai junctionIndexGroup voi form nhu sau cot dau la junction cu cot 2
%la junction moi,neu khong phai nhom thi van giu nguyen la 0
newJunctionIndexGroup= zeros(junctionLength,1);
index=0;

for j=1:junctionLength
    if(junctionIndexGroup(j)~=0)
        if(junctionIndexGroup(j)>j)
          newJunctionIndexGroup(j)=j;
        else 
          newJunctionIndexGroup(j)= junctionIndexGroup(j); 
        end
    end
end

S=zeros(numOfNewJunction,8);
index1=0;
index2=0;
% for i=1:numOfGroupfromAd
   for j=1:junctionLength
       if(junctionIndexGroup(j,1)~=0)
           index1=index1+1;
           temp_array(index1)=junctionIndexGroup(j,1);
           if(index1==2)
           index2=index2+1;
           S(index2,1)=junctionIndexGroup(j,2);
           S(index2,2)=junctionIndexGroup(j,3);
               for k=1:num
                    if((U(k,1)==temp_array(1))||(U(k,2)==temp_array(1))||(U(k,2)==temp_array(2))||(U(k,2)==temp_array(2)))
                        index=index+1;
                        S(index2,(index+2))=k;
                    end
               end
           index1=0;
           index=0;
           temp_array=zeros(1,2);
           end
       end
   end
% end

for i=1:sizeOfGroup
    S(i+numOfGroupfromAd,1)=positionOfGroup(1,i);
    S(i+numOfGroupfromAd,2)=positionOfGroup(2,i);
    for j=1:numOfSpur
        if (segmentNodeIndex(j,2)==group(i))
            m=U(segmentNodeIndex(j,1),1);
            n=U(segmentNodeIndex(j,1),2);
                for k=1:num
                    if((m==U(k,1))||(m==U(k,2))||(n==U(k,1))||(n==U(k,2)))
                        if(segmentNodeIndex(j,1)~=k)
                        index=index+1;
                        S(i+numOfGroupfromAd,(index+2))=k;
                        end
                    end
                end
        end
    end
    index=0;
end
%code tim nhung junction binh thuong khong ket noi den spurious segment
%cung nhu khong thuoc vao nearest junction
%normalJunctionIndex chua thong tin ve cac junction do, tai vi tri index ma
%normalJunctionIndex=1 thi do ko phai la junction binh thuong
%
normalJunctionIndex=zeros(1,junctionLength);
for i=1:num
    if (label(i)==2)
        normalJunctionIndex(U(i,1))=1;
        normalJunctionIndex(U(i,2))=1;
    end
end
if(flag1==1)
[n_height,n_width]=size(junctionIndexGroup);
if(n_height>1)
    for i=1:n_height
        if(junctionIndexGroup(i,1)~=0)
            normalJunctionIndex(junctionIndexGroup(i,1))=1;
        end
    end
end
end
%duyet mang normalJunctionIndex de tim xem junction nao binh thuong de dien
%them vao S
[S_width,S_length]=size(S);
index=0;
index1=0;
for i=1:junctionLength
    if(normalJunctionIndex(i)==0)
        index=index+1;
        S(S_width+index,1)=jxy(1,i);
        S(S_width+index,2)=jxy(2,i);
        for j=1:num
            if ((U(j,1)==i)||(U(j,2)==i))
                index1=index1+1;
                S(S_width+index,index1+2)=j;
            end
        end
        index1=0;
    end
end
index=0;
% [S_width,S_length]=size(S);
% if(S_width==2)
%     skel(S(1,2),S(1,1))=255;
% end
% if(S_width>2)
% for i=1:S_width
%     skel(S(i,1),S(i,1))=255;
% end
% end
skel=im2bw(skel);

for i=1:junctionLength
    skel(jxy(2,i),jxy(1,i))=1;
    skel(jxy(2,i)-1,jxy(1,i))=neighJunction(i,1);
    skel(jxy(2,i)-1,jxy(1,i)+1)=neighJunction(i,2);
    skel(jxy(2,i),jxy(1,i)+1)=neighJunction(i,3);
    skel(jxy(2,i)+1,jxy(1,i)+1)=neighJunction(i,4);
    skel(jxy(2,i)+1,jxy(1,i))=neighJunction(i,5);
    skel(jxy(2,i)+1,jxy(1,i)-1)=neighJunction(i,6);
    skel(jxy(2,i),jxy(1,i)-1)=neighJunction(i,7);
    skel(jxy(2,i)-1,jxy(1,i)-1)=neighJunction(i,8);
end
if(debug)
    figure(07);
    imshow(skel);
end
S_length=size(S,1);
% for i=1:S_width
%     skel(S(i,2),S(i,1))=1;
%     hold on
%     plot(S(i,1),S(i,2),'ro')
%     plot(exy(1,:),exy(2,:),'go')
% end
%can phai tinh ra not toa do cua new junction

%code draw line at the intersection of original line

%update U do` segment la loop cot thu 3 =1 la loop, =0 la segment bthuong

U_new=U;
U_new=update(U_new,uni,equiv);
for i=1:num
    if(U_new(i,1)==U_new(i,2))
        U_new(i,3)=1;
    else 
        U_new(i,3)=0;
    end
end
for i=1:num
    U(i,3)=U_new(i,3);
end
index=0;
for i=1:junctionLength
    if(junctionIndexGroup(i,1)~=0)
        index=index+1;
        temp_array(index)=junctionIndexGroup(i,1);
        if(index==2)
            for j=1:num
                if(((U(j,1)==temp_array(1))&&(U(j,2)==temp_array(2)))||((U(j,1)==temp_array(2))&&(U(j,2)==temp_array(1))))
                    U(j,3)=1;
                end
            end
            index=0;
            temp_array=zeros(1,2);
        end
    end
end
[skel_copy,stroke_points_seq] =drawFinalResults(S,U,skel_copy,sizeOfGroup,numOfGroupfromAd,label,jxy,segmentLength,debug);
if(debug)
figure;
imshow(skel_copy);
end
%draw segment
for k=1:num 
    if (label(k)==2)
      [r, c]=find(L==k);
      for j=1:segmentLength(k)
          skel_temp(r(j),c(j))=0;
      end
    end
end
%update lai bien U lan nua de phan biet spurious sgment vs loop
for i=1:num
    if(label(i)==2)
        U(i,3)=2;
    end
end

num_of_feature_point=S_length+endLength;
for i=1:S_length
List_of_feature_points(i,1)=S(i,2);
List_of_feature_points(i,2)=S(i,1);
end
for i=1:endLength
List_of_feature_points(i+S_length,1)=exy(2,i);
List_of_feature_points(i+S_length,2)=exy(1,i);
end
%bang ket noi giua endpoint va junctionpoint
%stt cua junction trong S se dc ghi lai o bang nay ung voi stt cua endpoint
%trong List_of_feature_points
end_point_connection=zeros(endLength,1);
m_adjacent=zeros(S_length+endLength,S_length+endLength);
index=0;
for i=junctionLength+1:junctionLength+endLength
    for j=1:num
       if((U(j,1)==i)&&(U(j,2)>junctionLength))
           end_point_connection(i-junctionLength)=U(j,2)-junctionLength+S_length;
       end
       if((U(j,2)==i)&&(U(j,1)>junctionLength))
           end_point_connection(i-junctionLength)=U(j,1)-junctionLength+S_length;
       end
       if((U(j,1)==i)||(U(j,2)==i))
            for k=1:S_length
                for m=3:8
                    if (S(k,m)==j)
                        end_point_connection(i-junctionLength)=k;
                    end
                end
            end
       end
    end
end

index=0;
for i=1:S_length
    for m=3:8
        x=S(i,m);
        if(x~=0)
        for j=i+1:S_length
            for n=3:8
                y=S(j,n);
                if (x==y)
                    m_adjacent(i,j)=m_adjacent(i,j)+1;
                    m_adjacent(j,i)=m_adjacent(j,i)+1;
                end
            end
        end
        end
    end
end

for i=1:S_length
    for m=3:8
        x=S(i,m);
        if(x~=0)
        for j=1:num
            if(U(x,3)==1)
                m_adjacent(i,i)=2;
            end
        end
        end
    end
end
if(S_length == 0)
    fprintf('\n******************************************\n');
    fprintf('\n[WARN] - S_length == 0 *******\n');
    fprintf('\n******************************************\n');
end

for i=1:endLength
    m_adjacent(S_length+i,end_point_connection(i))=1;
    m_adjacent(end_point_connection(i),S_length+i)=1;
end
%code for finding point sequence of stroke connecting two endpoints
for i=1:num
    if((U(i,1)>junctionLength)&&(U(i,2)>junctionLength))
        single_stroke=(L==i);
        start_point=[exy(2,U(i,1)-junctionLength),exy(1,U(i,1)-junctionLength)];
        end_point=[exy(2,U(i,2)-junctionLength),exy(1,U(i,2)-junctionLength)];
        seq=extractPointSeqs(single_stroke,start_point, end_point);
        stroke_points_seq{i}= {seq};
    end
    if((U(i,1)==0)&&(U(i,2)==0))
        index=index+1;
        single_stroke=(L==i);
        BB = regionprops(single_stroke, 'BoundingBox');
        box = BB(1).BoundingBox;     

        left = uint16(box(1));
        top = uint16(box(2));
        right = uint16(box(1)+box(3));
        bot = uint16(box(2)+box(4));
        mid_lr = (left+right)/2;
%         [m,n] = size(L);
        for ii=top:bot
        if( single_stroke(ii,mid_lr) ~= 0)
           start_point = [ii mid_lr];
           end_point = start_point;
           List_of_feature_points(endLength+S_length+index,1)=start_point(1,1);
           List_of_feature_points(endLength+S_length+index,2)=start_point(1,2);
           break;
        end
        end
        seq=extractPointSeqs(single_stroke,start_point, end_point);
        stroke_points_seq{i}= {seq};
        m_adjacent(endLength+S_length+index,endLength+S_length+index)=2;
    end
end
[row,col]=size(stroke_points_seq);
num_of_feature_point = size(List_of_feature_points,1);
%% DUNG: In case, there is no result from skeleton of a dot, temporarily result is ignore this component
if(num_of_feature_point == 0)
    return;
end

for i=1:col
    if(~(isempty(stroke_points_seq{i})))
    seq = cell2mat(stroke_points_seq{i});
    [row1, col1]= size(seq);
    start_point=seq(1,:);
    end_point=seq(row1,:);
    for j=1:num_of_feature_point
        if(isequal(start_point,List_of_feature_points(j,:)))
            start_point_index=j;
        end
        if(isequal(end_point,List_of_feature_points(j,:)))
            end_point_index=j;
        end
    end
    terminate_point=[start_point_index,end_point_index];
    start_point_index=0;
    end_point_index=0;
    seq=[terminate_point' seq']';
    stroke_points_seq{i}={seq};
    end
end


%output is List_of_feature_points: list of junction and then list of
%endpoint
%           m_adjacent: connection matrix (n-by-n matrix, n= length of
%           List_of_feature_points)
%           stroke_points_seq: point sequence of stroke, the order or index
%           of stroke come from connected components.
%           m_edges: edges No between 2 vertices
% remove empty cell
empties = find(cellfun(@isempty,stroke_points_seq)); % identify the empty cells
stroke_points_seq(empties) = [];                      % remove the empty cells

%%
% m_edges is square matrix
% m_edges = zeros(size(m_adjacent));
% index=0;
% for i=1:size(stroke_points_seq,2)
%     % get start_point & end_point
%     stroke_tmp = cell2mat(stroke_points_seq{1,i});       
%     s = stroke_tmp(1,1);
%     t = stroke_tmp(1,2);
%     if(m_adjacent(s,t)==2)
%         index=index+1;
%         array_temp(index)=i;
%         if(index==1 && s==t) % loop vertex
%             m_edges(s,t)=array_temp(1);
%             m_edges(t,s)=m_edges(s,t);
%             index=0;
%             array_temp = [];
%         end
%         if(index==2) % 2 edges b/w 2 vertices
%             m_edges(s,t)=array_temp(1);
%             m_edges(t,s)=array_temp(2);
%             index=0;
%             array_temp = [];
%         end
%     else
%     %fprintf('\n%d,(s,t)=(%d,%d)\n',i,s,t);
%     m_edges(s,t) = i;
%     m_edges(t,s) =  m_edges(s,t);
%     end
%     stroke_tmp = double(stroke_tmp);
%     stroke_points_seq{1,i} = stroke_tmp(2:size(stroke_tmp,1),:);
% end
%% m_edges is matrix with structure:
% e1 e2 v_idx1 v_idx2 ...
% ....
    max_cl = size(List_of_feature_points,1);
    index=0;
    m_edges{max_cl,max_cl} = [];
    for i=1:size(stroke_points_seq,2)
        % get start_point & end_point
        stroke_tmp = cell2mat(stroke_points_seq{1,i});       
        s = stroke_tmp(1,1);
        t = stroke_tmp(1,2);
    
        %fprintf('\n%d,(s,t)=(%d,%d)\n',i,s,t);
        if(m_edges{s,t})
            m_edges{s,t} = [m_edges{s,t} i];  
            m_edges{t,s} =  m_edges{s,t};
        else
            m_edges{s,t} = i;
            m_edges{t,s} =  m_edges{s,t};
        end
        stroke_tmp = double(stroke_tmp);
        stroke_points_seq{1,i} = stroke_tmp(2:size(stroke_tmp,1),:);
    end
    %%
    %calculate average width of stroke
    nWhiteSkeleton = sum(skel(:));
    nWhiteOriginal = sum(img(:));
    stroke_width = round(nWhiteOriginal/nWhiteSkeleton);
    %set(0,'DefaultFigureVisible','on');
end





