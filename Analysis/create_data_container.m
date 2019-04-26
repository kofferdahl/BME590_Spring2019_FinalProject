% This script creates a data container for plotting purposes.
% This script assumes that the data is saved in the format XMHz_YdB.mat for
% the various frequencies and lesion contrasts. It depends on the ooMat
% repository by Peter Hollender, which can be found at:
% https://gitlab.oit.duke.edu/ultrasound/ooMat

frequencies = {'1MHz', '3MHz', '5MHz'};
freq = [1, 3, 5];
contrasts = {'0dB', '3dB', '6dB', '9dB', '12dB'};
cont = [0, -3, -6, -9, -12];

for i = 1:length(frequencies)
    for j = 1:length(contrasts)
        f = frequencies{i};
        c = contrasts{j};
        
        file_name = [f, '_', c, '.mat']
        load(file_name)
        v_acc_mat(:, i, j) = val_acc;
        v_loss_mat(:, i, j) = val_loss;
        t_acc_mat(:, i, j) = train_acc;
        t_loss_mat(:, i, j)  = train_loss;
        
        
    end
end
epochs = 1:30;
dims = datacontainer.datadims({epochs,freq, cont}, {'Epoch', 'Frequency', 'Contrast'}, {'','MHz', 'dB'})
val_acc = datacontainer(v_acc_mat, dims, 'Validation Accuracy')
val_loss = datacontainer(v_loss_mat, dims, '')
train_acc = datacontainer(t_acc_mat, dims, '')
train_loss = datacontainer(t_acc_mat, dims, '')
save('val_acc_obj.mat', 'val_acc')
val_acc.plot('LineWidth', 2)