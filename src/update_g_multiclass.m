function g_diff = update_g_multiclass(F,F_inv,Ws,lambda,option)
eval('config_file');
[train_frames,test_frames] = do_random_indices(0);

g_diff = 0;
tidx = 1;
for cidx = 1 : size(train_frames,2)
    desc_file = dir([data_path,Categories.Name{cidx},'/*',desc_ext]);
    for lidx = 1:1:length(train_frames{cidx})
        % fprintf('Reading descriptors of image %s ...\n', desc_file(train_frames{cidx}(lidx)).name);
        load([data_path,Categories.Name{cidx},'/',desc_file(train_frames{cidx}(lidx)).name],'h');
        X = h;
        if (option==0)
            load([results_path,Categories.Name{cidx},'/',desc_file(train_frames{cidx}(lidx)).name],'G');
            % G = sum(G);
        else
            load([results_path,Categories.Name{cidx},'/',desc_file(train_frames{cidx}(lidx)).name],'newG');
            G = newG;
        end
        
        offset = zeros(size(X,2),codebook_size);
        for i = 1 : class_num
            if (i==cidx)
                offset = offset+((0.5)*lambda).*(ones(size(X,2),1)*(Ws(:,i))'*F);
            else
                offset = offset-((0.5)*lambda).*(ones(size(X,2),1)*(Ws(:,i))'*F);
            end
        end
        newG = (X'*F+offset)*F_inv;
        % newG = (X'*F+((lambda.*0.5*labels(tidx)).*ones(size(X,2),1))*W')*F_inv;
        % newG = (lambda).*(((1/lambda).*(X'*F)+((0.5*labels(tidx)).*ones(size(X,2),1))*W')*F_inv);
        
        g_diff = g_diff+norm(newG-G,'fro')^2;
        
        save([results_path,Categories.Name{cidx},'/',desc_file(train_frames{cidx}(lidx)).name],'newG','-append'),
        tidx = tidx+1;
    end
end;

return;