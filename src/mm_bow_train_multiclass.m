function mm_bow_train_multiclass
eval('config_file');

[train_frames,test_frames] = do_random_indices(0);
load(kmeans_codebook_file);
F = K_M';

% svm
[train_label,train_data]=read_sparse(kmeans_train_datafile);
[test_label,test_data]=read_sparse(kmeans_test_datafile);
% [c, cv_accracy] = cross_Validation(train_label, train_data, [-20:20], 5);
% model = svmtrain(train_label, train_data, ['-c ',num2str(c),' -t 0 -b 1']);
% svmtrain(train_label, train_data, [' -t 0 -v 5 -b 1']);
% model = svmtrain(train_label, train_data, [' -t 0 -b 1']);
svmtrain(train_label, train_data, [' -t 0 -v 5']);
model = svmtrain(train_label, train_data, [' -t 0']);

Ws = zeros(feature_dim,class_num);
Bs = zeros(class_num,1);
for i = 1 : max(train_label)
    binary_train_label = (-1).*ones(length(train_label),1);
    binary_train_label(find(train_label==i)) = 1;
    binary_test_label = (-1).*ones(length(test_label),1);
    binary_test_label(find(test_label==i)) = 1;
    
    if (i==1)
        binary_train_label = -binary_train_label;
        binary_test_label = -binary_test_label;
    end
    
    con_diff = inf; init_flag = 1;
    newF = F;
    % save(new_codebook_file,'newF');
    save(combined_multiclass_codebook_file,'newF');
    % generate_new_train_test_histogram;
    generate_combined_train_test_histogram(2,0);
    genearte_svm_data(3);
    [train_label,train_data]=read_sparse(combined_train_datafile);
    [test_label,test_data]=read_sparse(combined_test_datafile);
    
    svmtrain(binary_train_label, train_data, [' -w1 9 -w-1 1 -t 0 -v 5']);
    model = svmtrain(binary_train_label, train_data, [' -w1 9 -w-1 1 -t 0']);
    [predict_label, accuracy, ypred] = svmpredict(binary_train_label, train_data, model);
    [predict_label, accuracy, ypred] = svmpredict(binary_test_label, test_data, model);

    [W,b,eplisons] = calc_margin_constriants(model,train_data,binary_train_label);
    
    Ws(:,i) = W; Bs(i) = b;
end
    
con_diff = inf; init_flag = 1;

if (init_flag>0)
    [recons_obj,margin_obj] = calc_obj_multiclass(F,Ws,0);
    fprintf('Objective values: %f and %f. Difference between G is %f ...\n',recons_obj,margin_obj,con_diff);
    newF = update_f_multiclass(Ws,lambda,0);
    save(combined_multiclass_codebook_file,'newF');
    [recons_obj,margin_obj] = calc_obj_multiclass(newF,Ws,0);
    FF_inv = inv(newF'*newF);
    con_diff = update_g_multiclass(newF,FF_inv,Ws,lambda,0);
    init_flag = 0;
else
    newF = update_f_multiclass(Ws,lambda,1);
    save(combined_multiclass_codebook_file,'newF');
    [recons_obj,margin_obj] = calc_obj_multiclass(newF,Ws,1);
    FF_inv = inv(newF'*newF);
    con_diff = update_g_multiclass(newF,FF_inv,Ws,lambda,1);
end

[recons_obj,margin_obj] = calc_obj_multiclass(newF,Ws,1);
fprintf('Objective values: %f and %f. Difference between G is %f ...\n',recons_obj,margin_obj,con_diff);
save(combined_multiclass_codebook_file,'newF');
evaluate_multiclass_classification;
        
while (con_diff>conv_thres)
    newF = update_f_multiclass(Ws,lambda,1);
    [recons_obj,margin_obj] = calc_obj_multiclass(newF,Ws,1);
    FF_inv = inv(newF'*newF);
    con_diff = update_g_multiclass(newF,FF_inv,Ws,lambda,1);
    [recons_obj,margin_obj] = calc_obj_multiclass(newF,Ws,1);
    fprintf('Objective values: %f and %f. Difference between G is %f ...\n',recons_obj,margin_obj,con_diff);
    % save(new_codebook_file,'newF');
    save(combined_multiclass_codebook_file,'newF');

    evaluate_multiclass_classification;
end
