% UNIFORM_SAMPLE_SPHERE unformly sample direction on the
% spherical domain
%
% SYNTAX
% [V] = uniform_sample_sphere( N )
%
% INPUT PARAMETERS
%   N: number of samples to compute
%
% OUTPUT PARAMETERS
%   V: a Nx3 matrix containing samples on the sphere
%
% DESCRIPTION
%   - RANDOM
%   This function obtains a uniform sampling of points on the surface of the
%   unit sphere. The methods uses a distribution transformation which uses
%   the jacobian matrix as described in [1].
%
%   - MAXDISCREPANCY
%   This function obtains a uniform (poisson) distribution of samples on the
%   surface of the hemi-sphere sampling using "hammersley" method a unit square
%   and then mapping the points to the sphere surface using a "malley" approach.
%   Details about both methods can be found in [1].
%   
%   NOTE: the amount of samples returned is <= of the requested amount
% 
% In general, the function can also be interpreted as a random direction generator.
% 
% See also:
% RAND, RANDPERM
%
% References:
% [1] Matt Pharr Greg Humphreys "Physically based rendering", Morgan Kaufmann, 2004.

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  Created on: 2008/06/18
% $Revision: 2.0$  2008/07/20 by Andrea, added maxdiscrepancy sampling
% 

function [ P ] = uniform_sample_sphere( N, TYPE )

if ~exist('TYPE','var')
    TYPE = 'random';
end

if strcmp( TYPE, 'random' )
    xi1 = rand( N, 1 );
    xi2 = rand( N, 1 );
    I = randperm( N );
    xi2 = xi2( I );
    P = zeros( N, 3);
    P(:,1) = 2*cos( 2*pi*xi2 ) .* sqrt( xi1.*( 1 - xi1) );
    P(:,2) = 2*sin( 2*pi*xi2 ) .* sqrt( xi1.*( 1 - xi1) );
    P(:,3) = 1 - 2*xi1;

elseif strcmp(TYPE, 'foreshortened')
    %% since hammersley need the amount of samples
    % we have to assume that Area(circle)/Area(Square) samples
    % are going to be rejected by rejection sampling
    % thus we need to oversize N
    N = N*pi;
    P = zeros(0,3);
    
    i = 0;
    while i < N
        % sample another hammersley sample
        x = i / N;
        y = phi( i, 2 ); 
        
        % normalize both in [0 1] range
        xnorm = 2*(x-.5);
        ynorm = 2*(y-.5);
    
        % miller method reject outside circle
        xy2 = xnorm^2 + ynorm^2;
        if xy2 <= 1
           P(end+1,:) = [xnorm, ynorm, sqrt( 1-xy2 )];
        end
        
        i = i + 1;
    end
    
elseif strcmp(TYPE, 'maxdiscrepancy-hemisphere')
    
    % allocate memory
    P = zeros(N,3);
    xnorm = zeros(N,1);
    ynorm = zeros(N,1);
    
    % geneate samples in [0 1] poisson distributed
    i = 0;
    while i < N
        % sample another hammersley sample
        xnorm(i+1) = i / N;
        ynorm(i+1) = phi( i, 2 ); 
        
        % normalize both in [0 1] range
        i = i + 1;
    end
    
    % distribution transformation [0-1][0-1] -> polar -> cart
    % for an hemisphere.
    % See [1] pag 651
    P(:,1) = cos( 2*pi*ynorm ) .* sqrt( (1 - xnorm.^2) );
    P(:,2) = sin( 2*pi*ynorm ) .* sqrt( (1 - xnorm.^2) );
    P(:,3) = xnorm;
end

%%% Radical inverse
% see page 319-20 of [1]
function val = phi( n, base )
    val = 0;
    invBase = 1 / base;
    invBi = invBase;
    
    while n>0
        d_i = mod(n,base);
        val = val + d_i*invBi;
        n = floor( n / base );
        invBi = invBi * invBase;
    end
end

end %%% END OF FUNCTION
