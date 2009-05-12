function mf_svm
eval('config_file');
addpath('./svm');

[train_frames,test_frames] = do_random_indices(0);
load(kmeans_codebook_file);
F = K_M';

% svm
[train_label,train_data]=read_sparse(combined_train_datafile);
[test_label,test_data]=read_sparse(combined_test_datafile);
% [c, cv_accracy] = cross_Validation(train_label, train_data, [-20:20], 5);
% model = svmtrain(train_label, train_data, ['-c ',num2str(c),' -t 0 -b 1']);
% svmtrain(train_label, train_data, [' -t 0 -v 5 -b 1']);
% model = svmtrain(train_label, train_data, [' -t 0 -b 1']);
svmtrain(train_label, train_data, [' -t 0 -v 5']);
model = svmtrain(train_label, train_data, [' -t 0']);

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
    % while (con_diff>conv_thres)        
        newF = F;
        % save(new_codebook_file,'newF');
        save(combined_codebook_file,'newF');
        % generate_new_train_test_histogram;
        generate_combined_train_test_histogram(0);
        genearte_svm_data;
        % [test_label,test_data]=read_sparse(new_test_datafile);
        [train_label,train_data]=read_sparse(combined_train_datafile);
        [test_label,test_data]=read_sparse(combined_test_datafile);
%         if (size(test_data,2)<codebook_size)
%             test_data = [test_data,zeros(size(test_data,1),codebook_size-size(test_data,2))];
%         end

        svmtrain(binary_train_label, train_data, [' -t 0 -v 5']);
        model = svmtrain(binary_train_label, train_data, [' -t 0']);
        [predict_label, accuracy, ypred] = svmpredict(binary_train_label, train_data, model);
        [predict_label, accuracy, ypred] = svmpredict(binary_test_label, test_data, model);

        [W,b,eplisons] = calc_margin_constriants(model,train_data,binary_train_label);
    
        if (init_flag>0)
            [recons_obj,margin_obj] = calc_obj(F,W,-binary_train_label,0);
            fprintf('Objective values: %f and %f. Difference between G is %f ...\n',recons_obj,margin_obj,con_diff);
            newF = update_f(W,-binary_train_label,lambda,0);
            % save(new_codebook_file,'newF');
            save(combined_codebook_file,'newF');
            [recons_obj,margin_obj] = calc_obj(newF,W,-binary_train_label,0);
            FF_inv = inv(newF'*newF);
            con_diff = update_g(newF,FF_inv,W,-binary_train_label,lambda,0);
            init_flag = 0;
        else
            newF = update_f(W,-binary_train_label,lambda,1);
            % save(new_codebook_file,'newF');
            save(combined_codebook_file,'newF');
            [recons_obj,margin_obj] = calc_obj(newF,W,-binary_train_label,1);
            FF_inv = inv(newF'*newF);
            con_diff = update_g(newF,FF_inv,W,-binary_train_label,lambda,1);
        end
        [recons_obj,margin_obj] = calc_obj(newF,W,-binary_train_label,1);
        fprintf('Objective values: %f and %f. Difference between G is %f ...\n',recons_obj,margin_obj,con_diff);
        
        eval_classification(newF,model,1);
        
        while (con_diff>conv_thres)
            newF = update_f(W,-binary_train_label,lambda,1);
            [recons_obj,margin_obj] = calc_obj(newF,W,-binary_train_label,1);
            FF_inv = inv(newF'*newF);
            con_diff = update_g(newF,FF_inv,W,-binary_train_label,lambda,1);
            [recons_obj,margin_obj] = calc_obj(newF,W,-binary_train_label,1);
            fprintf('Objective values: %f and %f. Difference between G is %f ...\n',recons_obj,margin_obj,con_diff);
            % save(new_codebook_file,'newF');
            save(combined_codebook_file,'newF');

            eval_classification(newF,model,1);
        end
        
        FF_inv = inv(newF'*newF);
        calc_test_g(newF,FF_inv);
        generate_new_train_test_histogram
        genearte_svm_data

        [train_label,train_data]=read_sparse(new_train_datafile);
        [test_label,test_data]=read_sparse(new_test_datafile);
        
        K = train_data*train_data';
        new_train_data = [[1:size(train_data,1)]',K];
        % [predict_label, accuracy, ypred] = svmpredict(binary_train_label, new_train_data, model, [' -b 1']);
        [predict_label, accuracy, ypred] = svmpredict(binary_train_label, train_data, model);
        
        svm_train_test;
    % end

    save(new_codebook_file,'newF');
    % load(new_codebook_file,'newF');
    
    FF_inv = inv(newF'*newF);
    calc_test_g(newF,FF_inv);
    
    
    test_label1 = (-1).*ones(length(test_label),1);
    test_label1(find(test_label==i)) = 1;
    [predict_label, accuracy, ypred] = svmpredict(test_label1, test_data, model, '-b 1');
end


