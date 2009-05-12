function generate_new_train_test_histogram

%% Load config file
eval('config_file');

%% Generate visual token for every image according to codebook
load(new_codebook_file);

%% Generate sampling indices for both training and testing
[train_frames,test_frames] = do_random_indices(0);

%% generate training data
fprintf('--------------------------------------------------------\n');
fprintf('Generate bag-of-features histogram for train data ...\n');
train_data = [];
cur_idx = 1;
for cidx = 1 : size(train_frames,2)
    desc_file = dir([results_path,Categories.Name{cidx},'/*',desc_ext]);
    for lidx = 1:1:length(train_frames{cidx})
        fprintf('Reading descriptors of image %s ...\n', desc_file(train_frames{cidx}(lidx)).name);
        load([data_path,Categories.Name{cidx},'/',desc_file(train_frames{cidx}(lidx)).name],'h');
        desc = h';
        sampled_desc = desc(1:1:end,:);

        dist_array = [];
        for kidx = 1 : codebook_size
            dist_array = [dist_array,sqrt(sum((sampled_desc-repmat(newF(:,kidx)',[size(sampled_desc,1),1])).^2,2))];
        end
        
        [min_dist, token] = min(dist_array,[],2);        
        G =zeros(size(sampled_desc,1),size(newF,2));
        tidx = sub2ind(size(G),[1:size(sampled_desc,1)]',token);
        G(tidx) = 1;
        % save([results_path,Categories.Name{cidx},'/',desc_file(train_frames{cidx}(lidx)).name],'G','-append');
        
        data = sum(G);
        % data = sum(sampled_desc);
        train_data = [train_data;data];
        
        % fprintf('Reading descriptors of image %s ...\n', desc_file(train_frames{cidx}(lidx)).name);
        % load([results_path,Categories.Name{cidx},'/',desc_file(train_frames{cidx}(lidx)).name],'newG');
        
        % data = sum(newG);
        % train_data = [train_data;data];
    end
end
disp('finished generating train data ...\n');
save(new_train_histogram_file,'train_data');

fprintf('--------------------------------------------------------\n');
fprintf('Generate bag-of-features histogram for test data ...\n');
test_data = [];
for cidx = 1 : size(test_frames,2)
    desc_file = dir([results_path,Categories.Name{cidx},'/*',desc_ext]);
    for lidx = 1:length(test_frames{cidx})
        fprintf('Reading descriptors of image %s ...\n', desc_file(test_frames{cidx}(lidx)).name);
        load([data_path,Categories.Name{cidx},'/',desc_file(test_frames{cidx}(lidx)).name],'h');
        desc = h';
        sampled_desc = desc(1:1:end,:);

        dist_array = [];
        for kidx = 1 : codebook_size
            dist_array = [dist_array,sqrt(sum((sampled_desc-repmat(newF(:,kidx)',[size(sampled_desc,1),1])).^2,2))];
        end
        
        [min_dist, token] = min(dist_array,[],2);        
        G =zeros(size(sampled_desc,1),size(newF,2));
        tidx = sub2ind(size(G),[1:size(sampled_desc,1)]',token);
        G(tidx) = 1;
        % save([results_path,Categories.Name{cidx},'/',desc_file(test_frames{cidx}(lidx)).name],'G','-append');
        
        data = sum(G);
        % data = sum(sampled_desc);
        test_data = [test_data;data];
        
        % fprintf('Reading descriptors of image %s ...\n', desc_file(test_frames{cidx}(lidx)).name);
        % load([results_path,Categories.Name{cidx},'/',desc_file(test_frames{cidx}(lidx)).name],'newG');
        
        % data = sum(newG);
        % test_data = [test_data;data];
    end
end

disp('finished generating test data ...\n');
save(new_test_histogram_file,'test_data');