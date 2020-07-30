from nilearn import plotting
import nibabel as nib
import numpy as np
import matplotlib.pyplot as plt

# path to csv file containing atrophy scores
data_path = '/Users/pavanchaggar/Downloads/AD-img-conspiracy-revision/ad-tau-pet/regional_mean_beta_coeffcients.csv'

#path to csv file containing coordinates for scale 5 connectome
coordinate_path = '/Volumes/Pavan_SSD/Connectome_atrophy/Development/mbmgroup-refs/Data/mni_coordinates/mni-parcellation-scale5_coordinates.csv'

# load atrophy csv
atrophy = np.genfromtxt(data_path)

# load coordinates from csv
coordinates = np.genfromtxt(coordinate_path, delimiter=',')

# threshold (here, mean subtract)
atrophy_norm = (atrophy - (1 * np.mean(atrophy)))

# normalise to max value
atrophy_norm = atrophy_norm / np.max(atrophy_norm)

# remove negative values
atrophy_clipped = np.clip(atrophy_norm, 0, np.max(atrophy_norm))

# set array for transparency
# matplotlib colour arrays have length 258
# first argument is lower bound on transparency (e.g. 0 = totally transparenty)
# second argument is upper bound on transparency (e.g. 1 = opaque)
alpha = np.linspace(-0, 1, 258, endpoint=True)

# set node colours scaled with atrophy
# colour maps can be set by changing 'Blues'. Options are listed:
# https://matplotlib.org/3.1.0/tutorials/colors/colormaps.html. Only
# changing colour maps will work.
atrophy_colour = plt.cm.Blues(atrophy_clipped, alpha)

# identity matrix for nodes
identity = np.identity(len(coordinates))

# plotting
plotting.plot_connectome(node_coords=coordinates,adjacency_matrix=identity, node_color= atrophy_colour, node_size = 60)
plotting.show()
