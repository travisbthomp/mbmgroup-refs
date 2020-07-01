%% SPM PET preprocessing --------------------------------------------------
%  SPM pipepiline performing: ---------------------------------------------
%  1. Create cerebellum mask ----------------------------------------------
%  2. Calculate SUVR based on cerebellum reference ------------------------
%  3. Brain Extraction ----------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% path to ADNI directory
data_dir = '/Volumes/Pavan_SSD/Connectome_atrophy/Data/LMCI/LMCI/tauPET/';

% path to ADNI csv file containing subject information
csv_path = '/Volumes/Pavan_SSD/Connectome_atrophy/Data/LMCI/LMCI/tauPET/LMCI_MRImatched_ABTAUPET_6_17_2020.csv';

brain_mask_path = '/Volumes/Pavan_SSD/matlab_pkgs/spm12/tpm/mask_ICV.nii';
brain_mask = spm_vol(brain_mask_path);

% output path for tissue volumes
csv = readtable(csv_path);

subject_ids = csv.('Subject');

subject_groups = csv.('Group');

% list containing paths to subject nii images
subjects = strcat(data_dir, subject_groups, '_', subject_ids, '/smwcoreg', subject_ids, '.nii');
suvr_output = strcat(data_dir, subject_groups, '_', subject_ids, '/suvr_', subject_ids, '.nii');
skullstrip_output = strcat(data_dir, subject_groups, '_', subject_ids, '/ss_suvr_', subject_ids, '.nii');

output = 'greycerebellum_mask.nii';

tpm = spm_vol('/Volumes/Pavan_SSD/matlab_pkgs/spm12/tpm/labels_Neuromorphometrics.nii');
f = 'i1 >= 38 & i1 <= 41 ';
cerebellar_mask = spm_imcalc(tpm, output, f, 'mask');


for i = 1:length(subjects)
    img = spm_vol(subjects{i});
    reference = spm_summarise(img,cerebellar_mask, 'mean');
    f1 = sprintf('i1./%d', reference);
    suvr_img = spm_imcalc(img, suvr_output{i}, f1);
    f2 = 'i1.*i2';
    spm_imcalc([suvr_img,brain_mask],skullstrip_output{i},f2)
end


