%% Parcellation Analysis
%Uses SPM to import the Lausanne 2018 MNI parcellation, create regional
%masks and compute mean beta coefficients from an SPM GLM analysis for
%region 


%% User Defined quantities: set directories
clear all 

%----- Important directories ---------------------------------------------

% Set directory to mbmgroup-refs

%----------------------------
% Set the specifics for finding the parcellation atlas to be used in the 
%     parcellation analysis with SPM.  This includes:
% parcellation_file_directory: The base directory where the parcellations 
%                              are stored.  This should be the
%                              `Data/mni_parcellations' subfolder of your
%                              pipeline source code repository.
% parcellation_file_name:      The specific parcellation file you wish to
%                              use.  Note: that any files ending in .tar.gz 
%                              (in the repository) should first be
%                              unzipped to produce the corresponding .nii
%                              file.
% Note: In order to match against simulation results: the same parcellation
% file that was used to generate the connectome (simulation) graph should
% be used, here, to do the parcellation analysis.
%----------------------------
parcellation_file_directory = '/home/t/src/mbmgroup-refs/Data/mni_parcellations/'; %USER SPECIFIED
parcellation_file_name = 'mni-parcellation-scale5_atlas.nii'; %USER SPECIFIED

%---------------------------
% Set the specifics for the parcellation analysis to be run. 
% This includes: 
% base_input_directory: the root directory where your studies reside
% study_subdirectory:   the subdirectory containing the files for this
%                       specific study
% study_image_name:     the specific image (.nii file) you wish to run the 
%                       parcellation analysis on.
%---------------------------
base_input_directory = '/home/t/Documents/repos/ag-tt-conspiracy/revisions/revision-2/adni-ad-data-sorted-aligned/';
study_subdirectory = 'ad-ab-pet/';
study_image_name = 'mean-ss_suvr_ad-ab-pet.nii'; 

input_directory = strcat(base_input_directory,study_subdirectory);

%---------------------------
% Set output directory.
% You will need to specify:
% output_subdirectory: this subdirectory will be created inside the 
%                      directory specified by `input_directory' above.
%                      All output files will be stored here.
%---------------------------
output_subdirectory = 'regional_masks_5/';
%-------------------------------------------------------------------------


%% Other derived quantities
%----
% these quantities are set based on your choices, above.  There is no 
%  need to change the values in this section
%----

% Set / create the output directory
output_directory = [input_directory, output_subdirectory];
if ~exist(output_directory, 'dir')
    mkdir(output_directory)
end

% Get path to MNI parcellation
parcellation_file = [parcellation_file_directory, parcellation_file_name];

% Beta .nii image path 
beta_image_path = [input_directory, study_image_name];

%% SPM-based parcellation analysis: create masks and get mean Beta coefficients
%----
% You should **not** change anything in this section.
%----

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


