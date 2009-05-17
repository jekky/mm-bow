function [W,model] = estimate_model(binary_train_label,binary_test_label,type,option)
eval('config_file');

% generate_new_train_test_histogram;
generate_combined_train_test_histogram(type,option);
genearte_svm_data(type+1);
[train_label,train_data]=read_sparse(combined_train_datafile);
[test_label,test_data]=read_sparse(combined_test_datafile);

svmtrain(binary_train_label, train_data, [' -w1 9 -w-1 1 -t 0 -v 5']);
model = svmtrain(binary_train_label, train_data, [' -w1 9 -w-1 1 -t 0']);
[predict_label, accuracy, ypred] = svmpredict(binary_train_label, train_data, model);
[predict_label, accuracy, ypred] = svmpredict(binary_test_label, test_data, model);

[W,b,eplisons] = calc_margin_constriants(model,train_data,binary_train_label);