import unittest
import os

from Main.Connectome import Connectome

class TestConnectome(unittest.TestCase):
    root_dir = os.path.split(os.path.dirname(__file__))[0]
    path_to_graph = root_dir + '/Data/master_graphs_highres/33-master/master-std33-highres.graphml'
    graph = Connectome(path_to_graph)

    def test_init(self):
        """Test initalisation of Connectome object
        """
        #test identification of file type as graphml
        assert self.path_to_graph.endswith('.graphml') == True

        #test correct attribution of filename
        assert self.path_to_graph == self.graph.filename

        #test call to _find_tag produces expected result for test graphml
        assert self.graph._region_tag == self.graph._find_tag_graphml()
        assert self.graph._region_tag == "d6"

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
        assert self.graph._find_tag_graphml() == "d6"

    def test_get_nodes(self):
        """Test get_nodes function to extract id_numbers and region names from grpahml
        """
        self.graph.get_nodes_graphml()

        assert self.graph.n_Nodes > 0
        assert len(self.graph.node_id) > 0
        assert self.graph.n_Nodes == len(self.graph.node_id)


