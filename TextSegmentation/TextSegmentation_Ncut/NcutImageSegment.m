function SegI = NcutImageSegment(I, SI, SX, r, sNcut, sArea, nGrayLevel)
% NcutImageSegment - Normalized Cuts and Image Segmentation [1]
%
% Synopsis
%  [SegI] = NcutImageSegment(I, SI, SX, r, sNcut, sArea)
%
% Description
%  Normalized Cuts and Image Segmentation [1]
%
% Inputs ([]s are optional)
%  (matrix) I        nRow x nCol x c matrix representing image.
%                    c is 3 for color image, 1 for grayscale image.
%                    Let me define N = nRow x nCol.
%  (scalar) SI       Coefficient used to compute similarity (weight) matrix
%                    Read [1] for meanings.
%  (scalar) SX       Coefficient used to compute similarity (weight) matrix
%                    Read [1] for meanings.
%  (scalar) r        Coefficient used to compute similarity (weight) matrix
%                    Definition of neighborhood.
%  (scalar) sNcut    The smallest Ncut value (threshold) to keep partitioning.
%  (scalar) sArea    The smallest size of area (threshold) to be accepted
%                    as a segment.
%
% Outputs ([]s are optional)
%  (cell)    SegI    cell array of segmented images of nRow x nCol x c.

[nRow, nCol, c] = size(I);
N = nRow * nCol;
V = reshape(I, N, c); % connect up-to-down way. Vertices of Graph
disp('Compute weight matrix ...');
tic
% Step 1. Compute weight matrix W, and D
W = NcutComputeW(I, SI, SX, r);
toc
%
disp('Compute histogram of grayscale matrix ...');
tic
% Step 2: Compute histogram of gray matrix H
H = NcutComputeHistogram(V,nGrayLevel);
toc

disp('Compute Affinity matrix ...');
tic
% Step 3: Compute affinity matrix
M = NcutComputeAfinityMatrix(H,W);
toc

% Step 4. recursively repartition
Seg = (1:size(M,1))';
[Seg Id Ncut] = NcutPartition( Seg, M,sNcut, sArea, 'ROOT');

% convert to image axis
for i=1:length(Seg)
    SegH{i} = [];
    Hs = Seg{i};
    for j=1:length(Hs)
        SegH{i} = [SegH{i}; cell2mat(H(Hs(j)))];
    end
end
% Convert node ids into images
for i=1:length(SegH)    
    subV = ones(N, c) * 255;        
    subV(SegH{i}, :) = zeros(size(V(SegH{i}, :)));
    SegI{i} = uint8(reshape(subV, nRow, nCol, c));    
end
end
