function [] = gen_images(set_num, batch_size, lesion_condition, contrast, frequency)
%GEN_IMAGES - Makes sets of bmode images using gen_lesion_img 
% This function is designed to be called by gen_images.sh to generate sets
% of images with a given batch size in parallel on the DCC. This code
% assumes that field_init() has already been called from Field_II, and that
% there is a file with the psf_data.mat used in gen_lesion_img.

%
% Syntax:  [] = gen_images(set_num, batch_size, lesion_condition, contrast, frequency)
%
% Inputs:
%    set_num - Set number (for file naming purposes)
%    batch_size - Number of images in a set
%    lesion_condition - Boolean specifying presence/absence of lesion
%    contrast - Lesion contrast in dB
%    frequency - Frequency in MHz
% 
% Outputs:
%    None
%

%
% Other m-files required: gen_lesion_img, field_tools repository, field_ii
% repository
% MAT-files required: psf_data.mat for gen_lesion_img

for i = 1:batch_size
    i
    if lesion_condition
        [rf_tmp, bmode_tmp, scat_space_tmp, coords_tmp] = gen_lesion_img(contrast);
    else
        [rf_tmp, bmode_tmp, scat_space_tmp, coords_tmp] = gen_lesion_img(0);
    end
    
    rf_img(:, :, i) = rf_tmp;
    bmode_img(:, :, i) = bmode_tmp;
    scat_space(:, :, i) = scat_space_tmp;
    coords(:, :, i) = coords_tmp;
    
end

if lesion_condition
    
    save([num2str(frequency),'MHz/',num2str(abs(contrast)), 'dB/Lesion_Images/set_', num2str(set_num), '_lesion_rf.mat'], 'rf_img', '-v7.3', '-nocompression')
    save([num2str(frequency),'MHz/',num2str(abs(contrast)), 'dB/Lesion_Images/set_', num2str(set_num), '_lesion_bmode.mat'], 'bmode_img', '-v7.3', '-nocompression')
    save([num2str(frequency),'MHz/',num2str(abs(contrast)), 'dB/Lesion_Images/set_', num2str(set_num), '_lesion_scat.mat'], 'scat_space', '-v7.3', '-nocompression')
    save([num2str(frequency),'MHz/',num2str(abs(contrast)), 'dB/Lesion_Images/set_', num2str(set_num), '_lesion_coords.mat'], 'coords', '-v7.3', '-nocompression')
else
        
    save([num2str(frequency),'MHz/','Uniform_Images/set_', num2str(set_num), '_uniform_rf.mat'], 'rf_img', '-v7.3', '-nocompression')
    save([num2str(frequency),'MHz/','Uniform_Images/set_', num2str(set_num), '_uniform_bmode.mat'], 'bmode_img', '-v7.3', '-nocompression')
    save([num2str(frequency),'MHz/','Uniform_Images/set_', num2str(set_num), '_uniform_scat.mat'], 'scat_space', '-v7.3', '-nocompression')
    %save(['set_', num2str(set_num), '_uniform_coords.mat'], 'coords')
end

end

