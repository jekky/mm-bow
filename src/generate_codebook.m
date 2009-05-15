function generate_codebook
%%
eval('config_file');
[train_frames,test_frames] = do_random_indices(1);

%% Generate visual codebook using k-means clustering 
% descriptor reading
desc_data = [];
for cidx = 1 : size(train_frames,2)
    desc_file = dir([data_path,Categories.Name{cidx},'/*',desc_ext]);
    for lidx = 1:10:length(train_frames{cidx})
        fprintf('Reading descriptors of image %s ...\n', desc_file(train_frames{cidx}(lidx)).name);
        load([data_path,Categories.Name{cidx},'/',desc_file(train_frames{cidx}(lidx)).name],'h');
        desc_data=[desc_data;h'];
    end
end;


%% k-means clustering
fprintf('Applying k-means clustering on descriptors ...\n');
[IDX,K_M] = kmeans(desc_data, codebook_size);
save(kmeans_codebook_file,'K_M');