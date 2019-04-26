function [excitation, t] = makeExcitation(numCyc, f0,fs)
%makeExcitation: makes a sinsoidal excitation signal
%
% Syntax:  [excitation, t] = makeExcitation(numCyc, f0, fs)
%
% Inputs:
%    numCyc: number of cycles in pulse
%    f0: Center frequency
%    fs: Sampling frequency
%
% Outputs:
%    excitation: A vector containing values of excitation signal
%    t: Time axis for excitation in seconds 
%
% Example: 
%    [excitation, t] = makeExcitation(2, 5e6, 40e6)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% Author: Katelyn Offerdahl
% Email address: katelyn.offerdahl@duke.edu
% January 2019; Last revision: 24-January-2019

T = 1/fs; % sampling period
t = 0:T:(numCyc/f0);
excitation = sin(2*pi*f0*t);

end

