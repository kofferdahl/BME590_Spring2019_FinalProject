function [ccmu, ccsd] = slscBF(indat,maxlag,type,fisher)
% ccmu = slscBF(indat,[],'fast',0)
% 
% non-kernel slsc beamformer
% 
% INPUTS
% indat - input focused IQ data [sample x channel x firing]
% maxlag - maximum lag value for cc calculation
% type - method used to calculate cc
%     'fast' - conventional averaging between element pairs of equal lag
%     'ensemble' - single cc for all element pairs of equal lag
%     'angle' - conventional method using phase calculation
% 
% OUTPUTS
% cc - correlation values for each lag

% * current implementation is for 1d only
% author: will long 6/3/16


if nargin<4
    fisher = 0;
end
if nargin<3
    type = 'fast';
end
if nargin<2
    maxlag = [];
end
if isempty(maxlag)
    maxlag = size(indat,2)-1;
end

if isreal(indat)
    iq = hilbert(indat(:,:));
    iq = reshape(iq, size(indat));
else
    iq = indat;
end
clear indat

ccmu = zeros(size(iq,1),maxlag,size(iq,3));
ccsd = zeros(size(ccmu));
switch type
    case 'fast'
        normiq(:,:,:,1) = real(iq)./abs(iq);
        normiq(:,:,:,2) = imag(iq)./abs(iq);
        normiq(isnan(normiq)) = 1; % for expressions where normiq = 0/0
        for lag = 1:maxlag
            normiqshift = circshift(normiq,[0 lag 0 0]);
            cc_raw = dot(normiq,normiqshift,4);
            ccmu(:,lag,:) = mean(cc_raw(:,1+lag:end,:),2);
            ccsd(:,lag,:) = std(cc_raw(:,1+lag:end,:),0,2);
        end
    case 'ensemble'
        complexiq(:,:,:,1) = real(iq);
        complexiq(:,:,:,2) = imag(iq);
        magiq = abs(iq).^2;
        for lag = 1:maxlag
            complexiqshift = circshift(complexiq,[0 lag 0 0]);
            magiqshift = circshift(magiq,[0 lag 0]);
            complexiqshift = complexiqshift(:,1+lag:end,:,:);
            magiqshift = magiqshift(:,1+lag:end,:);
            complexiqfix = complexiq(:,1+lag:end,:,:);
            magiqfix = magiq(:,1+lag:end,:);
            cc_raw = dot(complexiqfix,complexiqshift,4);
            ccmu(:,lag,:) = squeeze(sum(cc_raw,2))./squeeze(sqrt(sum(magiqfix,2).*sum(magiqshift,2)));
        end 
    case 'angle'
        normiq = iq./abs(iq);
        normiq(isnan(normiq)) = 1;
        for lag = 1:maxlag
            normiqshift = circshift(normiq,[0 lag 0]);
            normiqshift = normiqshift(:,1+lag:end,:);
            normiqfix = normiq(:,1+lag:end,:);
            cc_raw = cos(angle(normiqfix)-angle(normiqshift));
            ccmu(:,lag,:) = mean(cc_raw,2);
            ccsd(:,lag,:) = std(cc_raw,0,2);
        end
end

if fisher
    ccmu = atanh(ccmu);
end
