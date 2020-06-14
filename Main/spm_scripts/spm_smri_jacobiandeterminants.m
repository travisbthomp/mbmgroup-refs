% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'/home/sabs-r3/Documents/atrophy_analysis/Development/mbmgroup-refs/Main/spm_scripts/spm_smri_jacobiandeterminants_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'PET');
spm_jobman('run', jobs, inputs{:});
