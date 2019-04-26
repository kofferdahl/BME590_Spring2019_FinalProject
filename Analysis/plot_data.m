% This script plots the validation accuracy as a function of the number of
% epochs for each resolution and contrast case.
clear
load('val_acc_obj.mat')
select_contrasts = val_acc.slicex('Contrast', [-12 -3])
contrasts = [-3, -6, -9, -12];


for i = 1:4
    subplot(1, 4, i)
    val_acc.slicex('Contrast', contrasts(i)).plot('LineWidth', 3)
    ylim([0.3 1])
    set(gca, 'FontSize', 17)
    title([num2str(contrasts(i)), '  dB'])
    if i>1
        legend('off')
    end
    grid on
end
