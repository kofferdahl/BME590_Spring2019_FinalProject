clear
load('params.mat')
N = 10;
phantom_sz = [10, 1, 20]/1000;
z_start = 20/1000;

impulse = makeImpulseResponse(Tx_params.BW, Tx_params.f0, Tx_params.fs);
excitation = makeExcitation(Tx_params.num_cyc, Tx_params.f0, Tx_params.fs);

Tx = makeTransducer(Tx_params, impulse, excitation);
Rx = makeTransducer(Tx_params, impulse, excitation);
[psf, psf_ax, psf_lat] = makePSF(Tx_params, Tx, Tx);
res_area = calcResCellPSF(psf, psf_ax, psf_lat);
N_scat_per_cell = 15;
total_area = phantom_sz(1)*phantom_sz(3);
num_res_cells = round(total_area ./ res_area)
N_scat = num_res_cells * N_scat_per_cell;
[pos, amp] = makeUniformSpecklePhantom(N_scat, phantom_sz, z_start);

%t_pulse_correction = length(conv(conv(excitation,impulse),impulse))/params.fs/2; % correction to center two-way pulse

N_active = 64;
N_elements = Tx_params.num_elem;
no_lines=Tx_params.num_elem-N_active+1; % Number of A-lines in image
%no_lines = 125;
dx=phantom_sz(1)/no_lines; % Increment for image
dx=Tx_params.width; % Increment for image

z_focus=40/1000;
% Pre-allocate some storage
image_data=zeros(1,no_lines);
for i=1:no_lines
    i
    % Find position for imaging
    x=(i-1-no_lines/2)*dx;
    % Set the focus for this direction
    xdc_center_focus (Tx, [x 0 0]);
    xdc_focus (Tx, 0, [x 0 z_focus]);
    xdc_center_focus (Rx, [x 0 0]);
    xdc_focus(Rx, 0, [x, 0, z_focus]);
    % Set the active elements using the apodization
    apo=[zeros(1, i-1) hamming(N_active)' zeros(1, N_elements-N_active-i+1)];
    xdc_apodization (Tx, 0, apo);
    xdc_apodization (Tx, 0, apo);
    % Calculate the received response
    [v, t1]=calc_scat(Tx, Rx, pos, amp);
    % Store the result
    image_data(1:length(v), i) = v;
    times(i) = t1;
end
fs = Tx_params.fs;
c = Tx_params.c;
min_sample=min(times)*Tx_params.fs;
for i=1:no_lines
    rf_env=abs(hilbert([zeros(round(times(i)*fs-min_sample),1); image_data(:,i)]));
    env(1:size(rf_env,1),i)=rf_env;
end
% make logarithmic compression to a 60 dB dynamic range
% with proper units on the axis
env_dB=20*log10(env);
env_dB=env_dB-max(max(env_dB));
env_gray=127*(env_dB+60)/60;
depth=((0:size(env,1)-1)+min_sample)/fs*c/2;
x=((1:no_lines)-no_lines/2)*dx;
image(x*1000, depth*1000, env_gray)
xlabel('Lateral distance [mm]')
ylabel('Depth [mm]')
axis('image')
colormap(gray(128))
title('Image of cyst phantom (60 dB dynamic range)')