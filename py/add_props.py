# Functions to add props to xml file
# last updated: 8/29/2023

import lxml.etree as ET 

#function to add deprecated props to updated files
## pass file name and deprecated props array
def add_prop(key, props):
    #main file tree
    tree = ET.parse(key)
    root = tree.getroot()
    
    for prop in props:
        #if deprecated prop has an implementation set
        if prop.sinopia_element != "":
            #create element from prop 
            prop_root = ET.fromstring(prop.get_prop_string())

            #mark as deprecated 
            if prop.is_deprecated == "":
                dep = ET.SubElement(prop_root, "deprecated")
                dep.text = 'true'

            #add deprecated prop to file tree
            root.append(prop_root)

            print_str = prop.get_prop_iri() + " added to " + key
            print(print_str)

    #write tree to file
    ET.indent(root, '   ')
    tree.write(key, encoding="UTF-8", pretty_print = True)
    del tree

#function to add implementation set back to updated props
##pass file name and implementation set to array
def add_sinopia_element(key, prop):
    #main file tree
    tree = ET.parse(key)
    root = tree.getroot()

    #create element from implementation set 
    prop_root = ET.fromstring(prop.get_sinopia_element())

    #match implementation set to prop
    find_string = ".//{https://uwlib-cams.github.io/map_storage/xsd/}prop_iri[@iri='"+prop.get_prop_iri()+"'].."
    prop_element = root.find(find_string)

    #add implementation set to prop
    prop_element.append(prop_root)

    print_str = "implementation set added to " + prop.get_prop_iri() + " in " + key
    print(print_str)

    #write tree to file
    ET.indent(root, '   ')
    tree.write(key, encoding="UTF-8", pretty_print = True)
    del tree
    
    