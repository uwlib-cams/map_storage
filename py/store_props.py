# Functions to create Prop objects
# last updated: 8/29/2023

import lxml.etree as ET 

#class to store properties 
from prop_storage import Prop

#create and store props in provide dict
def store_props(file_dict):
    #for each file, store current properties in array 
    for key in file_dict.keys(): 
        #create tree from xml 
        tree = ET.parse(key)
        root = tree.getroot()

        #for each property, create new prop object and store data in appropriate variables as string 
        for prop in root.iter('{https://uwlib-cams.github.io/map_storage/xsd/}prop'):
            new_prop = Prop(prop.attrib['localid_prop'])
            for child in prop.iter():
                if child.tag == "{https://uwlib-cams.github.io/map_storage/xsd/}prop_iri":
                    new_prop.set_prop_iri(child.attrib["iri"])
                if child.tag == "{https://uwlib-cams.github.io/map_storage/xsd/}sinopia":
                    new_prop.set_sinopia_element(ET.tostring(child, encoding='utf8').decode('utf8'))
                if child.tag =="{https://uwlib-cams.github.io/map_storage/xsd/}deprecated":
                    new_prop.set_is_deprecated(ET.tostring(child, encoding='utf8').decode('utf8'))
            new_prop.set_prop_string(ET.tostring(prop, encoding='utf8').decode('utf8'))
            #add property to array in dictionary 
            file_dict[key].append(new_prop)
        del(tree)