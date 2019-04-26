function [vcz_curve] = make_vcz(ccmu)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[m, n, p] = size(ccmu);
vcz = sum(ccmu,1) / m;
vcz = sum(vcz, 3) / p;
vcz_curve = squeeze(vcz);

end

