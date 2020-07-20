%% SPM SMRI Processing ------------------------------------------------------
% SPM processing pipeline performing:
% 3. Creation of DARTEL template
% 
% This script will only perfrom the creation of a DARTEL template. 
%
% The following scripts (preproc 1 & 3) perform: 
% 1 & 2. Segmentation and Tissue Vols
% 4. Normalise to MNI space 
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
clear all 

%% Create Subject List
spm_path = '/Volumes/Pavan_SSD/matlab_pkgs/spm12';

% path to ADNI directory
data_dir = '/Volumes/Pavan_SSD/Connectome_atrophy/Data/LMCI/';

% load group csv data
group_csv_paths = {'LMCI/MRI/LMCI_MRImatched_ABTAUPET_6_14_2020.csv',
                   'CN/MRI/CN_PETmatched_MRI_6_14_2020.csv'};
subjects_table = [];
for i = 1:length(group_csv_paths)
    group = readtable(strcat(data_dir, group_csv_paths{i}));
    subjects_table = [subjects_table; group]; 
end 

% set paths to 
subject_ids = subjects_table.('Subject');

subject_groups = subjects_table.('Group');

subject_modality = subjects_table.('Modality');

% list containing paths to subject nii images
rc1 = strcat(data_dir, subject_groups, '/', subject_modality, '/', subject_groups, '_', subject_ids, '/rc1', subject_ids, '.nii');
rc2 = strcat(data_dir, subject_groups, '/', subject_modality, '/', subject_groups, '_', subject_ids, '/rc2', subject_ids, '.nii');

DARTEL_template = strcat(data_dir, subject_groups(1), '_', subject_ids(1), '/', 'Template_6.nii');

%% SPM Batch Processing

matlabbatch{1}.spm.tools.dartel.warp.images{1} = rc1;
matlabbatch{1}.spm.tools.dartel.warp.images{2} = rc2;
matlabbatch{1}.spm.tools.dartel.warp.settings.template = 'Template';
matlabbatch{1}.spm.tools.dartel.warp.settings.rform = 0;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).rparam = [4 2 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).K = 0;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).slam = 16;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).rparam = [2 1 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).K = 0;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).slam = 8;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).rparam = [1 0.5 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).K = 1;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).slam = 4;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).rparam = [0.5 0.25 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).K = 2;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).slam = 2;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).rparam = [0.25 0.125 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).K = 4;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).slam = 1;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).rparam = [0.25 0.125 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).K = 6;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).slam = 0.5;
matlabbatch{1}.spm.tools.dartel.warp.settings.optim.lmreg = 0.01;
matlabbatch{1}.spm.tools.dartel.warp.settings.optim.cyc = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.optim.its = 3;
spm_jobman('run',matlabbatch)

