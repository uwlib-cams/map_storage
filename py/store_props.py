# Functions to create Prop objects
# last updated: 6/28/2023

import xml.etree.ElementTree as ET 
import re

#class to store properties 
from prop_storage import Prop

## function to remove unnecessary namespaces from etree text
def remove_name_space(xml_string): 
    re_ns = ' xmlns="[^ ]*'
    re_uwns = ' xmlns[^>]*'
    re_xml = "<\?xml version='1\.0' encoding='utf8'\?>\n"

    xml_string = re.sub(re_ns, '', xml_string)
    xml_string = re.sub(re_uwns, '', xml_string)
    xml_string = re.sub(re_xml, '', xml_string)
    return xml_string

#create and store props in provide dict
def store_props(file_dict):
    #for each file, store current properties in array 
    for key in file_dict.keys(): 
        #create tree from xml 
        tree = ET.parse(key)

        #namespaces used in files
        ET.register_namespace('', "https://uwlib-cams.github.io/map_storage/xsd/")
        ET.register_namespace('dcam', "http://purl.org/dc/dcam/")
        ET.register_namespace('owl', "http://www.w3.org/2002/07/owl#")
        ET.register_namespace('prov', "http://www.w3.org/ns/prov#")
        ET.register_namespace('rdf', "http://www.w3.org/1999/02/22-rdf-syntax-ns#")
        ET.register_namespace('rdfs', "http://www.w3.org/2000/01/rdf-schema#")
        ET.register_namespace('reg', "http://metadataregistry.org/uri/profile/regap/")
        ET.register_namespace('uwsinopia', "https://uwlib-cams.github.io/sinopia_maps/xsd/")
        ET.register_namespace('xs', "http://www.w3.org/2001/XMLSchema")
        ET.register_namespace('xsi', "http://www.w3.org/2001/XMLSchema-instance")

        root = tree.getroot()

        #for each property, create new prop object and store data in appropriate variables as string 
        for prop in root.iter('{https://uwlib-cams.github.io/map_storage/xsd/}prop'):
            new_prop = Prop(prop.attrib['localid_prop'])
            for child in prop.iter():
                if child.tag == "{https://uwlib-cams.github.io/map_storage/xsd/}prop_iri":
                    new_prop.set_prop_iri(remove_name_space(ET.tostring(child, encoding='utf8').decode('utf8')))
                if child.tag == "{https://uwlib-cams.github.io/map_storage/xsd/}sinopia":
                    new_prop.set_sinopia_element(remove_name_space(ET.tostring(child, encoding='utf8').decode('utf8')))
                if child.tag =="{https://uwlib-cams.github.io/map_storage/xsd/}deprecated":
                    new_prop.set_is_deprecated(remove_name_space(ET.tostring(child, encoding='utf8').decode('utf8')))
            new_prop.set_prop_string(remove_name_space(ET.tostring(prop, encoding='utf8').decode('utf8')))
            #add property to array in dictionary 
            file_dict[key].append(new_prop)

        del(tree)