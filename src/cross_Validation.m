function [cv_C, fMax] = cross_Validation(train_label, train_data, vC, nFold) 
%%%%%%%%%%%

N_TOP   =  inf; 

[m, n] = size(train_data);
[samples] = v_fold(nFold, train_label);

score = [];

    for i = vC;
        cc = 2^(i);
        
        acc = zeros(nFold, 1);
        
        for vv=1:nFold

            test_label_idx = train_label(samples{vv}.test_idx,1);
            test_data_idx  = train_data(samples{vv}.test_idx,:);   %the index of 0.2 part
            train_label_idx = train_label(samples{vv}.train_idx,1);
            train_data_idx = train_data(samples{vv}.train_idx,:); %the index of 0.8 part
                        
            cls = svmtrain(train_label_idx,train_data_idx, ['-t 0 -c ',num2str(cc)]);
            [predict_label, accuracy, dec_values] = svmpredict(test_label_idx, test_data_idx, cls);
            acc(vv) = accuracy(1);
        end;
        
        score = [score; mean(acc)];
        fprintf('C: %f --Accuracy:  %f\n',cc,mean(acc));
    end;


[fMax,anIndex] =  max(score);
cv_C = 2^(anIndex);

fprintf('Final Choice: C: %f \n',cv_C);

return;



function [samples] = v_fold(v, train_label)
eval('config_file');

try
    load(cv_file,'class_sample');
catch
    class_sample = [];
    for i = 1:max(train_label)
        cidx = find(train_label==i);
        sidx = randperm(length(cidx));
        class_sample = [class_sample;(cidx(sidx))'];
    end
    save(cv_file,'class_sample');
end
runs = floor(length(train_label)/max(train_label)/v);
folds = {};

for j=1:v
    folds{j} = class_sample(:,((j-1)*runs +1):j*runs);
end;

samples = {};
for i=1:v
    
    vidx = reshape(folds{i},[size(folds{i},1)*size(folds{i},2),1]);
    tidx = setdiff([1:length(train_label)], vidx);
    
    samples{i}.test_idx  =  vidx; %0.2 part
    samples{i}.train_idx =  tidx; %0.8 part
    
end;

return;