%%
addpath('./svm');

database_name = 'WI';
codebook_size = 100;
feature_dim = 131;
conv_thres = 1;
lambda = 500000;

% %%% WI
Categories.Name = {
                   'bend',
                   'jack',
                   'jump',
                   'pjump',
                   'run',
                   'side',
                   'skip',
                   'walk',
                   'wave1',
                   'wave2'
                   };
    
Categories.Frame_Range = { 
%%% WI
[1:9],[1:9],[1:9],[1:9],[1:10],[1:9],[1:10],[1:10],[1:9],[1:9]
                         };

Categories.Train_Test_Portion = 0.5;
Categories.Number = length(Categories.Frame_Range);
%% Global Parameters
class_num = 10;
train_per_class = 5;%8;
test_per_class = 5;

%%

% train_labels = [];
% for i = 1:class_num
%     train_labels = [train_labels,i.*ones(1,train_per_class)];
%     % train_labels = [train_labels,idx.*ones(1,WI_class_inst(idx)-1)];
% end
% test_labels = [];
% for i = 1:class_num
%     test_labels = [test_labels,i.*ones(1,WI_class_inst(i)-train_per_class)];
%     % test_labels = [test_labels,idx.*ones(1,1)];
% end

%% Parth
root_path = '../';
data_path = [root_path,'data/',database_name,'/'];
results_path = [root_path,'results/',database_name,'/'];
img_ext = '.pgm';
desc_ext = '.mat';%'.surf';


dist_folder_path = [results_path,'dist-',database_name,'-SDE/'];

%% svm filename
random_indices_file = [results_path,'random_indices_',database_name,'.mat'];
kmeans_codebook_file = [results_path,'kmeans_codebook_',database_name,'_',num2str(codebook_size),'.mat'];
kmeans_train_histogram_file = [results_path,'kmeans_train_histogram_',database_name,'_',num2str(codebook_size),'.mat'];
kmeans_test_histogram_file = [results_path,'kmeans_test_histogram_',database_name,'_',num2str(codebook_size),'.mat'];
kmeans_train_datafile = [results_path,'train_data_kmeans_',database_name,'.feature'];
kmeans_test_datafile = [results_path, 'test_data_kmeans_',database_name,'.feature'];

cv_file = [results_path,'cv_file_',database_name,'_',num2str(codebook_size),'.mat'];
new_codebook_file = [results_path,'new_codebook_',database_name,'_',num2str(codebook_size),'.mat'];
new_train_histogram_file = [results_path,'new_train_histogram_',database_name,'_',num2str(codebook_size),'.mat'];
new_test_histogram_file = [results_path,'new_test_histogram_',database_name,'_',num2str(codebook_size),'.mat'];
new_train_datafile = [results_path,'new_train_data_',database_name,'.feature'];
new_test_datafile = [results_path, 'new_test_data_',database_name,'.feature'];

combined_codebook_file = [results_path,'combined_codebook_',database_name,'_',num2str(codebook_size),'.mat'];
combined_train_histogram_file = [results_path,'combined_train_histogram_',database_name,'_',num2str(codebook_size),'.mat'];
combined_test_histogram_file = [results_path,'combined_test_histogram_',database_name,'_',num2str(codebook_size),'.mat'];
combined_train_datafile = [results_path,'combined_train_data_',database_name,'.feature'];
combined_test_datafile = [results_path, 'combined_test_data_',database_name,'.feature'];

combined_multiclass_codebook_file = [results_path,'combined_multiclass_codebook_',database_name,'_',num2str(codebook_size),'.mat'];
combined_multiclass_classifier_file = [results_path,'combined_multiclass_classifier.mat'];
combined_multiclass_train_histogram_file = [results_path,'combined_multiclass_train_histogram_',database_name,'_',num2str(codebook_size),'.mat'];
combined_multiclass_test_histogram_file = [results_path,'combined_multiclass_test_histogram_',database_name,'_',num2str(codebook_size),'.mat'];
combined_multiclass_train_datafile = [results_path,'combined_multiclass_train_data_',database_name,'.feature'];
combined_multiclass_test_datafile = [results_path, 'combined_multiclass_test_data_',database_name,'.feature'];

