function [kp, fz, fx] = psf2kspace(psf, ax, lat, fs)
%psf2kspace: transforms a psf into k-space representation via 2D fft
%
% Syntax:  [kp, fx, fz] = psf2kspace(psf, ax, lat, fs)
%
% Inputs:
%    psf: 2D point spread function
%    ax: Axial distance vector of psf
%    lat: Lateral distance vector of psf
%    fs: Sampling frequency (Hz)
%
% Outputs:
%    kp: k-space representation of psf
%    fz: Axial frequency vector
%    fx: Lateral frequency vector
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none

% Author: Katelyn Offerdahl; inspired from James Long's qField repository
% Email address: katelyn.offerdahl@duke.edu
% January 2019; Last revision: 25-January-2019

zp = 2^13; % zero padding
lat_sampling = lat(2)-lat(1);
fx = linspace(1/(2*lat_sampling),-1/(2*lat_sampling),zp);
fz = linspace(-fs/2,fs/2,zp);

kp = fftshift(abs(fft2(psf,zp,zp)));


end

