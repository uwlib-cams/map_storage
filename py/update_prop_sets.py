# Written by Cypress Payne - 1/2023
# This program is designed to update map_storage prop_sets based on
# RDA updates by storing the current data, updating the xml documents
# using xslt, and then comparing them to save deprecated properties
# that contain implementation sets

import xml.etree.ElementTree as ET 
import re
import os
from textwrap import dedent
#class to store properties 
from prop_storage import Prop
from store_props import store_props 
# just for testing
import sys

# get current xml files from path
path = './'
file_list = os.listdir(path)
file_list = [ elem for elem in file_list if (elem.startswith('prop_set_test'))]
#file_list = [ elem for elem in file_list if (elem.endswith('.xml') 
#    and (elem.startswith('prop_set_rd') or elem.startswith('prop_set_uw')))]

#create dictionary of arrays for each xml file
file_dict = {}
for f in file_list:
    file_dict[f] = []

print(file_dict)
#for each file, store current properties in array 
store_props(file_dict)
print(file_dict)

# i = file_dict.get("prop_set_rdaa_p50k.xml")
# i[0].print_prop()

"""Setup and run XSLT transformation"""

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

new_file_list = os.listdir(path)

new_file_list = [ elem for elem in file_list if (elem.startswith('prop_set_test'))]
## not using dcterms or prov
# new_file_list = [ elem for elem in new_file_list if (elem.endswith('.xml') 
#     and (elem.startswith('prop_set_rd') or elem.startswith('prop_set_uw')))]

print(new_file_list)
#create dictionary of arrays for each xml file
new_file_dict = {}
for f in new_file_list:
    new_file_dict[f] = []

print(new_file_dict)
#for each file, store current properties in array 
store_props(new_file_dict)
print(new_file_dict)

print(sys.getsizeof(file_dict))
print(sys.getsizeof(new_file_dict))
# del(file_dict)

# for key in file_dict.keys():
  #  array1 = file_dict.get(key)
   # for new_key in new_file_dict.keys():
      #  array2 = new_file_dict.get(key)

array1 = file_dict.get("prop_set_test.xml")
array2 = new_file_dict.get("prop_set_test1.xml")
deprecated_props = []

for index1, i in enumerate(array1):
    #print(i.prop_iri)
    # print("index1: ")
    # print(index1)
    length = len(array2)
    print(length)
    for index2, j in enumerate(array2):
        if(i.prop_iri != j.prop_iri):
            length = length - 1
            print(length)
    if length == 0:
        deprecated_props.append(i)
print(len(deprecated_props))
deprecated_props[0].print_prop()
