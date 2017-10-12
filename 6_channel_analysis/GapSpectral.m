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

function [kGap Gap S idx] = GapSpectral(DistanceMatrix,nMaxClusters,bAlgorithmicInformationDistance)

if nargin<3
    bAlgorithmicInformationDistance=1;
end
B = 50; % size of Monte Carlo distribution
if nMaxClusters>size(DistanceMatrix,1)
    nMaxClusters = size(DistanceMatrix,1)-1;
end

D =   Regularize(DistanceMatrix);
bound=D;
for i=1: size(bound,1)
    bound(i,i)=NaN;
end
a =  min(min(bound));%;
b = max(max(bound));
UV =  a + (b-a)*rand(size (D,1),size (D,2),B); % uniform distribution
for k=1:nMaxClusters
    if (1==k) %
        % one happy cluster
        idx = ones(size (D,1),1);
    else
        idx = SpectralCluster(D,k);
    end
    W(k)=WkSpectral(k,idx,D);
    for ib =1:B
        uni =  UV(:,:,ib);
        uni = Regularize(uni); % make uni a valid distance matrix
        if (1==k) %
            % one happy cluster
            idx = ones(size (D,1),1);
        else
            idx = SpectralCluster(uni,k);
        end
        Wb(ib,k)=WkSpectral(k,idx,uni);;
    end
    Wkb = Wb(:,k);
    lkb = log(Wkb);
    if bAlgorithmicInformationDistance
        Gap(k) = 1/B*sum(Wkb) - W(k);
        sdk = std(Wkb,1);
    else
        Gap(k) = 1/B*sum(lkb) - log(W(k));
        sdk = std(lkb,1);
    end
    S(k)=sdk * sqrt(1+1/B);
    %     Gap
    %     S
end

%figure
errorbar( [1:nMaxClusters],Gap,S)
set(gca,'XTick',[1:nMaxClusters])

k=1;
while ((k<nMaxClusters) && (Gap(k) < Gap(k+1)-S(k+1)))
    k=k+1;
end
kGap=k;
if (kGap>1)
    idx = SpectralCluster(D,kGap);
else
    idx = ones(size (D,1),1);
end

function w=WkSpectral(k,idx,DistanceMatrix)
% called by GapSpectral

for r =1:k
    % find points in cluster r
    pr = find(idx==r);
    D(r) = 0;
    for i=1:size(pr,1)
        for j=i:size(pr,1)
            D(r) = D(r)+DistanceMatrix(pr(i),pr(j));
        end
    end
    D(r) = D(r)/(2*size(pr,1)); %(2) in paper
end

w =  sum(D);
    
