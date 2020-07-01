%% Parcellation Analysis
%Uses SPM to import the Lausanne 2018 MNI parcellation, create regional
%masks and compute mean beta coefficients from an SPM GLM analysis for
%region 

%% Set directories
clear all 
% Set directory to mbmgroup-refs
working_directory = '/Volumes/Pavan_SSD/Connectome_atrophy/';

% Set input directory 
input_directory = '/Volumes/Pavan_SSD/Connectome_atrophy/Data/LMCI/ab1_stats/';

% Set output directory 
output_directory = [input_directory, 'regional_masks_5/'];
if ~exist(output_directory, 'dir')
    mkdir(output_directory)
end
% Get path to MNI parcellation
parcellation_file = [working_directory, 'sub-01_label-L2018_desc-scale5_atlas.nii'];

% Beta .nii image path 
%beta_image_path = [input_directory, 'beta_0002.nii'];
beta_image_path = [input_directory, 'beta_0002.nii'];

%% Create masks and get mean Beta coefficients
% Read parcellation file 
MNI_parcellation = spm_vol(parcellation_file);

% Get full data array
image_matrix = spm_read_vols(MNI_parcellation);

% Get number of regions present in parcellation
n_regions = max(image_matrix, [], 'all');


% Read Beta image file 
beta_image = spm_vol(beta_image_path);

% Create container for mean beta values 
beta_values = zeros(n_regions,1);

% Compute mask for each region
for index = 1:n_regions
    
    % output file name 
    output_file = [output_directory, sprintf('mask_region_%d.nii', index)];
    
    
    % mask condition 
    f = sprintf('i1==%d', index);
    
    mask = spm_imcalc(parcellation_file, output_file, f, 'mask');

    beta_values(index,1) = spm_summarise(beta_image, mask, 'mean');
end 

% Normalise beta values to highest value
normalised_beta_values = beta_values / max(beta_values);

% Save outputs to csv files
regional_mean_beta_filename = [output_directory, 'regional_mean_beta_coeffcients.csv'];
writematrix(beta_values, regional_mean_beta_filename);

normalised_regional_mean_beta_filename = [output_directory, 'normalised_regional_mean_beta_coeffcients.csv'];
writematrix(normalised_beta_values, normalised_regional_mean_beta_filename);


