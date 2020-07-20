%% SPM SMRI Processing ------------------------------------------------------
% SPM processing pipeline performing:
% 4. Normalise to MNI space 
% 
% This script will only perfrom normalisation of images to MNI space.
% In addition to MRI images, PET image can be entered as inputs. 
%
% The following scripts (preproc 1 & 2) perform: 
% 1 & 2. Segmentation and Tissue Vols
% 3. Creation of Dartel Template 
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
clear all 

%% Create Subject List
spm_path = '/Volumes/Pavan_SSD/matlab_pkgs/spm12';

% path to ADNI directory
data_dir = '/Volumes/Pavan_SSD/Connectome_atrophy/Data/LMCI/';

% load group csv data
group_csv_paths = {'CN/MRI/CN_PETmatched_MRI_6_14_2020.csv',
                   'LMCI/MRI/LMCI_MRImatched_ABTAUPET_6_14_2020.csv'
                   };
subjects_table = [];
for i = 1:length(group_csv_paths)
    group = readtable(strcat(data_dir, group_csv_paths{i}));
    subjects_table = [subjects_table; group]; 
end 

subject_ids = subjects_table.('Subject');

subject_groups = subjects_table.('Group');

subject_modality = subjects_table.('Modality');

% list containing paths to subject nii images
c1 = strcat(data_dir, subject_groups, '/', subject_modality, '/', subject_groups, '_', subject_ids, '/c1', subject_ids, '.nii');

flow_fields = strcat(data_dir, subject_groups, '/', subject_modality, '/', subject_groups, '_', subject_ids, '/u_rc1', subject_ids, '_Template.nii');

DARTEL_template = strcat(data_dir, subject_groups(1), '/', subject_modality(1), '/', subject_groups(1), '_', subject_ids(1), '/Template_6.nii');

%% SPM Batch Processing

matlabbatch{1}.spm.tools.dartel.mni_norm.template(1) = DARTEL_template;
matlabbatch{1}.spm.tools.dartel.mni_norm.data.subjs.flowfields = flow_fields;
matlabbatch{1}.spm.tools.dartel.mni_norm.data.subjs.images{1} = c1;
matlabbatch{1}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                               NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.preserve = 1;
matlabbatch{1}.spm.tools.dartel.mni_norm.fwhm = [8 8 8];
spm_jobman('run',matlabbatch)
