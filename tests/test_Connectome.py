import unittest
import numpy
import os

from Main.Connectome import Connectome

class TestConnectome(unittest.TestCase):
    root_dir = os.path.split(os.path.dirname(__file__))[0]
    path_to_graph = root_dir + '/Data/master_graphs_highres/33-master/master-std33-highres.graphml'
    path_to_mni_parcellation = root_dir + '/Data/mni_parcellations/mni_template-L2018_desc-scale1_atlas.nii.gz'
    graph = Connectome( filename = path_to_graph)
    #                    parcellated_image_path= path_to_mni_parcellation,
    #                   scale = 1)
    def test_init(self):
        """Test initalisation of Connectome object
        """
        #test identification of file type as graphml
        assert self.path_to_graph.endswith('.graphml') == True

        #test correct attribution of filename
        assert self.path_to_graph == self.graph.filename
        assert self.graph.parcellated_image_path == self.path_to_mni_parcellation

        #test call to _find_tag produces expected result for test graphml
        assert self.graph._region_tag == 'd6'
        assert self.graph._number_of_fibers_tag == 'd9'

    def test_build_graph_graphml(self):
        """testing build_graph function to make the graph from input file
        """
        self.graph.build_graph_graphml()

        assert self.graph.n_Nodes > 0
        assert self.graph.n_edges > 0
        assert self.graph.adj_matrix_full.shape == (self.graph.n_Nodes, self.graph.n_Nodes)
        assert self.graph.coordinates.shape == (self.graph.n_Nodes,3)

    def test_read_graphml(self):
        """Test _read_graphml function
        """
        pass

    def test_read_csv(self):
        """Test _read_csv function
        """
        pass

    def test_find_tag(self):
        """Test find tag function to find tag id for region names
        """
        assert self.graph._find_tag_graphml(tag='dn_name') == 'd6'
        assert self.graph._find_tag_graphml(tag='number_of_fibers') == 'd9'

    def test_get_nodes(self):
        """Test get_nodes function to extract id_numbers and region names from grpahml
        """
        self.graph.get_nodes_graphml()

        assert self.graph.n_Nodes > 0
        assert len(self.graph.node_id) > 0
        assert self.graph.n_Nodes == len(self.graph.node_id)

    def test_define_adjacency_matrix_graphml(self):
        """test function to define the adjacency matrix from a graphml input
        """
        self.graph.get_nodes_graphml()
        self.graph.define_adjacency_matrix_graphml()

        assert self.graph.n_edges > 0
        assert self.graph.n_edges > self.graph.n_Nodes
        assert self.graph.adj_matrix_full.shape == (83,83)
        assert self.graph.adj_matrix_full.shape == (self.graph.n_Nodes,self.graph.n_Nodes)

    def test_get_mni_node_coordinates(self):
        """test function to retrieve node coordinates of parcellated regions in MNI space
        """
        self.graph.get_nodes_graphml()
        self.graph.get_mni_node_coordinates()

        assert self.graph.coordinates.shape[1] == 3
        assert self.graph.coordinates.shape[0] == self.graph.n_Nodes