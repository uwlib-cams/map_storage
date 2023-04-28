# This program is designed to remove RT id information from prop_set files
# when provided a valid RT id
# last updated: 4/28/2023

from textwrap import dedent
import lxml.etree as ET
import os

# prompt user for resource template id 
def prompt(): 
    id_prompt = dedent("""Enter resource template name
For example: UWSINOPIA_WAU_rdaManifestation_printMonograph_CAMS > """)
    id = input(id_prompt)

    # divide input string into sections (should be 5 sections with current id format)
    split = id.split("_")

    if len(split) == 5:
        return split
    
    # if id is not a valid format, re-prompt user input 
    else:
        error_prompt = dedent(""" RT id not formatted correctly. Re-enter id? (yes/no) > """)
        error = input(error_prompt)
        if error.lower() == "yes":
           return prompt()
        else:
            exit(0)

# prompt() returns array of sections of id [UWSINOPIA, instution, resource, format, user]
id = prompt()

# remove UWSINOPIA from id array 
id.pop(0)

## REMOVAL FUNCTIONS 

# removeSingleID is called only if there is one case of each id element in the implementation_set 
def removeSingleID(prop, sinopiaElement, implementation_set, id, setCount):

    check_id = [False, False, False, False]

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
    if check_id == [True, True, True, True] and setCount == 1:
        prop.remove(sinopiaElement)
        print("sinopia element removed")
    
    # else if the id matches AND there are multiple implementation_sets in the sinopia element
    # remove the matching implementation set ONLY 
    elif check_id == [True, True, True, True] and setCount > 1:
        sinopiaElement.remove(implementation_set)
        print("implementation_set element removed")

# removeMultID is called if there is more than one case of an id element in the implementation_set 
def removeMultiID(implementation_set, id, idNum):
   # for each id element, if there is more than one, only remove the id element that matches the given RT id
   # if the id element matches the RT id but there is only one id element of that type, this is NOT deleted 
   for subelement in implementation_set:
        if subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}institution') and idNum[0] > 1:
            if subelement.text == id[0]:
                implementation_set.remove(subelement)
                print("institution element removed")
        if subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}resource') and idNum[1] > 1:
            if subelement.text == id[1]:
                implementation_set.remove(subelement)
                print("resource element removed")
        if subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}format') and idNum[2] > 1:
            if subelement.text == id[2]:
                implementation_set.remove(subelement)
                print("format element removed")
        if subelement.tag == ('{https://uwlib-cams.github.io/sinopia_maps/xsd/}user') and idNum[3] > 1:
            if subelement.text == id[3]:
                implementation_set.remove(subelement)
                print("user element removed")

def checkSinopia(prop, sinopiaElement, id):
    # count all implementation_set elements within a sinopia element
    setCount = len(sinopiaElement.findall('{https://uwlib-cams.github.io/sinopia_maps/xsd/}implementation_set'))

    # count all id elements within an implementation_set 
    for implementation_set in sinopiaElement:
        hasInstitution = implementation_set.findall('{https://uwlib-cams.github.io/sinopia_maps/xsd/}institution')
        hasResource = implementation_set.findall('{https://uwlib-cams.github.io/sinopia_maps/xsd/}resource')
        hasFormat = implementation_set.findall('{https://uwlib-cams.github.io/sinopia_maps/xsd/}format')
        hasUser = implementation_set.findall('{https://uwlib-cams.github.io/sinopia_maps/xsd/}user')

        idNum = [len(hasInstitution), len(hasResource), len(hasFormat), len(hasUser)]
        # if there is only one instance of each id element, call removeSingleID
        if idNum == [1, 1, 1, 1]:
            removeSingleID(prop, sinopiaElement, implementation_set, id, setCount)
        # else call removeMultiID
        else:
            removeMultiID(implementation_set, id, idNum)
            
# get xml files from path
path = './'
file_list = os.listdir(path)
file_list = [ elem for elem in file_list if (elem.endswith('.xml') 
   and (elem.startswith('prop_set')))]

# parse tree from file
for file in file_list:
    tree = ET.parse(file)
    root = tree.getroot()
    for prop in root:
        # if prop has a sinopia element, check the element for RT id and remove if found
        hasSinopia_list = prop.findall('{https://uwlib-cams.github.io/map_storage/xsd/}sinopia')
        if len(hasSinopia_list) == 1:
            for subelement in prop:
                if subelement.tag == '{https://uwlib-cams.github.io/map_storage/xsd/}sinopia':
                    checkSinopia(prop, subelement, id)

    # write updated tree to file 
    tree.write(file, xml_declaration=True, encoding="UTF-8", pretty_print = True)
