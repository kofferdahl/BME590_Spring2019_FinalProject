function [impulseResponse,t] = makeImpulseResponse(BW, f0, fs)
%makeImpulseResponse: makes a Gaussian impulse response
% Syntax:  [impulseResponse, t] = makeImpulseResponse(BW, f0, fs)
%
% Fractional bandwidth is defined based on -6 dB point, and the cutoff time 
% for the pulse is determined by the time at which the pulse envelope is 
% below -40 dB.
%
% Inputs:
%    BW: Fractional bandwidth
%    f0: Center frequency
%    fs: Sampling frequency
%
% Outputs:
%    impulseResponse: A vector containing values of impulse response
%    t: Time axis for impulseResponse in seconds 
%
% Example: 
%    [IR, t] = makeImpulseResponse(0.5, 5e6, 40e6)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% Author: Katelyn Offerdahl, modified from BME542 example code 
% Email address: katelyn.offerdahl@duke.edu
% January 2019; Last revision: 24-January-2019

tc = gauspuls('cutoff',f0,BW,-6,-40); % Determine cutoff time 
t = -tc:1/fs:tc;
impulseResponse = gauspuls(t,f0,BW);
end

