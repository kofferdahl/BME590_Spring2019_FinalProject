function FWHM = calcFWHM(fxn, ax)
%calcFWHM: calculates full with half max of a normalized line without 
%logarithmic compression
%
% Syntax:  FWHM = calcFWHM(fxn, ax)
%
% Inputs:
%    fxn: Function to be analyzed for full width half max
%    ax: Axes of function for distance calculation
%
% Outputs:
%    FWHM: Full width half max of fxn in the units used in ax
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none

% Author: Katelyn Offerdahl
% Email address: katelyn.offerdahl@duke.edu
% January 2019; Last revision: 25-January-2019

min_inx = find(fxn>0.5, 1, 'first');
max_inx = find(fxn>0.5, 1, 'last');

FWHM = ax(max_inx) - ax(min_inx);

end

