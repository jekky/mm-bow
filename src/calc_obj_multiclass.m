function [recons_val,margin_val] = calc_obj_multiclass(F,W,option)
eval('config_file');
[train_frames,test_frames] = do_random_indices(0);

tidx = 1;
recons_val = 0; margin_val = 0;
for cidx = 1 : size(train_frames,2)
    desc_file = dir([data_path,Categories.Name{cidx},'/*',desc_ext]);
    for lidx = 1:1:length(train_frames{cidx})
        % fprintf('Reading descriptors of image %s ...\n', desc_file(train_frames{cidx}(lidx)).name);
        load([data_path,Categories.Name{cidx},'/',desc_file(train_frames{cidx}(lidx)).name],'h');
        X = h;
        if (option==0)
            load([results_path,Categories.Name{cidx},'/',desc_file(train_frames{cidx}(lidx)).name],'G');
            recons_val = recons_val+norm(X-F*G','fro')^2;
            for i = 1 : class_num
                if (i==cidx)
                    margin_val = margin_val+lambda.*(W(:,i)'*F*G'*ones(size(G,1),1));
                else
                    margin_val = margin_val-lambda.*(W(:,i)'*F*G'*ones(size(G,1),1));
                end
            end
        else
            load([results_path,Categories.Name{cidx},'/',desc_file(train_frames{cidx}(lidx)).name],'newG');
            recons_val = recons_val+norm(X-F*newG','fro')^2;
            for i = 1 : class_num
                if (i==cidx)
                    margin_val = margin_val+lambda.*(W(:,i)'*F*newG'*ones(size(newG,1),1));
                else
                    margin_val = margin_val-lambda.*(W(:,i)'*F*newG'*ones(size(newG,1),1));
                end
            end
        end
        tidx = tidx+1;
    end
end;

return;