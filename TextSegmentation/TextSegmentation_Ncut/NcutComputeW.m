function W = NcutComputeW(I, SI, SX, r)
% NcutComputeW - Compute a similarity (weight) matrix
%
% Synopsis
%  W = NcutComputeW(I, SI, SX, r)
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
%
% Outputs ([]s are optional)
%  (matrux) W        N x N matrix representing the computed similarity 
%                    (weight) matrix.
%                    W(i,j) is similarity between node i and j.
%

[nRow, nCol, c] = size(I);
N = nRow * nCol;
W = sparse(N,N);

% Feature Vectors
if c == 3
    F = F3(I);
else
    F = F2(I);
end
F = reshape(F, N, 1, c); % col vector

% Spatial Location, e.g.,
% [1 1] [1 2] [1 2]
% [2 1] [2 2] [2 3]
X = cat(3, repmat((1:nRow)', 1, nCol), repmat((1:nCol), nRow, 1));
X = reshape(X, N, 1, 2); % col vector

r = floor(r);
% Future Work: Reduce computation to half. It can be done
% because W is symmetric mat
for ic=1:nCol
    W(ic,ic) = 1;
    for ir=1:nRow
        % matlab tricks for fast computation (Avoid 'for' loops as much as
        % possible, instead use repmat.)

        % This range satisfies |X(i) - X(j)| <= r (block distance)
        jc = (ic - r) : (ic + r); % vector
        jr = ((ir - r) :(ir + r))';
        jc = jc(jc >= 1 & jc <= nCol);
        jr = jr(jr >= 1 & jr <= nRow);
        jN = length(jc) * length(jr);

        % index at vertex. V(i)
        i = ir + (ic - 1) * nRow;
        j = repmat(jr, 1, length(jc)) + repmat((jc -1) * nRow, length(jr), 1);
        j = reshape(j, length(jc) * length(jr), 1); % a col vector

        % spatial location distance (disimilarity)
        XJ = X(j, 1, :);
        XI = repmat(X(i, 1, :), length(j), 1);
        DX = XI - XJ;
        DX = sum(DX .* DX, 3); % squared euclid distance
        %DX = sum(abs(DX), 3); % block distance
        % square (block) reagion may work better for skew lines than circle (euclid) reagion.

        % |X(i) - X(j)| <= r (already satisfied if block distance measurement)
        constraint = find(sqrt(DX) <= r);
        j = j(constraint);
        DX = DX(constraint);

        % feature vector disimilarity
        FJ = F(j, 1, :);
        FI = repmat(F(i, 1, :), length(j), 1);
        DF = FI - FJ;
        DF = sum(DF .* DF, 3); % squared euclid distance
        %DF = sum(abs(DF), 3); % block distances

        % Hint: W(i, j) is a col vector even if j is a matrix
        %W(i, j) = exp(-DF / (SI*SI)) .* exp(-DX / (SX*SX)); % for squared distance
        W(i,j) = exp(-DF / SI) .* exp(-DX / SX);
        %W(j,i) = W(i,j)';
    end
end
end

% F1 - F4: Compute a feature vector F. See 4 EXPERIMENTS
%
%  F = F1(I) % for point sets
%  F = F2(I) % intensity
%  F = F3(I) % hsv, for color
%  F = F4(I) % DOOG
%
%  Input and output arguments ([]'s are optional):
%   I (scalar or vector). The image.
%   F (scalar or vector). The computed feature vector F
%
% Author : Naotoshi Seo
% Date   : Oct, 2006
% for point sets
function F = F1(I);
F = (I == 0);
end
function F = F2(I);
% intensity, for gray scale
F = I;
end
function F = F3(I);
% hsv, for color
F = I; % raw RGB
% Below hsv resulted in errors at eigs(). eigs returns erros so often.
%  F = rgb2hsv(double(I)); % V = [0, 255] with double, V = [0, 1] without double
%  % any fast way in matlab?
%  [nRow nCol c] = size(I);
%  for i=1:nRow
%      for j=1:nCol
%          HSV = reshape(F(i, j, :), 3, 1);
%          h = HSV(1); s = HSV(2); v = HSV(3);
%          F(i, j, :) = [v v*s*sin(h) v*s*cos(h)];
%      end
%  end
end
function F = F4(I);
% DOOG, for texture
% Future
end
