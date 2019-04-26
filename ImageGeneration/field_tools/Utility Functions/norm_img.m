function [n_img] = norm_img(img)
%norm_img(img) normalizes the values of the matrix img to be between 0 and
%1.

n_img = img - min(img(:));
n_img = n_img ./ max(n_img(:));
end

