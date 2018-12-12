function [ group, uni, equiv ] = groupspurioussegment( spurSegmentJunction, numOfSpur )
%group is the index of first junction in each sprurious group
%equiv is the group index of each junction which connect to spurious
%segment
%uni is the real index of junction corresponds to junction in equiv
%spurSegmentJunction is the index of juction which connect to spurious
%segment.
[r,c]=size(spurSegmentJunction);
numOfnoConnected=unique(spurSegmentJunction);
%can xem lai doan nay vi khi co 1 spur la bi sai thu tu cua dimentional vs
%numOfConnected
if(r==1)
[dimentional0,numOfConnected] = size(numOfnoConnected);
else
[numOfConnected,dimentional0] = size(numOfnoConnected);
end
[indexSpurSegmentJunction,uni]=Rearrange(spurSegmentJunction);

[equiv, ncluster]=TransitiveClosureFromAdjLst(indexSpurSegmentJunction',zeros(1,numOfConnected),numOfSpur,numOfConnected);

group=unique(equiv);

end

