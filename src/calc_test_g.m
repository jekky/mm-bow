function calc_test_g(F,FF_inv)
eval('config_file');
[train_frames,test_frames] = do_random_indices(0);

for cidx = 1 : size(test_frames,2)
    desc_file = dir([data_path,Categories.Name{cidx},'/*',desc_ext]);
    for lidx = 1:1:length(test_frames{cidx})
        % fprintf('Reading descriptors of image %s ...\n', desc_file(test_frames{cidx}(lidx)).name);
        load([data_path,Categories.Name{cidx},'/',desc_file(test_frames{cidx}(lidx)).name],'h');
        X = h;        
        newG = (X'*F)*FF_inv;
        
        try
            save([results_path,Categories.Name{cidx},'/',desc_file(test_frames{cidx}(lidx)).name],'newG','-append');
        catch
            save([results_path,Categories.Name{cidx},'/',desc_file(test_frames{cidx}(lidx)).name],'newG');
        end
    end
end;

return;