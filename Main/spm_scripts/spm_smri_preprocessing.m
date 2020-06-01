%% SPM Processing ------------------------------------------------------
% SPM processing pipeline performing:
% 1. Segmentation
% 2. Create Dartel Template
% 3. Normalise to MNI space 
% 4. Compute tissue volumes
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------

%% Create Subject List

% path to ADNI directory
data_dir = '/Users/pavanchaggar/Documents/ADNI/';

% path to ADNI csv file containing subject information
csv_path = '/Users/pavanchaggar/Documents/ADNI/adni_baseline1_5_25_2020_less.csv';

% output path for tissue volumes
tissue_vol_output = '/Users/pavanchaggar/Documents/ADNI/tissue_vols.csv';

csv = readtable(csv_path);

subject_ids = csv.('Subject');

% list containing paths to subject nii images
subjects = strcat(data_dir, subject_ids, '/', subject_ids, '.nii');

%% SPM Batch Processing

matlabbatch{1}.spm.spatial.preproc.channel.vols = subjects;
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'/Volumes/Pavan_SSD/matlab_pkgs/spm12/tpm/TPM.nii,1'};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 1];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'/Volumes/Pavan_SSD/matlab_pkgs/spm12/tpm/TPM.nii,2'};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 1];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'/Volumes/Pavan_SSD/matlab_pkgs/spm12/tpm/TPM.nii,3'};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'/Volumes/Pavan_SSD/matlab_pkgs/spm12/tpm/TPM.nii,4'};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'/Volumes/Pavan_SSD/matlab_pkgs/spm12/tpm/TPM.nii,5'};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'/Volumes/Pavan_SSD/matlab_pkgs/spm12/tpm/TPM.nii,6'};
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
                                          
% Create Dartel template
matlabbatch{2}.spm.tools.dartel.warp.images{1}(1) = cfg_dep('Segment: rc1 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{1}, '.','rc', '()',{':'}));
matlabbatch{2}.spm.tools.dartel.warp.images{2}(1) = cfg_dep('Segment: rc2 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{2}, '.','rc', '()',{':'}));
matlabbatch{2}.spm.tools.dartel.warp.settings.template = 'Template';
matlabbatch{2}.spm.tools.dartel.warp.settings.rform = 0;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).rparam = [4 2 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).K = 0;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).slam = 16;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).rparam = [2 1 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).K = 0;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).slam = 8;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).rparam = [1 0.5 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).K = 1;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).slam = 4;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).rparam = [0.5 0.25 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).K = 2;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).slam = 2;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).rparam = [0.25 0.125 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).K = 4;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).slam = 1;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).rparam = [0.25 0.125 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).K = 6;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).slam = 0.5;
matlabbatch{2}.spm.tools.dartel.warp.settings.optim.lmreg = 0.01;
matlabbatch{2}.spm.tools.dartel.warp.settings.optim.cyc = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.optim.its = 3;
matlabbatch{3}.spm.tools.dartel.mni_norm.template(1) = cfg_dep('Run Dartel (create Templates): Template (Iteration 6)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','template', '()',{7}));
matlabbatch{3}.spm.tools.dartel.mni_norm.data.subjs.flowfields(1) = cfg_dep('Run Dartel (create Templates): Flow Fields', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '()',{':'}));
matlabbatch{3}.spm.tools.dartel.mni_norm.data.subjs.images{1}(1) = cfg_dep('Segment: c1 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{1}, '.','c', '()',{':'}));
matlabbatch{3}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
matlabbatch{3}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                               NaN NaN NaN];
matlabbatch{3}.spm.tools.dartel.mni_norm.preserve = 1;
matlabbatch{3}.spm.tools.dartel.mni_norm.fwhm = [8 8 8];

% Compute tissue vols
matlabbatch{4}.spm.util.tvol.matfiles(1) = cfg_dep('Segment: Seg Params', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','param', '()',{':'}));
matlabbatch{4}.spm.util.tvol.tmax = 3;
matlabbatch{4}.spm.util.tvol.mask = {'/Users/pavanchaggar/Documents/matlab_pkgs/spm12/tpm/mask_ICV.nii,1'};
matlabbatch{4}.spm.util.tvol.outf = tissue_vol_output;

spm_jobman('run',matlabbatch)
