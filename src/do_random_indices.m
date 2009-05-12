function [train_frames,test_frames] = do_random_indices(option)
eval('config_file');

if (option == 0)
    load(random_indices_file,'train_frames','test_frames');
else
    for a=1:Categories.Number %% loop over each category...

      %%% randomly choose indices for training and test...
      random_indices{a} = randperm(length(Categories.Frame_Range{a}));

      %%% get number of training and testing frames
    %   nTraining_Images = 100;
      nTraining_Images = round( length(Categories.Frame_Range{a}) * Categories.Train_Test_Portion);
      nTesting_Images  = length( Categories.Frame_Range{a} ) - nTraining_Images;

      %%% separate frames out into training and testing.....
      train_frames{a} = random_indices{a}(1:nTraining_Images);
      test_frames{a}  = random_indices{a}(nTraining_Images+1:nTraining_Images+nTesting_Images);

      if (nTraining_Images<=1)
        fprintf('Warning: too few training images allocated - please increase Train_Test_Portion\n');
      end   


      if (nTesting_Images<=1)
        fprintf('Warning: too few testing images allocated - please increase Train_Test_Portion\n');
      end

    end


    save(random_indices_file,'random_indices','train_frames','test_frames');
end
  
