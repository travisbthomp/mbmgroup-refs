""" Demo file demonstrating how to load in a graphml, atrophy data and map the atrophy data to the connectome
"""
import os
import nibabel as nib
from nilearn import plotting
from Main.Connectome import Connectome

root_dir = os.path.split(os.path.dirname(__file__))[0]

#path to graphml
path_to_graphml = root_dir + '/Data/master_graphs_highres/33-master/master-std33-highres.graphml'

#read_graphml
Connectome = Connectome(filename = path_to_graphml)

#path to MNI parcellation

Connectome.build_graph_graphml()
#Connectome.get_nodes_graphml()
#Connectome.define_adjacency_matrix_graphml()
#Connectome.get_mni_node_coordinates()

plotting.plot_connectome(node_coords=Connectome.coordinates, adjacency_matrix=Connectome.adj_matrix_full)
plotting.show()