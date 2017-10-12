% /******************************************************************************
% 
% This program, "NCDM", the associated MATLAB scripts and all 
% provided data, are copyright (C) 2014 Andrew R. Cohen, All rights reserved.
% 
% This program uses bzip2 compressor as a static library.
% A built version for windows 64 is included. for other platforms, see 
% the files in the bzlib project on https://git-bioimage.coe.drexel.edu
% 
% This software may be referenced as:
% 
% A.R. Cohen, C. Bjornsson, S. Temple, G. Banker,  and B. Roysam, 
% "Automatic Summarization of Changes in Biological Image  Sequences 
% using Algorithmic Information Theory".  IEEE Transactions on Pattern 
% Analysis  and Machine Intelligence, 2009. 31(8): p.  1386-1403. 
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions
% are met:
% 
% 1. Redistributions of source code must retain the above copyright
%    notice, this list of conditions and the following disclaimer.
% 
% 2. The origin of this software must not be misrepresented; you must 
%    not claim that you wrote the original software.  If you use this 
%    software in a product, an acknowledgment in the product 
%    documentation would be appreciated but is not required.
% 
% 3. Altered source versions must be plainly marked as such, and must
%    not be misrepresented as being the original software.
% 
% 4. The name of the author may not be used to endorse or promote 
%    products derived from this software without specific prior written 
%    permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
% OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
% GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
% WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% Andrew R. Cohen acohen@coe.drexel.edu
% GapSpectral version 1.0 (release) November 2014
% 
% ******************************************************************************/

% make the distance matrix symetric (positive semi-definite), so
% eigen* are all real. needed due to slight asymetry in compression for NCD
% called by GapSpectral and SpectralCluster
%
% degenerate is two elements having zero distance - violates the identity
% axiom
function [D,degenerate] = Regularize(DistanceMatrix)

% turn output from NCD into well behaved  distance matrix

D=DistanceMatrix;
% b = max(max(D));
% D=D/b; 
for i=1:size (D,1)
     for j= 1:size(D,2)
         D(i,j)= max(D(i,j),D(j,i));
     end
     D(i,i)=0;
end

bound=D;
for i=1: size(bound,1)
    bound(i,i)=NaN;
end
a =  min(min(bound));
if 0==a
    degenerate=1;
else
    degenerate=0;
end
     
        
