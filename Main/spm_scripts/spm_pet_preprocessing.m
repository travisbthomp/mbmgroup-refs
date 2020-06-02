%% SPM PET Processing ------------------------------------------------------
% SPM processing pipeline performing:
% 1. Registration to mni space
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------

% path to ADNI directory
data_dir = '/Users/pavanchaggar/Documents/PET/';

% path to ADNI csv file containing subject information
csv_path = '/Users/pavanchaggar/Documents/PET/AD_CN_PET_TEST_6_02_2020.csv';

% output path for tissue volumes
csv = readtable(csv_path);

subject_ids = csv.('Subject');

subject_groups = csv.('Group');

% list containing paths to subject nii images
subjects = strcat(data_dir, subject_groups, '_', subject_ids, '/', subject_ids, '.nii');

for i = 1:length(subjects)
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = subjects(i);
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = subjects(i);
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {'/Users/pavanchaggar/Documents/matlab_pkgs/spm12/tpm/TPM.nii'};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
                                                             78 76 85];
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [1.5 1.5 1.5];
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = 'norm';

spm_jobman('run',matlabbatch)
end