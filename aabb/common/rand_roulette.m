% RAND_ROULETTE short description
%
% SYNTAX
% [output] = rand_roulette(M)
%
% INPUT PARAMETERS
%   weights: roulette fitness, the smallest means the more probable
%   N_sampl: amount of samples to generate
%   offset:  avoid divide by zero when one of the weights is zero
%   ratio:   generates random samples only in the range [0..1/ratio]
%            when a candidate needs to be extracted. This makes the 
%            choice more polarized toward high fitness for higher
%            levels of ratio. (ratio=1 disabled)
%           
% OUTPUT PARAMETERS
%   idxs: sampling of the weight vectors according to the fitness
%
% DESCRIPTION
% TODO TODO TODO
% 
% See also:
% RAND
%

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  Created on: 2008/10/01
function idxs = rand_roulette(weights, N_sampl, offset, ratio )
    idxs = zeros( N_sampl,1 );

    % this prevents a division by zero
    F = 1./(offset+weights);
    [Fsort, I] = sort( F, 'descend' );	
    Fsort = Fsort - min( Fsort );           
    Fsort = Fsort / max( Fsort );			
    Fcumsum = cumsum(Fsort);				
    Fcumsum = Fcumsum - min(Fcumsum);		
    Fcumsum = Fcumsum / max( Fcumsum );		
    for i=1:N_sampl
        random = rand/ratio;
        curr_idx = find( Fcumsum > random, 1);
        idxs(i)  = I( curr_idx );
    end;
end %end of rand_roulette
