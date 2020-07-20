%% SPM SMRI Processing ------------------------------------------------------
% SPM processing pipeline performing:
% 1. Segmentation
% 2. Compute tissue volumes
% 
% This script will only perform segmentation and tissue vols calculation on
% a single group of subjects. If needed, run multiple times for multiple
% groups. 
%
%
% The following scripts (preproc 2 & 3) perform: 
% 3. Create Dartel Template
% 4. Normalise to MNI space 
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
clear all 

%% Create Subject List
spm_path = '/Volumes/Pavan_SSD/matlab_pkgs/spm12';

% path to ADNI directory
data_dir = '/Volumes/Pavan_SSD/Connectome_atrophy/Data/LMCI/';

% path to ADNI csv file containing subject information
subjects_csv_path = strcat(data_dir, 'LMCI/MRI/LMCI_MRImatched_ABTAUPET_6_14_2020.csv');
subjects_table = readtable(subjects_csv_path);


% If you wish to run multiple subjects, uncomment the following and add
% subject csv paths. Repeat if necessary and append to subjects array.
%
%group2_csv_path = '/home/sabs-r3/Documents/atrophy_analysis/Data/LMCI_MRI/CN_PETmatched_MRI_6_14_2020.csv';
%group2_csv = readtable(group2_csv_path);

%subjects = [group1_csv; group2_csv];

% output path for tissue volumes
tissue_vol_output = strcat(data_dir, 'LMCI/MRI/tissue_vols.csv');

subject_ids = subjects_table.('Subject');

subject_groups = subjects_table.('Group');

subject_modality = subjects_table.('Modality');

% list containing paths to subject nii images
subjects = strcat(data_dir, subject_groups, '/', subject_modality, '/', subject_groups, '_', subject_ids, '/', subject_ids, '.nii');

mat_files = strcat(data_dir, subject_groups, '/', subject_modality, '/', subject_groups, '_', subject_ids, '/', subject_ids, '_seg8.mat');

%% SPM batch processing
matlabbatch{1}.spm.spatial.preproc.channel.vols = subjects;
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {strcat(spm_path, '/tpm/TPM.nii,1')};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 1];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {strcat(spm_path, '/tpm/TPM.nii,2')};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 1];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {strcat(spm_path, '/tpm/TPM.nii,3')};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {strcat(spm_path, '/tpm/TPM.nii,4')};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {strcat(spm_path, '/tpm/TPM.nii,5')};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {strcat(spm_path, '/tpm/TPM.nii,6')};
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.vox = NaN;
matlabbatch{1}.spm.spatial.preproc.warp.bb = [NaN NaN NaN
                                              NaN NaN NaN];

matlabbatch{2}.spm.util.tvol.matfiles = mat_files;
matlabbatch{2}.spm.util.tvol.tmax = 3;
matlabbatch{2}.spm.util.tvol.mask = {strcat(spm_path, '/tpm/mask_ICV.nii,1')};
matlabbatch{2}.spm.util.tvol.outf = tissue_vol_output;
spm_jobman('run',matlabbatch)


