function mm_bow_test

eval('config_file');

[train_frames,test_frames] = do_random_indices(0);

test_inst_num = 0;
test_label = [];
for cidx = 1 : size(test_frames,2)
    test_inst_num = test_inst_num+length(test_frames{cidx});
    test_label = [test_label;cidx.*ones(length(test_frames{cidx}),1)];
end
test_votes = zeros(test_inst_num,class_num); dec_values = zeros(test_inst_num,class_num);
for i = 1 : class_num
    load([results_path,num2str(i),'-classifier.mat'],'newF','model');
    FF_inv = inv(newF'*newF);
    calc_test_g(newF,FF_inv);
    generate_combined_train_test_histogram(1,1);
    genearte_svm_data(2);
    
    [test_label,test_data]=read_sparse(combined_test_datafile);
    
    binary_test_label = (-1).*ones(length(test_label),1);
    binary_test_label(find(test_label==i)) = 1;

    if (i==1)
        binary_test_label = -binary_test_label;
    end
    [predict_label, accuracy, ypred] = svmpredict(binary_test_label, test_data, model);    
    
    if (i==1)
        predict_label = -predict_label;
        ypred = -ypred;
    end    
    dec_values(:,i) = ypred;
    
    pos_vote = zeros(1,class_num); pos_vote(i) = 1;
    neg_vote = ones(1,class_num); neg_vote(i) = 0;
    pos_idx = find(predict_label>0);
    neg_idx = find(predict_label<0);
    test_votes(pos_idx,:) = test_votes(pos_idx,:)+repmat(pos_vote,[length(pos_idx),1]);
    % test_votes(neg_idx,:) = test_votes(neg_idx,:)+repmat(neg_vote,[length(neg_idx),1]);
end

% [max_votes,predict_label] = max(test_votes,[],2);
% [min_ypred,predict_label] = min(dec_values,[],2);

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