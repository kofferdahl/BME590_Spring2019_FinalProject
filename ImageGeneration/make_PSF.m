% This script generates a PSF based on the parameters specified below,
% using the field_tools repository and Field_II. This script assumes that
% field_init() has already been called.

params.f0 = 5e6; % Center frequency [Hz]
params.c = 1540; % Speed of sound [m/s]
params.fs = 15e6;
set_sampling(params.fs);
params.lambda = params.c/params.f0; % Wavelength [m]
params.num_cyc = 2;
params.BW = 0.75; % fractional bandwidth
params.num_elem = 192;

params.pitch = params.lambda/2; % element pitch [m]
params.span = 45; % span between -45 and 45 degrees
params.width = params.lambda / (pi*sind(params.span)); % element width for 45 degree angular response
params.kerf = params.pitch - params.width;

params.height = 5/1000; % element height [m]
params.focal_depth = 2/100;
params.focus = [0, 0, params.focal_depth]; % initial electronic focus
params.f_num = params.focal_depth/(params.pitch * params.num_elem);


%%
impulse = makeImpulseResponse(params.BW, params.f0, params.fs);
excitation = makeExcitation(params.num_cyc, params.f0, params.fs);

Tx = makeTransducer(params, impulse, excitation);

[psf, ax_psf, lat_psf] = makePSF(params, Tx, Tx);

save 5MHz_psf_data.mat ax_psf lat_psf psf params

