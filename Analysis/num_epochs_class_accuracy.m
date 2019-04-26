% This script creates a plot of the number of epochs required to achieve
% perfect classification accuracy.

frequencies = {'1MHz','3MHz', '5MHz'};
freq = [1, 3, 5];
contrasts = {'6dB', '9dB', '12dB'};
cont = [-6, -9, -12];
%cont = [-12, -9, -6]
num_epochs = zeros(3,3)

for i = 1:length(frequencies)
    for j = 1:length(contrasts)
        f = frequencies{i};
        c = contrasts{j};
        
        file_name = [f, '_', c, '.mat']
        load(file_name)
        num_epochs(i, j) = find(val_acc==1, 1, 'first')
        
    end
end
epochs = 1:30;
dims = datacontainer.datadims({cont,freq}, {'Contrast', 'Frequency'}, {'dB','MHz'})
epochs_obj = datacontainer(num_epochs', dims, 'Epochs')
epochs_obj.plot('LineWidth', 3, 'LineStyle', '-.', 'MarkerSize', 10, 'Marker', '*')
ax = gca;
set(ax, 'FontSize', 15)
ax.Legend.Location = 'northeast';
grid on
%title('Epochs for 100\% Classification Accuracy')
set(gca, 'XDir', 'reverse')