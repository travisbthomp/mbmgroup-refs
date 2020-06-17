%% SPM PET preprocessing --------------------------------------------------
%  SPM pipepiline performing: ---------------------------------------------
%  1. Create cerebellum mask ----------------------------------------------
%  2. Calculate SUVR based on cerebellum reference ------------------------
%  3. Brain Extraction ----------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% path to ADNI directory
data_dir = '/Volumes/Pavan_SSD/AD_PET/CN/PET/';

% path to ADNI csv file containing subject information
csv_path = '/Volumes/Pavan_SSD/AD_PET/CN/PET/CN_MRImatched_PET_6_16_2020.csv';

% output path for tissue volumes
csv = readtable(csv_path);

subject_ids = csv.('Subject');

subject_groups = csv.('Group');

% list containing paths to subject nii images
subjects = strcat(data_dir, subject_groups, '_', subject_ids, '/', subject_ids, '.nii');


tpm = spm_vol('/Volumes/Pavan_SSD/matlab_pkgs/spm12/tpm/labels_Neuromorphometrics.nii');
output = 'cerebellum_mask.nii';
f = 'i1 >= 38 & i1 <= 39 ';
cerebellar_mask = spm_imcalc(tpm, output, f, 'mask');


for i = 1:lenght(subjects)
    img = spm_vol(subjects{i});
    reference = spm_summarise(img,cerebellar_mask, 'mean');
    f1 = sprintf('i1./%d', reference);
    spm_imcalc(img, path, f1)
end
