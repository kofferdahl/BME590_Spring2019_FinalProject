function [positions, amp] = makeUniformSpecklePhantom(N, phantom_sz, z_start)

x_size = phantom_sz(1); % Width of phantom [m]
y_size = phantom_sz(2); % Transverse width of phantom [m]
z_size = phantom_sz(3); % Height of phantom [m]

% Create the general scatterers
x = (rand (N,1)-0.5)*x_size;
y = (rand (N,1)-0.5)*y_size;
z = rand (N,1)*z_size + z_start;
% Generate the amplitudes with a Gaussian distribution
amp=randn(N,1);
positions = [x, y, z];
end

