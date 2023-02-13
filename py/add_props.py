# Functions to add props to xml file
# last updated: 2/10/2023

import xml.etree.ElementTree as ET 
from xml.dom import minidom

#pass file name and deprecated props array
def add_prop(key, props):
    #main file tree
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
    
    for prop in props:
        #if deprecated prop has an implementation set
        if prop.implementation_set != "":
            #create element from prop 
            prop_tree = ET.ElementTree(ET.fromstring(prop.get_prop_string()))
            prop_root = prop_tree.getroot()
            #add deprecated prop to file tree
            root.append(prop_root)

            print(prop.id + " added to " + key)

    #write tree to file
    tree.write(key)

    ##make xml file pretty - might be a better way to do this but it works for now
    final = ""

    with open(key, 'r') as f:
        for line in f:
            strip_line = line.strip()
            final = final + strip_line

    open(key, "w").write(final)
    
    dom = minidom.parse(key)
    with open( key, 'w', encoding='UTF-8') as fh:
        dom.writexml(fh, indent='', addindent='\t', newl='\n', encoding='UTF-8')

    