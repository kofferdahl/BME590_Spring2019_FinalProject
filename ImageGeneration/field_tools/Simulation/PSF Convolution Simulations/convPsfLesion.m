function [rf_img, ax, lat, scat_space] = ...
    convPsfLesion(psf, ax_psf, lat_psf, ax_img, lat_img, ax_loc, lat_loc, contrast, radius, params)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
res_area = calcResCellPSF(psf, ax_psf, lat_psf);

ax_spacing = ax_psf(2) - ax_psf(1);
lat_spacing = lat_psf(2) - lat_psf(1);

num_ax_samples = ceil(ax_img / ax_spacing);
num_lat_samples = ceil(lat_img / lat_spacing);
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


%%
% now add in a lesion of specified dimensions, and contrast
% this will scale any point targets within the lesion
% so their contrast is compared to their background
lesionmagnitude=(10^(lesioncontrast/20));
% find region w/in diameter of lesion center and scale
%find center of image in samples, axially and laterally
axcent=floor(length(aximg)/2);
latcent=floor(length(latimg)/2);

axcent = ax_loc
latcent = lat_loc

diamsamples=floor((lesiondiameter)/latspacing);
if diamsamples> length(aximg) 
	display('lesion too big!'); 
	exit;
end
for i=axcent-floor(diamsamples/2):axcent+ceil(diamsamples/2)
 for j=latcent-floor(diamsamples/2):latcent+ceil(diamsamples/2)
  if (sqrt((latimg(j)-latimg(latcent))^2+(aximg(i)-aximg(axcent))^2)<=lesiondiameter/2)
        scattererspace(i,j)=scattererspace(i,j)*lesionmagnitude;
  end
 end
end

%%

% convolve scatterers w/psf by mx in freq. domain
scat_space_fft = fft2(scat_space);
psf_fft = fft2(psf, num_ax_samples, num_lat_samples);
c = scat_space_fft .* psf_fft;
tmp=ifft2(c);

% drop the first and last size(psf/2) samples and the lat as well
lat_crop_inx=floor(size(psf,2));
ax_crop_inx=floor(size(psf,1)/2);
rf_img=tmp(ax_crop_inx:end-ax_crop_inx,lat_crop_inx:end);

rf_img=rf_img/max(rf_img(:)); % normalize rf image
scat_space = scat_space(ax_crop_inx:end-ax_crop_inx,lat_crop_inx:end);
ax=ax(ax_crop_inx:end-ax_crop_inx);
lat=lat(lat_crop_inx:end);
end

