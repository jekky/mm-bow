function model = svm_train_test_multiclass

%% Load config file
eval('config_file');
addpath('./svm');

[train_frames,test_frames] = do_random_indices(0);
%% Solution 1: calculate kernel matrix inside
% [train_label,train_data]=read_sparse(kmeans_train_datafile);
% [test_label,test_data]=read_sparse(kmeans_test_datafile);
% [train_label,train_data]=read_sparse(new_train_datafile);
% [test_label,test_data]=read_sparse(new_test_datafile);
[train_label,train_data]=read_sparse(combined_train_datafile);
[test_label,test_data]=read_sparse(combined_test_datafile);

% pos_class = 1;

binary_train_label = (-1).*ones(length(train_label),1);
binary_train_label(find(train_label==pos_class)) = 1;
binary_test_label = (-1).*ones(length(test_label),1);
binary_test_label(find(test_label==pos_class)) = 1;

if (pos_class==1)
    binary_train_label = -binary_train_label;
    binary_test_label = -binary_test_label;
end
    
% [c, cv_accracy] = cross_Validation(binary_train_label, train_data, [-20:20], 5);
% svmtrain(binary_train_label, train_data, [' -t 0 -v 5 -b 1']);
% model = svmtrain(binary_train_label, train_data, [' -t 0 -b 1']);
% [predict_label, accuracy, ypred] = svmpredict(binary_train_label,
% train_data, model, '-b 1');
% [predict_label, accuracy, ypred] = svmpredict(binary_test_label, test_data, model, '-b 1');
svmtrain(binary_train_label, train_data, [' -t 0 -v 5']);
model = svmtrain(binary_train_label, train_data, [' -t 0']);
[predict_label, accuracy, ypred] = svmpredict(binary_train_label, train_data, model);
[predict_label, accuracy, ypred] = svmpredict(binary_test_label, test_data, model);

[B IX] = max(ypred,[],2);    
start = 0;
mat = [];
for i = 1:Categories.Number
    h = hist(IX(start+1:start+length(test_frames{i})),1:Categories.Number);
    mat = [mat;h];
    start = start+length(test_frames{i});
end

return;