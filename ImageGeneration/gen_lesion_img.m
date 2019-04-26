function [rf_img, bmode_img, scat_space, coords] = gen_lesion_img(contrast)
%GEN_LESION_IMG - makes a 2x2 ultrasound image with a randomly sized and
%located lesion with a specified contrast. This function makes images by
%convolving a scatterer space with a PSF saved as psf_data.mat.


%
% Syntax:  [rf_img, bmode_img, scat_space, coords] = gen_lesion_img(contrast)

%
% Inputs:
%   contrast - Lesion Contrast in dB
% 
% Outputs:
%   rf_img - RF Image (before envelope detection)
%   bmode_img - Envelope detected and log compressed rf_img
%   scat_space - Scatterer space used to create image
%   coords - coordinates of lesion
%
%
% Other m-files required:field_tools repository, field_ii
% repository
% MAT-files required: psf_data.mat

%% Set up 

ax_img = 2/100; % axial range in cm
lat_img = 2/100; % lateral range in cm

% Assumes field_tools repository is in current folder 
addpath(genpath('field_tools'))

load('5MHz_psf_data.mat')

res_area = calcResCellPSF(psf, ax_psf, lat_psf);

ax_spacing = ax_psf(2) - ax_psf(1);
lat_spacing = lat_psf(2) - lat_psf(1);

num_ax_samples = ceil(ax_img / ax_spacing);
num_lat_samples = ceil(lat_img / lat_spacing);

%% Generate Random Scatterer Space
scat_space_sz = [num_ax_samples, num_lat_samples]; 

scat_space = zeros(scat_space_sz);

ax = ((-num_ax_samples/2):((num_ax_samples-1)/2))*ax_spacing + params.focal_depth;
lat = (0:num_lat_samples-1)*lat_spacing;

img_area = ax_img * lat_img;
num_res_cells = img_area / res_area;
nScat = ceil(20*ceil(num_res_cells));

scat_space = scat_space(:);
scat_coords = randi(length(scat_space), nScat, 1); % generate Nscat random indices in scat_space vector  
scat_space(scat_coords)=1; % set those indices = 1, indicating presence of scatterer 
scat_space=reshape(scat_space, scat_space_sz);


[m,n] = size(scat_space);

%% Generate Random Elliptical Lesion Coordinates
X0=randi(m);
Y0=randi(n);

max_size_ax = round((1/100)/ax_spacing/2); % Max size is 1 cm
min_size_ax = round((0.5/100)/ax_spacing/2); % min size is 0.5 cm

max_size_lat = round((1/100)/lat_spacing/2);
min_size_lat = round((0.5/100)/lat_spacing/2);

l=randi([min_size_ax, max_size_ax]);

w=randi([min_size_lat, max_size_lat]);
[X Y] = ndgrid(1:n,1:m); %make a meshgrid: use the size of your image instead
coords = [X0, Y0, l, w];
els = ((X-X0)/l).^2+((Y-Y0)/w).^2<=1; %Your Binary Mask which you multiply to your image, but make sure you change the size of your mesh-grid

%% Add lesion
lesion_magnitude=(10^(contrast/20));


scat_space(els) = scat_space(els).*lesion_magnitude;
size(scat_space);

tmp = conv2(scat_space, psf, 'same');

%% Normalize rf image and create bmode_img
rf_img=tmp/max(tmp(:)); % normalize rf imagedir

bmode_img = db(abs(hilbert(rf_img)));
end

