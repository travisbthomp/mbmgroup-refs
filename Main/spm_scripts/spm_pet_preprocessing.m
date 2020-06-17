%% SPM PET Processing ------------------------------------------------------
% SPM processing pipeline performing:
% 1. Registration to mni space
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
clear all 
% path to ADNI directory
data_dir = '/home/sabs-r3/Documents/AD/CN/';

% path to ADNI csv file containing subject information
pet_csv_path = strcat(data_dir, 'PET/CN_MRImatched_PET_6_16_2020.csv');

% output path for tissue volumes
pet_csv = readtable(pet_csv_path);

subject_ids = pet_csv.('Subject');

pet_group = pet_csv.('Group');

%MRI path 
mri_csv_path = strcat(data_dir, 'MRI/CN_PETmatched_MRI_6_14_2020.csv');

% output path for tissue volumes
mri_csv = readtable(mri_csv_path);

mri_group = pet_csv.('Group');

% list containing paths to subject nii images
mri_image = strcat(data_dir, 'MRI/', mri_group, '_', subject_ids, '/', subject_ids, '.nii');
pet_image = strcat(data_dir, 'PET/', pet_group, '_', subject_ids, '/', subject_ids, '.nii');

for i = 1:length(subject_ids)
matlabbatch{1}.spm.spatial.coreg.estwrite.ref = mri_image(i);
matlabbatch{1}.spm.spatial.coreg.estwrite.source = pet_image(i);
matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'coreg';
spm_jobman('run',matlabbatch)
end


