function [Seg Id Ncut] = NcutPartition(I, W, sNcut, sArea, id)
% NcutPartition - Partitioning
%
% Synopsis
%  [sub ids ncuts] = NcutPartition(I, W, sNcut, sArea, [id])
%
% Description
%  Partitioning. This function is called recursively.
%
% Inputs ([]s are optional)
%  (vector) I        N x 1 vector representing a segment to be partitioned.
%                    Each element has a node index of V (global segment).
%  (matrux) W        N x N matrix representing the computed similarity
%                    (weight) matrix.
%                    W(i,j) is similarity between node i and j.
%  (scalar) sNcut    The smallest Ncut value (threshold) to keep partitioning.
%  (scalar) sArea    The smallest size of area (threshold) to be accepted
%                    as a segment.
%  (string) [id]     A label of the segment (for debugg)
%
% Outputs ([]s are optional)
%  (cell)   Seg      A cell array of segments partitioned.
%                    Each cell is the each segment.
%  (cell)   Id       A cell array of strings representing labels of each segment.
%                    IDs are generated as children based on a parent id.
%  (cell)   Ncut     A cell array of scalars representing Ncut values
%                    of each segment.
%--------------------------------------------------------------------------

% Compute D
N = length(W);
d = sum(W, 2);
D = spdiags(d, 0, N, N); % diagonal matrix

% Solve generalized eigensystem (D -W)*S = S*D*U (12).
% hide warning message
warning off; 
[U,S] = eigs(D-W, D,2,'sm');
warning on;

% 2nd smallest
U2 = U(:, 1);

% (3). Bipartition the graph at point that Ncut is minimized.
t = mean(U2);
t = fminsearch('NcutValue', t, [], U2, W, D);

A = find(U2 > t);
B = find(U2 <= t);

% Decide if the current partition should be divided
% if either of partition is too small, stop recursion.
% if Ncut is larger than threshold, stop recursion.
ncut = NcutValue(t, U2, W, D);
if (length(A) < sArea || length(B) < sArea) || ncut > sNcut
    Seg{1}   = I;
    Id{1}   = id; 
    Ncut{1} = ncut;
    return;
end

% Seg segments of A
[SegA IdA NcutA] = NcutPartition(I(A), W(A, A), sNcut, sArea, [id '-A']);

% Seg segments of B
[SegB IdB NcutB] = NcutPartition(I(B), W(B, B), sNcut, sArea, [id '-B']);

% concatenate cell arrays
Seg   = [SegA SegB];
Id   = [IdA IdB];
Ncut = [NcutA NcutB];
end
