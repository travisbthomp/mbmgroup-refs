import unittest
import os

from Main.Connectome import Connectome

class TestConnectome(unittest.TestCase):
    root_dir = os.path.split(os.path.dirname(__file__))[0]
    path_to_graph = root_dir + '/Data/master_graphs_highres/33-master/master-std33-highres.graphml'
    graph = Connectome(path_to_graph)

    def test_init(self):

        assert self.path_to_graph.endswith('.graphml') == True
        
        assert self.path_to_graph == self.graph.filename