function mm_bow_test_kmeans_binary_vote
eval('config_file');

[train_frames,test_frames] = do_random_indices(0);

[train_label,train_data]=read_sparse(kmeans_train_datafile);
[test_label,test_data]=read_sparse(kmeans_test_datafile);

%% direct use libsvm for multiclass classification
svmtrain(train_label, train_data, [' -t 0 -v 5']);
model = svmtrain(train_label, train_data, [' -t 0']);
[predict_label, accuracy, ypred] = svmpredict(test_label, test_data, model);

test_inst_num = 0;
test_label = [];
for cidx = 1 : size(test_frames,2)
    test_inst_num = test_inst_num+length(test_frames{cidx});
    test_label = [test_label;cidx.*ones(length(test_frames{cidx}),1)];
end
dec_values = zeros(test_inst_num,class_num);
for i = 1 : class_num
    binary_train_label = (-1).*ones(length(train_label),1);
    binary_train_label(find(train_label==i)) = 1;
    binary_test_label = (-1).*ones(length(test_label),1);
    binary_test_label(find(test_label==i)) = 1;

    if (i==1)
        binary_train_label = -binary_train_label;
        binary_test_label = -binary_test_label;
    end
    
    svmtrain(binary_train_label, train_data, [' -t 0 -v 5']);
    model = svmtrain(binary_train_label, train_data, [' -t 0']);
    [predict_label, accuracy, ypred] = svmpredict(binary_train_label, train_data, model);
    [predict_label, accuracy, ypred] = svmpredict(binary_test_label, test_data, model);
        
    if (i==1)
        predict_label = -predict_label;
        ypred = -ypred;
    end    
    dec_values(:,i) = ypred;    
end

test_votes = zeros(test_inst_num,class_num);
for i = 1 : class_num
    for j = 1 : class_num
        if (i~=j)
            test_votes(:,i) = test_votes(:,i)+exp(-dec_values(:,j));
        else
            test_votes(:,i) = test_votes(:,i)+exp(+dec_values(:,j));
        end
    end
end

[min_ypred,predict_label] = min(test_votes,[],2);
accuracy = sum((predict_label-test_label)==0)/test_inst_num;
fprintf('Classification accuracy is %f%% ...\n',accuracy*100);
