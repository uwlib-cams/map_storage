# This program is designed to update map_storage prop_sets based on
# RDA updates by storing the current data, updating the xml documents
# using xslt, and then comparing them to save deprecated properties
# that contain implementation sets
# last updated: 8/29/2023

import os
from textwrap import dedent

# class to store properties 
from store_props import store_props 
from add_props import add_prop, add_sinopia_element

# function to compare two sets of properties and return ones in 1 not in 2
def compare_props(array1, array2):
    deprecated_props = []

    for index1, i in enumerate(array1):
        if(i.sinopia_element != ""):
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
        if (i.sinopia_element != ""):
            for j in array2:
                if(i.prop_iri == j.prop_iri):
                    add_sinopia_element(key, i)

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

saxon_dir_prompt = dedent("""Enter the full directory path of where your Saxon HE .jar file is stored
For example: '~/saxon', 'C:/users/cpayn/saxon', etc.
> """)
saxon_dir = input(saxon_dir_prompt)

saxon_version_prompt = dedent("""Enter your Saxon HE version number (this will be in the .jar file name)
For example: '11.1', '11.4', etc.
> """)
saxon_version = input(saxon_version_prompt)

os.system(f'java -cp {saxon_dir}/saxon-he-{saxon_version}.jar net.sf.saxon.Transform -t -s:xml/get_prop_sets.xml -xsl:xsl/001_01_build_update.xsl')

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
            
            # add sinopia_elements to updated props
            match_props(file_array, new_file_array, new_key)
           
            # compare props to find deprecated ones
            deprecated_props = compare_props(file_array, new_file_array)

            # add deprecated props back to updated files
            add_prop(new_key, deprecated_props)