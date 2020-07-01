import os
import numpy as np
import pandas as pd
import nibabel as nib
from nilearn import plotting
import xml.etree.ElementTree as ET

class Connectome:
    """Connectome class

    This class contains the main functions required for loading and manipulating connectome graphs
    """

    def __init__(self,
                filename:str,
                scale:int = 1,
                parcellated_image_path:str = None):
        """__init__ to initialise class

        Arguments:
            filename {str} -- full pathname for the graph csv of graphml
        """
        #initalise input variables
        self.filename = filename
        self.scale = scale

        if parcellated_image_path == None:
            root_dir = os.path.split(os.path.dirname(__file__))[0]
            if root_dir.endswith('mbmgroup-refs'):
                pass
            elif root_dir.endswith('site-packages'):
                directory_list = os.path.split(os.path.dirname(__file__))[0].split('/')
                root_dir = '/'.join(directory_list[:-4])
            else:
                pass
            self.parcellated_image_path = root_dir + f'/Data/mni_parcellations/mni-parcellation-scale{self.scale}_atlas.nii.gz'
        else:
            self.parcellated_image_path = parcellated_image_path

        #read graph format
        if filename.endswith('.graphml'):
            self._read_graphml()
        elif filename.endswith('.csv'):
            self._read_csv()

        #get tags needed
        self._region_tag = self._find_tag_graphml(tag = 'dn_name')
        self._number_of_fibers_tag = self._find_tag_graphml(tag = 'number_of_fibers')

        #initialise graph variables
        self.n_Nodes = 0
        self.node_id = np.zeros((0, 2))
        self.n_edges = 0
        self.adj_matrix_full = np.zeros((0,0))
        self.coordinates = None

        # Variable for Dataframe
        self.dataframe = None

    def build_graph_graphml(self, csv_outfile:str):
        self.get_nodes_graphml()
        self.define_adjacency_matrix_graphml()
        self.get_mni_node_coordinates()
        self._create_dataframe()
        self._save_dataframe(csv_filename=csv_outfile)


    def build_graph_csv(self):
        pass

    def _read_graphml(self):
        #load graphml
        self.__tree = ET.parse(self.filename)
        self.__root = self.__tree.getroot()

    def _read_csv(self):
        pass

    def _find_tag_graphml(self, tag:str):
        for child in self.__root.iter('{http://graphml.graphdrawing.org/xmlns}key'):
            key = child.keys()
            if key[0] == 'attr.name':
                if child.attrib['attr.name'] == tag:
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

    def define_adjacency_matrix_graphml(self):
        """Define the adjacency matrix based from graphml
        """
        #initaialise full adjacency matrix
        self.adj_matrix_full = np.zeros((self.n_Nodes,self.n_Nodes))

        #populate full adjacency matrix
        self.n_edges = 0
        for child in self.__root.iter('{http://graphml.graphdrawing.org/xmlns}edge'):
            self.n_edges += 1
            source = child.keys()[0]
            target = child.keys()[1]
            x, y = int(child.attrib[source]), int(child.attrib[target])
            for children in child.iter('{http://graphml.graphdrawing.org/xmlns}data'):
                #print(children.keys())
                for keys in children.keys():
                    if children.attrib[keys] == self._number_of_fibers_tag:
                        n_fibers = float(children.text)
            self.adj_matrix_full[x-1,y-1] = 1.0 * n_fibers
            self.adj_matrix_full[y-1,x-1] = 1.0 * n_fibers

        #normalise adjacency matrix to highest value
        #adj_matrix_full = adj_matrix_full / np.amax(adj_matrix_full)

    def get_mni_node_coordinates(self):
        """Retrieve node coordinates in MNI space from MNI parcellated brain
        """
        image = nib.load(self.parcellated_image_path)
        self.coordinates = plotting.find_parcellation_cut_coords(image)

    def _create_dataframe(self):
        """Create dataframe to output regional number and labels, coordinates
        """

        self._base_columns = ['ID','Label','x','y','z']

        #create data by concatenating id_nodes with connectome_coords
        data = np.concatenate((self.node_id, self.coordinates), axis=1)

        #create coords
        self.graphml_data = pd.DataFrame(data, index=range(self.n_Nodes), columns=self._base_columns)

    def _add_to_dataframe(self, column_name:str, input_data):
        """Append columns to dataframe
        """
        self.graphml_data[column_name] = input_data

    def _save_dataframe(self, csv_filename:str):
        """Save dataframe
        """
        self.graphml_data.to_csv(csv_filename)