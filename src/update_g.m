function g_diff = update_g(F,F_inv,W,labels,lambda,option)
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
        newG = (X'*F+((0.5)*lambda*labels(tidx)).*ones(size(X,2),1)*W'*F)*F_inv;
        % newG = (X'*F+((lambda.*0.5*labels(tidx)).*ones(size(X,2),1))*W')*F_inv;
        % newG = (lambda).*(((1/lambda).*(X'*F)+((0.5*labels(tidx)).*ones(size(X,2),1))*W')*F_inv);
        
        % old_margin = W'*G'*ones(size(G,1),1);
        % new_margin = W'*newG'*ones(size(G,1),1);
        old_margin = W'*F*G'*ones(size(G,1),1);
        new_margin = W'*F*newG'*ones(size(newG,1),1);
        old_recons_error = norm(X-F*G','fro')^2;
        new_recons_error = norm(X-F*newG','fro')^2;
        % fprintf('Point %d (label is %d): Old margin is %f and new margin is %f \n',tidx,labels(tidx),old_margin,new_margin);
        fprintf('Point %d (label is %d): Old - %f-%f=%f New - %f-%f=%f \n',tidx,labels(tidx),old_recons_error,old_margin,old_recons_error-old_margin,new_recons_error,new_margin,new_recons_error-new_margin);
        g_diff = g_diff+norm(newG-G,'fro')^2;
        
        save([results_path,Categories.Name{cidx},'/',desc_file(train_frames{cidx}(lidx)).name],'newG','-append'),
        tidx = tidx+1;
    end
end;

return;