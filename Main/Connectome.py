import numpy as np
import pandas as pd
import nibabel as nib
import xml.etree.ElementTree as ET

class Connectome:
    """Connectome class

    This class contains the main functions required for loading and manipulating connectome graphs
    """

    def __init__(self, filename):
        """__init__ to initialise class

        Arguments:
            filename {str} -- full pathname for the graph csv of graphml
        """
        self.filename = filename

        if filename.endswith('.graphml'):
            self._read_graphml()
        elif filename.endswith('.csv'):
            self._read_csv()


        self._region_tag = self._find_tag_graphml()

        self.n_Nodes = 0
        self.node_id = np.zeros((0, 2))

    def _read_graphml(self):
        #load graphml
        self.__tree = ET.parse(self.filename)
        self.__root = self.__tree.getroot()

    def _read_csv(self):
        pass

    def _find_tag_graphml(self):
        for child in self.__root.getiterator('{http://graphml.graphdrawing.org/xmlns}key'):
            key = child.keys()
            if key[0] == 'attr.name':
                if child.attrib['attr.name'] == 'dn_name':
                    tag_id = child.attrib['id']
                    return tag_id

    def get_nodes_graphml(self):
        """Get node id's and region names
        """
        for node in self.__root[-1].iter('{http://graphml.graphdrawing.org/xmlns}node'):
            id_number =  node.attrib['id']
            children = list(node.iter())
            for child in children:
                key = child.keys()
                if child.attrib[key[0]] == self._region_tag:
                    label = child.text
                    self.n_Nodes += 1
                    self.node_id = np.append(self.node_id, ([[id_number, label]]), axis=0)
