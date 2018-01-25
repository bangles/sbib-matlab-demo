function T = mypermutetable(varargin)
% Crates a permutation matrix of a set of values
% 
% USAGE:
%   T = mypermutetable([a A], [b B], [c C] ...);
%   T = mypermutetable([a A; b B; c C ...]);
%
% EXAMPLE:
% >> T = permutetable([0 1; 2 3; 4 5])
% 
% T =
% 
%      0     2     4
%      0     2     5
%      0     3     4
%      0     3     5
%      1     2     4
%      1     2     5
%      1     3     4
%      1     3     5
%

%--- Overloads nargin function
nargin = length(varargin);

%--- Parameterless demo run
if nargin==0
    clc, clear, close all;
    warning('running demo');
    varargin = cell(1,1);
    varargin{1} = [0 1; 2 3; 4 5];
    nargin = 1;
end

if nargin==1
	V = varargin{1};
elseif nargin>1
    V = zeros(nargin,2);
    for nIdx=1:nargin
        V(nIdx,:) = varargin{nIdx};
    end
end

%--- Checks validity of input data
assert( isnumeric(V) );
assert( size(V,1)>=0 );
assert( size(V,2)==2 );
    
%--- Create decimal indexes
ndims = size(V,1);
nvals = 2^ndims;
ptab = dec2bin(0:nvals-1);

%--- Create data
T = zeros(nvals,ndims);

%--- For every dimension
for dIdx=1:ndims
    ccol = ptab(:,dIdx);
    
    % need to do it before to avoid  
    % problems if first substitution
    % contains a 1/0 value
    I0 = (ccol=='0');
    I1 = (ccol=='1');
    
    % perform substitution
    ccol( I0 ) = V(dIdx,1);
    ccol( I1 ) = V(dIdx,2);
    T(:,dIdx) = ccol;
end