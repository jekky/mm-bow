function eval_classification(newF,model,pos_class)
eval('config_file');

FF_inv = inv(newF'*newF);
calc_test_g(newF,FF_inv);
% generate_new_train_test_histogram
generate_combined_train_test_histogram(1,1);
genearte_svm_data(2);

[train_label,train_data]=read_sparse(combined_train_datafile);
[test_label,test_data]=read_sparse(combined_test_datafile);

binary_train_label = (-1).*ones(length(train_label),1);
binary_train_label(find(train_label==pos_class)) = 1;
binary_test_label = (-1).*ones(length(test_label),1);
binary_test_label(find(test_label==pos_class)) = 1;

if (pos_class==1)
    binary_train_label = -binary_train_label;
    binary_test_label = -binary_test_label;
end

svmtrain(binary_train_label, train_data, [' -w1 9 -w-1 1 -t 0 -v 5']);
[predict_label, accuracy, ypred] = svmpredict(binary_train_label, train_data, model);
[predict_label, accuracy, ypred] = svmpredict(binary_test_label, test_data, model);

model = svm_train_test(2,pos_class);