%% Calculate mean of images 
clear all;

%--------------------------------------------------------------------------
% Set to the base directory for the data
data_base= '/home/t/Documents/repos/ag-tt-conspiracy/revisions/revision-2/adni-ad-data-sorted-aligned/'; %USER DEFINED

% Set the dataset directory (in the base directory) you want to create the 
% mean field for.  
dataset_dir = 'ad-tau-pet/'; %USER DEFINED
csv_filename= 'ad-tau-pet.csv'; %USER DEFINED
%--------------------------------------------------------------------------

% ---- Derived quantities -------------------------------------------------
data_dir = strcat(data_base,dataset_dir); 
csv = strcat(data_dir, csv_filename);
subjects_table = readtable(csv);
subject_ids = subjects_table.('Subject');
subject_groups = subjects_table.('Group');
subject_modality = subjects_table.('Modality');
% -------------------------------------------------------------------------


% Change this to match your specific directory structure that you have.
%images = strcat(data_dir, subject_groups, '_', subject_ids, '/',subject_ids, '.nii'); %Mean of base image  
images = strcat(data_dir, subject_groups, '_', subject_ids, '/ss_suvr_', subject_ids, '.nii'); %Mean of skull stripped post-processed images


% Change this to change the filename of the output mean field
%output_file_name = 'mean-ad-tau-pet.nii'; %filename for mean base
output_file_name = 'mean-ss_suvr_ad-tau-pet.nii'; %filename for mean skull stripped postprocessed

output_file = strcat(data_dir,output_file_name);

%% Calculate the means command string for use with SPM 
% generate string for summing each subject
N = length(images);

f_str = '';
for index = 1:N
    if index < N
        f_str = strcat(f_str, sprintf('i%d', index), ' +');
    else
        f_str = strcat(f_str, sprintf('i%d', index));
    end
end

% to calculate the mean of (for e.g. 6 images) use, this should read: 
% f = '(i1+i2+i3+i4+i5+i6)/6'
f = strcat('(', f_str, ')/', int2str(N)); 

%% Call SPM
mean = spm_imcalc(images, output_file, f); 
