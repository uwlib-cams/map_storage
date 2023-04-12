# This program is designed to update map_storage prop_sets based on
# RDA updates by storing the current data, updating the xml documents
# using xslt, and then comparing them to save deprecated properties
# that contain implementation sets
# last updated: 4/10/2023

import xml.etree.ElementTree as ET 
import os
from textwrap import dedent
import re

# class to store properties 
from prop_storage import Prop
from store_props import store_props 
from add_props import add_prop, add_implementation_set


# function to compare two sets of properties and return ones in 1 not in 2
def compare_props(array1, array2):
    deprecated_props = []

    for index1, i in enumerate(array1):
        if(i.implementation_set != ""):
            length = len(array2)
            for index2, j in enumerate(array2):
                if(i.prop_iri != j.prop_iri):
                    length = length - 1
            if length == 0:
                deprecated_props.append(i)
    
    return deprecated_props


# function to match properties from two arrays
def match_props(array1, array2, key):

    for i in array1:
        if (i.implementation_set != ""):
            for j in array2:
                if(i.prop_iri == j.prop_iri):
                    add_implementation_set(key, i)


# get current xml files from path
path = './'
file_list = os.listdir(path)

### only for testing 
# file_list = [ elem for elem in file_list if (elem.startswith('prop_set_test'))]

file_list = [ elem for elem in file_list if (elem.endswith('.xml') 
   and (elem.startswith('prop_set_rd') or elem.startswith('prop_set_uw')))]

# create dictionary of arrays for each xml file
file_dict = {}
for f in file_list:
    file_dict[f] = []

# for each file, store current properties in array 
store_props(file_dict)

# Setup and run XSLT transformation

saxon_dir_prompt = dedent("""Enter the name of the directory in which the Saxon HE .jar file is stored
For example: 'saxon', 'saxon11', etc.
> """)
saxon_dir = input(saxon_dir_prompt)

saxon_version_prompt = dedent("""
Enter the Saxon HE version number you'll use for the transformation
For example: '11.1', '11.4', etc.
> """)
saxon_version = input(saxon_version_prompt)

os.system(f'java -cp ~/{saxon_dir}/saxon-he-{saxon_version}.jar net.sf.saxon.Transform -t -s:xml/get_prop_sets.xml -xsl:xsl/001_01_build_update.xsl')

# get updated files
new_file_list = os.listdir(path)

### only for testing 
# new_file_list = [ elem for elem in file_list if (elem.startswith('prop_set_test1'))]

new_file_list = [ elem for elem in new_file_list if (elem.endswith('.xml') 
    and (elem.startswith('prop_set_rd') or elem.startswith('prop_set_uw')))]

# create dictionary of arrays for each xml file
new_file_dict = {}
for f in new_file_list:
    new_file_dict[f] = []

# for each file, store current properties in array
store_props(new_file_dict)

# match files from old prop_sets to new prop_sets 
for key in file_dict.keys():
    file_array = []
    new_file_array = []

    #file_array contains this file's props
    file_array = file_dict.get(key)
    
    for new_key in new_file_dict.keys():
        # for testing using prop_set_test and prop_set_test1 use 
        # if new_key == 'prop_set_test1.xml': 

        #if file names match, store new_file's props in new_file_array
        if new_key == key:
            new_file_array = new_file_dict.get(new_key)
            
            # add implementation_sets to updated props
            match_props(file_array, new_file_array, new_key)
           
            # compare props to find deprecated ones
            deprecated_props = compare_props(file_array, new_file_array)

            # add deprecated props back to updated files
            add_prop(new_key, deprecated_props)

# format XML file
for new_key in new_file_dict.keys():
    with open(new_key, "r") as file:
        filestring = file.read()
        new_xml = '<?xml version="1.0" encoding="UTF-8"?>\n' + filestring + "\n"
        new_xml = re.sub("<sinopia>", "   <sinopia>", new_xml)
        new_xml = re.sub(' \/>', '/>', new_xml)
        new_xml = re.sub("</sinopia></prop>", "</sinopia>\n   </prop>", new_xml)
        new_xml = re.sub('<prop_set [^\n]*\n',
                         '''<prop_set xmlns="https://uwlib-cams.github.io/map_storage/xsd/"
          xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="https://uwlib-cams.github.io/map_storage/xsd/ https://uwlib-cams.github.io/map_storage/xsd/prop_set.xsd">\n''',
                        new_xml)
    with open(new_key, "w") as file:
        file.write(new_xml)