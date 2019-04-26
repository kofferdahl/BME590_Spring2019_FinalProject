function [psf, ax, lat] = makePSF(params, Tx, Rx, timing_correction)
%makePSF: makes a Tx-Rx point spread function (PSF) 
%
% Syntax:  [psf, ax, lat] = makePSF(params, Tx, Rx)
%
% Inputs:
%    params: Params structure
%    Tx: Transmit transducer handle
%    Rx: Receive transducer handle
%    timing_correction: A shift in axial timing 
%
% Outputs:
%    psf: 2D Tx-Rx point spread function
%    ax: axial axis
%    lat: lateral axis
%
% Other m-files required: Field_II library
% Subfunctions: none
% MAT-files required: none

% Author: Katelyn Offerdahl
% Email address: katelyn.offerdahl@duke.edu
% January 2019; Last revision: 25-January-2019
if nargin < 4
    timing_correction = 0;
end

c = params.c;
fs = params.fs;
lambda = params.lambda;
f_num = params.f_num;

ax_spacing=c/2/fs;
lat_spacing=ax_spacing;
lat_range = 2*lambda*f_num*3;
lat=-1*lat_range:lat_spacing:lat_range;

points=zeros(length(lat),3);
points(:,1)=lat;
points(:,3)=points(:,3)+params.focus(3);

[psf, start_time] = calc_hhp(Tx, Rx, points); 

timing=0:1/fs:(size(psf,1)-1)/fs;
ax=(timing+start_time+timing_correction)*c/2;



end

