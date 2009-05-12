function genearte_svm_data()

%% Generate training data and test data
eval('config_file');
load(kmeans_codebook_file);

% fid_train = fopen(kmeans_train_datafile,'w');
% fid_test = fopen(kmeans_test_datafile,'w');
% fid_train = fopen(new_train_datafile,'w');
% fid_test = fopen(new_test_datafile,'w');
fid_train = fopen(combined_train_datafile,'w');
fid_test = fopen(combined_test_datafile,'w');

%% Generate sampling indices for both training and testing
[train_frames,test_frames] = do_random_indices(0);


%% generate training data
% load(kmeans_train_histogram_file);
% load(new_train_histogram_file);
load(combined_train_histogram_file);

cur_idx = 1;
for cidx = 1 : size(train_frames,2)
    for lidx = 1:length(train_frames{cidx})
        fprintf(fid_train, num2str(cidx));        
        data = reshape (train_data(cur_idx,:), 1, []);
        idx = find(data > 0);
        for i =  1: length(idx)
            fprintf(fid_train, ' %d:%d', idx(i), data(idx(i)));
        end;
        fprintf(fid_train, '\n');
        cur_idx = cur_idx+1;
    end
end
fclose(fid_train);

%% generate test data
% load(kmeans_test_histogram_file);
% load(new_test_histogram_file);
load(combined_test_histogram_file);

cur_idx = 1;
for cidx = 1 : size(test_frames,2)
    for lidx = 1 : length(test_frames{cidx})
        fprintf(fid_test, num2str(cidx));

        data = reshape (test_data(cur_idx,:), 1, []);
        idx = find(data > 0);
        for i =  1: length(idx)
            fprintf(fid_test, ' %d:%d', idx(i), data(idx(i)));
        end;
        fprintf(fid_test, '\n');
        cur_idx = cur_idx+1;        
    end
end
fclose(fid_test);