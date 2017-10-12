% findFrameSets.m
% findFrameSets reformats the frames structure in order to allow for the
% comparison of sets of colocalization measures

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Copyright (C) 2015  Justin Melunis, Uri Hershberg, and Andrew Cohen
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Set] = findFrameSets(Frames)
T=0;
for t=1:length(Frames)
    %if Frames(t).missing==0
        T=T+1;
        for j=1:6
            for k=1:6
                Set(j).D(k,T)=Frames(t).D(j,k);
            end
        end
   % end
end

