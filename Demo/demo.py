""" Demo file demonstrating how to load in a graphml, atrophy data and map the atrophy data to the connectome
"""
import os
import nibabel as nib
from Main.Connectome import Connectome

root_dir = os.path.dirname(os.path.realpath(__file__))

#path to graphml
path_to_graphml = root_dir + 'images/master_graphs_highres/33-master/master-std33-highres.graphml'

#read_graphml
Connectome = Connectome(path_to_graphml)

#path to MNI parcellation
path_to_mni_parcellation = root_dir + '../Data/mni_parcellations/mni_template-L2018_desc-scale1_atlas.nii.gz'

#load mni_parcellation image
mni_parcellation = nib.load(path_to_mni_parcellation)

#set connectome coordinates according to mni parcellation
Connectome.get_and_set_coordinates(path_to_mni_parcellation)

#Load Data from Mindboggle/SPM
#Mindboggle