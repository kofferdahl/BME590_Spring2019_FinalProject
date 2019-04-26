function [rf_img, ax, lat, scat_space, scat_space_fft, psf_fft] = ...
    convPsfPtTarget(psf, ax_psf, lat_psf, ax_img, lat_img, pt_locs, params)
%convPsfPtTarget: convolves a psf with a uniform distribution of scatterers
%
% Syntax:  [rf_img, ax, lat, scat_space] = convPsfPtTarget(psf, ax_psf,
% lat_psf, ax_img, lat_img, params, pt_locs, params)
%
% Inputs:
%    psf: 2D point spread function
%    ax_psf: Axial dimmension vector for PSF
%    lat_psf: Lateral dimmension vector for PSF
%    ax_img: axial length of image in meters
%    lat_img: lateral length of image in meters
%    pt_locs: Axial locations of point targets in meters
%    params: params structure
%
% Outputs:
%    rf_img: RF image from convolving psf with uniform scatterers
%    ax: Axial vector for image (meters)
%    lat: Lateral vector for image (meters)
%    scat_space: Scatterer space that the psf was convolved with
%
%
%
% Other m-files required: calcResCellPSF, calcFWHM
% Subfunctions: none
% MAT-files required: none
%
% Author: Katelyn Offerdahl
% Email address: katelyn.offerdahl@duke.edu
% February 2019; Last revision: 1-February-2019

res_area = calcResCellPSF(psf, ax_psf, lat_psf);

ax_spacing = ax_psf(2) - ax_psf(1);
lat_spacing = lat_psf(2) - lat_psf(1);

num_ax_samples = ceil(ax_img / ax_spacing);
num_lat_samples = ceil(lat_img / lat_spacing);
scat_space_sz = [num_ax_samples, num_lat_samples];

scat_space = zeros(scat_space_sz);

ax = ((-num_ax_samples/2):((num_ax_samples-1)/2))*ax_spacing; %+ params.focal_depth;
lat = (0:num_lat_samples-1)*lat_spacing;

ax = (0:num_ax_samples-1)*ax_spacing;
lat = ((-num_lat_samples/2):(num_lat_samples-1)/2)*lat_spacing;
img_area = ax_img * lat_img;
num_res_cells = img_area / res_area;
nScat = ceil(20*ceil(num_res_cells));

ax_pt_locs_samples = round(pt_locs / ax_spacing);
lat_pt_locs_samples = round(num_lat_samples/2);

for i = 1:length(ax_pt_locs_samples)
    scat_space(ax_pt_locs_samples(i), lat_pt_locs_samples) = 1;
end





% convolve scatterers w/psf by mx in freq. domain
scat_space_fft = fft2(scat_space);
psf_fft = fft2(psf, num_ax_samples, num_lat_samples);
c = scat_space_fft .* psf_fft;
tmp=ifft2(c);

% drop the first and last size(psf/2) samples and the lat as well
lat_crop_inx=floor(size(psf,2));
ax_crop_inx=floor(size(psf,1)/2);
rf_img=tmp(ax_crop_inx:end-ax_crop_inx,lat_crop_inx:end);
rf_img = tmp(ax_crop_inx:end-ax_crop_inx, :);
%size(rf_img)
%size(max(rf_img(:)))
rf_img=rf_img./max(rf_img(:)); % normalize rf image
scat_space = scat_space(ax_crop_inx:end-ax_crop_inx,lat_crop_inx:end);


end

