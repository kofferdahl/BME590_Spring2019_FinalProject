params.f0 = 8e6; % Center frequency [Hz]
params.c = 1540; % Speed of sound [m/s]
params.fs = 8*params.f0;
params.lambda = params.c/params.f0; % Wavelength [m]

params.BW = 0.5; % fractional bandwidth
params.num_elem = 192;

params.pitch = params.lambda/2; % element pitch [m]
params.span = 45; % span between -45 and 45 degrees
params.width = params.lambda / (pi*sind(params.span)); % element width for 45 degree angular response
params.kerf = params.pitch - params.width;

params.height = 5/1000; % element height [m]
params.focal_depth = 4/100;
params.focus = [0, 0, params.focal_depth]; % initial electronic focus
params.f_num = params.focal_depth / (params.pitch * params.num_elem);

