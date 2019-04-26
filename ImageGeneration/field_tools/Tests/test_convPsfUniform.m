clear 
test_makePSF % get a psf and params structure
ax_psf = ax;
lat_psf = lat;

[rf_img, ax, lat, scat_space] = convPsfUniform(psf, ax_psf, lat_psf, 2/100, 2/100, params);

imagesc(ax, lat, rf_img)
