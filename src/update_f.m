function newF = update_f(W,labels,lambda,option)
eval('config_file');
[train_frames,test_frames] = do_random_indices(0);

A = zeros(feature_dim,codebook_size);
B = zeros(codebook_size,codebook_size);
offset = zeros(feature_dim,codebook_size);
tidx = 1;
for cidx = 1 : size(train_frames,2)
    desc_file = dir([data_path,Categories.Name{cidx},'/*',desc_ext]);
    for lidx = 1:1:length(train_frames{cidx})
        % fprintf('Reading descriptors of image %s ...\n', desc_file(train_frames{cidx}(lidx)).name);
        load([data_path,Categories.Name{cidx},'/',desc_file(train_frames{cidx}(lidx)).name],'h');
        X = h';
        if (option==0)
            load([results_path,Categories.Name{cidx},'/',desc_file(train_frames{cidx}(lidx)).name],'G');
            % A = A+(sum(X))'*(sum(G)); B = B+(sum(G))'*(sum(G));
            A = A+X'*G; B = B+G'*G;
            offset = offset+((0.5)*lambda*labels(tidx)).*(W*ones(1,size(G,1))*G);
        else
            load([results_path,Categories.Name{cidx},'/',desc_file(train_frames{cidx}(lidx)).name],'newG');
            % A = A+(sum(X))'*(newG)'; B = B+newG*newG';
            A = A+X'*newG; B = B+newG'*newG;
            offset = offset+((0.5)*lambda*labels(tidx)).*(W*ones(1,size(newG,1))*newG);
        end
        tidx = tidx+1;
    end
end;
% newF = A*inv(B);
newF = (A+offset)*inv(B);
return;