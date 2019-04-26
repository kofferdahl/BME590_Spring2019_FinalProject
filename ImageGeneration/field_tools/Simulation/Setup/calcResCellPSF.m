function [res_cell] = calcResCellPSF(psf, ax, lat)
%calcResCellPSF: calculates the resolution cell area from full width half
%maximum of PSF
%
% Syntax:  res_cell = calcResCell(psf, ax, lat)
%
% Inputs:
%    psf: 2D point spread function
%    ax: Axial vector for psf
%    lat: Lateral vector for psf

% Outputs:
%    res_cell: Resolution cell size in squared units of ax and lat
%
%
% Other m-files required: calcFWHM
% Subfunctions: none
% MAT-files required: none
%
% Author: Katelyn Offerdahl
% Email address: katelyn.offerdahl@duke.edu
% January 2019; Last revision: 24-January-2019

env=abs(hilbert(psf)); % envelope detect
env=env/max(max(env)); % normalize

[val max_lat]=max(max(env));
[val max_ax]=max(max(env'));

ax_line = psf(:, max_lat);
ax_line = ax_line ./ max(ax_line(:));
lat_line = psf(max_ax, :);
lat_line = lat_line ./ max(lat_line(:));

ax_fwhm = calcFWHM(ax_line, ax);
lat_fwhm = calcFWHM(lat_line, lat);

res_cell = ax_fwhm * lat_fwhm;

end

