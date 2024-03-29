# This program is designed to remove RT id information from prop_set files
# when provided a valid RT id
# last updated: 6/20/2023

from textwrap import dedent
import lxml.etree as ET
import os
import re

## PROMPT FUNCTION

# prompt user for resource template id 
def prompt(): 
    id_prompt = dedent("""Enter resource template name
For example: UWSINOPIA_WAU_rdaManifestation_printMonograph_CAMS > """)
    id = input(id_prompt)

    # divide input string into sections (should be 5 sections with current id format)
    split = id.split("_")
    id_name = id.replace("_", ":")
    # add full id as last in array
    split.append(id_name)

    if len(split) == 6:
        return split
    
    # if id is not a valid format, re-prompt user input 
    else:
        error_prompt = dedent(""" RT id not formatted correctly. Re-enter id? (yes/no) > """)
        error = input(error_prompt)
        if error.lower() == "yes":
           return prompt()
        else:
            exit(0)

## REMOVAL FUNCTIONS 

# if there are multiple implementation_sets, or an implementation_seT with multiple ids
# guidance elements that match the rt_id must be removed 
def check_guidance(sinopia_element, guidance_element, id_name):
    
    for subprop in guidance_element:
        if "rt_id" in subprop.attrib:
            if subprop.attrib["rt_id"] == id_name:
                guidance_element.remove(subprop)
                print("guidance removed")

    if len(list(guidance_element)) == 0:
        sinopia_element.remove(guidance_element)
        print("guidance set removed")

# removeSingleID is called only if there is one case of each id element in the implementation_set 
def remove_single_id(prop, sinopia_element, implementation_set, id, set_count):

    check_id = [False, False, False, False]
    edited = False

    # check the RT id elements in the implementation set to see if the id matches 
    for subelement in implementation_set:
        if subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}institution'):
            if subelement.text == id[0]:
                check_id[0] = True
        if subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}resource'):
            if subelement.text == id[1]:
                check_id[1] = True
        if subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}format'):
            if subelement.text == id[2]:
                check_id[2] = True
        if subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}user'):
            if subelement.text == id[3]:
                check_id[3] = True

    # if every segment of the id matches this implementation set
    # AND there is only one implementation set in the sinopia element
    # remove the whole sinopia element
    if check_id == [True, True, True, True] and set_count == 1:
        prop.remove(sinopia_element)
        print("sinopia element removed")
        edited = True
    
    # else if the id matches AND there are multiple implementation_sets in the sinopia element
    # remove the matching implementation set ONLY 
    elif check_id == [True, True, True, True] and set_count > 1:
        sinopia_element.remove(implementation_set)
        print("implementation_set element removed")
        edited = True

        # remove guidance only if it matches the rt id
        for subelement in sinopia_element:
            if subelement.tag == '{https://uwlib-cams.github.io/sinopia_maps/xsd/}guidance_set':
                check_guidance(sinopia_element, subelement, id[4])
        
    return edited


# removeMultID is called if there is more than one case of an id element in the implementation_set 
def remove_multi_id(sinopia_element, implementation_set, id, id_num):
    check_id = []
    final_check = True 
    edited = False

    # check the RT id elements in the implementation set to see if the id matches 
    for subelement in implementation_set:
        if id_num[0] == 1 and subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}institution'):
            if subelement.text == id[0]:
                check_id.append(True)
            else: 
                check_id.append(False)
        if id_num[1] == 1 and subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}resource'):
            if subelement.text == id[1]:
                check_id.append(True)
            else:
                check_id.append(False)
        if id_num[2] == 1 and subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}format'):
            if subelement.text == id[2]:
                check_id.append(True)
            else:
                check_id.append(False)
        if id_num[3] == 1 and subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}user'):
            if subelement.text == id[3]:
                check_id.append(True)
            else:
                check_id.append(False)
    
    if len(check_id) == 0:
        final_check = False
    else:
        for i in check_id:
            final_check = final_check and i 
        
   # for each id element, if there is more than one, only remove the id element that matches the given RT id
   # if the id element matches the RT id but there is only one id element of that type, this is NOT deleted
    def remove_elements():
        edited = False; 
        for subelement in implementation_set:
            if subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}institution') and id_num[0] > 1:
                if subelement.text == id[0]:
                    implementation_set.remove(subelement)
                    print("institution element removed")
                    edited = True
            if subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}resource') and id_num[1] > 1:
                if subelement.text == id[1]:
                    implementation_set.remove(subelement)
                    print("resource element removed")
                    edited = True 
            if subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}format') and id_num[2] > 1:
                if subelement.text == id[2]:
                    implementation_set.remove(subelement)
                    print("format element removed")
                    edited = True 
            if subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}user') and id_num[3] > 1:
                if subelement.text == id[3]:
                    implementation_set.remove(subelement)
                    print("user element removed")
                    edited = True 
        return edited 

    # rt_id found in implementation_set, remove those elements and check if guidance matches rt_id
    if final_check == True:
        edited = remove_elements()

        # remove guidance only if it matches the rt id
        for subelement in sinopia_element:
            if subelement.tag == '{https://uwlib-cams.github.io/sinopia_maps/xsd/}guidance_set':
                check_guidance(sinopia_element, subelement, id[4])
    
    return edited 

def check_sinopia(prop, sinopia_element, id):

    # count all implementation_set elements within a sinopia element
    set_count = len(sinopia_element.findall('{https://uwlib-cams.github.io/sinopia_maps/xsd/}implementation_set'))
    # count all id elements within an implementation_set 
    for implementation_set in sinopia_element:
        has_institution = implementation_set.findall('{https://uwlib-cams.github.io/sinopia_maps/xsd/}institution')
        has_resource = implementation_set.findall('{https://uwlib-cams.github.io/sinopia_maps/xsd/}resource')
        has_format = implementation_set.findall('{https://uwlib-cams.github.io/sinopia_maps/xsd/}format')
        has_user = implementation_set.findall('{https://uwlib-cams.github.io/sinopia_maps/xsd/}user')

        id_num = [len(has_institution), len(has_resource), len(has_format), len(has_user)]
        # if there is only one instance of each id element, call removeSingleID
        if id_num == [1, 1, 1, 1]:
            edited = remove_single_id(prop, sinopia_element, implementation_set, id, set_count)
        # else call removeMultiID
        else:
            edited = remove_multi_id(sinopia_element, implementation_set, id, id_num)
    return edited

## FORMAT FUNCTION

# format XML file
def format_file(file):
    with open(file, "r") as rfile:
        filestring = rfile.read()
        new_xml = re.sub('<prop_set [^\n]*\n',
                            '''<prop_set xmlns="https://uwlib-cams.github.io/map_storage/xsd/"
          xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="https://uwlib-cams.github.io/map_storage/xsd/ https://uwlib-cams.github.io/map_storage/xsd/prop_set.xsd">\n''',
                            filestring)
        new_xml = re.sub("xml version='1.0' encoding='UTF-8'", '''xml version="1.0" encoding="UTF-8"''', new_xml)
        new_xml = re.sub("</prop_set>", '''</prop_set>
''', new_xml)
        new_xml = re.sub('''      </prop>''', '''   </prop>''', new_xml)
        
    with open(file, "w") as wfile:
        wfile.write(new_xml)
            

## MAIN

# prompt() returns array of sections of id [UWSINOPIA, instution, resource, format, user]
id = prompt()

# remove UWSINOPIA from id array 
id.pop(0)

# get xml files from path
path = './'
file_list = os.listdir(path)
file_list = [ elem for elem in file_list if (elem.endswith('.xml') 
    and (elem.startswith('prop_set_rd') or elem.startswith('prop_set_uw')))]

# parse tree from file
for file in file_list:
    tree = ET.parse(file)
    root = tree.getroot()
    file_edited = False; 
    for prop in root:
        # if prop has a sinopia element, check the element for RT id and remove if found
        hasSinopia_list = prop.findall('{https://uwlib-cams.github.io/map_storage/xsd/}sinopia')
        if len(hasSinopia_list) == 1:
            for subelement in prop:
                if subelement.tag == '{https://uwlib-cams.github.io/map_storage/xsd/}sinopia':
                    edited = check_sinopia(prop, subelement, id)
                    file_edited = edited or file_edited

    # write updated tree to file (only if file was changed)
    if file_edited == True:
        tree.write(file, xml_declaration=True, encoding="UTF-8")
        format_file(file)
        print("tree written to file")